//
//  DataController.swift
//  BankLocations
//
//  Created by Alexander Sokhin on 10.10.2020.
//  Copyright © 2020 DreamsFM. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext!
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        backgroundContext = persistentContainer.newBackgroundContext()
    }
    
    func configureContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        //backgroundContext.mergePolicy = NSMergePolicy.overwrite
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            
            self.configureContexts()
            completion?()
        }
    }
}

//MARK: remove and save data

extension DataController {
    //save context in local store
    func saveContext(forContext context: NSManagedObjectContext) {
        if context.hasChanges {
            context.performAndWait {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    print("Error when saving! \(nserror.localizedDescription)")
                    print("Callstack:")
                    for symbol: String in Thread.callStackSymbols {
                        print(" > \(symbol)")
                    }
                }
            }
        }
    }
    
    //save locations data in local store by country id
    func saveLocationsByCountry(country: Country, items: [String:[LocationItem]]) {
        //create private NSManagedObjectContext
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = backgroundContext
        
        if let countryName = country.name {
            //select country in current context
            let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
            let predicate = NSPredicate(format: "name == %@", countryName)
            fetchRequest.predicate = predicate
        
            let res = try? privateMOC.fetch(fetchRequest)
            
            if let res = res {
                let currentCountry = res[0]
                
                //clear regions for this country
                let deletedPredicate = NSPredicate(format: "ANY country.name = %@", currentCountry.name!)
                
                let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Region")
                deleteFetch.predicate = deletedPredicate
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

                do {
                    try privateMOC.execute(deleteRequest)
                    saveContext(forContext: privateMOC)
                } catch let error as NSError {
                    //error
                    print("error in removeing data for country: \(error.localizedDescription)")
                }
        
                //by region
                for item in items {
                    let region = Region(context: privateMOC)
                    region.name = item.key
                    region.country = currentCountry
                    
                    //by location in this region
                    for locationItem in item.value {
                        let location = Location(context: privateMOC)
                        
                        location.latitude = locationItem.latitude
                        location.longitude = locationItem.longitude
                        location.name = locationItem.name
                        location.address = locationItem.address
                        location.type = locationItem.type
                        location.availability = locationItem.availability ?? ""
                        location.info = locationItem.info ?? ""
                        location.nocash = locationItem.nocash ?? false
                        location.coinStation = locationItem.coinStation ?? false
                        
                        location.region = region
                    }
                    
                    privateMOC.performAndWait {
                        saveContext(forContext: privateMOC)
                    }
                }
                
                //sava all regions and locations
                saveContext(forContext: backgroundContext)
            }
        }
    }
}

//MARK: select data and set countries (if countries don't exist)

extension DataController {
    //get countries
    func getCountries() -> [Country] {
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
    
        do {
            let res = try viewContext.fetch(fetchRequest)
            if res.count > 0 {
                return res
            }
        } catch {
            print("error selecting countries from local")
        }
        
        return []
    }
    
    //set countries
    func setCountries() {
        let countries = CountryConfig.list
        
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = backgroundContext
        
        for item in countries {
            let country = Country(context: privateMOC)
            country.name = item.name
            country.endpoint = item.endpoint
            
            privateMOC.performAndWait {
                saveContext(forContext: privateMOC)
            }
        }
        
        //sava all regions and locations
        saveContext(forContext: backgroundContext)
    }
}
