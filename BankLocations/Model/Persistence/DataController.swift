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
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            
            //self.autoSaveViewContext()
            self.configureContexts()
            completion?()
        }
    }
}

//MARK: remove and save data

extension DataController {
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
    
    //clear all tables in local store
    func resetAllData() {
        // get all entities and loop over them
        let entityNames = self.persistentContainer.managedObjectModel.entities.map({ $0.name! })
        
        entityNames.forEach { [weak self] entityName in
            //create private NSManagedObjectContext
            let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateMOC.parent = self?.viewContext
            
            privateMOC.performAndWait {
                
                let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
                
                do {
                    try privateMOC.execute(deleteRequest)
                } catch let error as NSError {
                    //error
                    print("error in reseting data for entity: \(error.localizedDescription)")
                }
                
                self!.saveContext(forContext: privateMOC)
                
            }
            
            self?.saveContext(forContext: self!.viewContext)
        }
    }
    
    //save locations data in local store by country id
    func saveLocationsByCountry(country: Int, items: [String:[LocationItem]]) {
        //create private NSManagedObjectContext
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = self.viewContext
        
        //by region
        for item in items {
            let region = Region(context: privateMOC)
            region.countryId = Int16(country)
            region.name = item.key
            
            //by location in this region
            for locationItem in item.value {
                let location = Location(context: privateMOC)
                
                location.latitude = locationItem.lat
                location.longitude = locationItem.lon
                location.name = locationItem.n
                location.address = locationItem.a
                location.type = Int16(locationItem.t)
                location.availability = locationItem.av ?? ""
                location.info = locationItem.i ?? ""
                location.nocash = locationItem.ncash ?? false
                location.coinStation = locationItem.cs ?? false
                
                location.region = region
            }
            
            privateMOC.performAndWait {
                self.saveContext(forContext: privateMOC)
            }
        }
        
        //sava all regions and locations
        self.saveContext(forContext: self.viewContext)
    }
}

//MARK: select data

extension DataController {
    //get regions by country id and sort by name
    func getRegionsByCountry(country: Int, sortBy: String = "name", isAsc: Bool = true) -> [Region] {
        let fetchRequest: NSFetchRequest<Region> = Region.fetchRequest()
        let predicate = NSPredicate(format: "countryId == %i", Int16(country))
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: sortBy, ascending: isAsc)
        fetchRequest.sortDescriptors = [sortDescriptor]
    
        do {
            let res = try self.viewContext.fetch(fetchRequest)
            if res.count > 0 {
                return res
            }
        } catch {
            print("error selecting regions from local: \(country)")
        }
        
        return []
    }
    
    //get one region by name and country id
    func getRegionByNameAndCountry(name: String, country: Int16) -> Region? {
        let fetchRequest: NSFetchRequest<Region> = Region.fetchRequest()
        let predicate = NSPredicate(format: "countryId == %i AND name == %@", country, name)
        fetchRequest.predicate = predicate
    
        do {
            let res = try self.viewContext.fetch(fetchRequest)
            if res.count > 0 {
                return res[0]
            }
        } catch {
            print("error selecting region from local: \(name)")
        }
        
        return nil
    }
}
