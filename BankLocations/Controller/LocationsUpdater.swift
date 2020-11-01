//
//  LocationsUpdater.swift
//  BankLocations
//
//  Created by Alexander Sokhin on 11.10.2020.
//

import Foundation

//MARK: Location Updater - updating location data process

class LocationsUpdater {
    
    private let dataController: DataController
    
    private let updateTimeSeconds: Int64 = 3600
    
    //vars for updating process
    private var isUpdatingData = false
    private var updatingDataCount = 0
    private var updatingDataTotal = 0
    private var checkUpdatingTime = true
    
    private var countries: [Country] = []
    
    //vars for view controller
    private weak var updatingController: UpdatingDelegate?
    private var activityIndicatorHelper = ActivityIndicatorHelper()
    
    private var clientAPI: ClientAPI
    
    private var error: String = ""
    
    init(dataController: DataController, countries: [Country]) {
        self.dataController = dataController
        clientAPI = ClientAPI()
        self.countries = countries
    }
    
    //MARK: updating process functions
    
    //start to update bank locations data
    func startUpdate(controllerDelegate controller: UpdatingDelegate, checkTime: Bool = true) {
        let isTIme = isUpdateTime()
        
        if !isUpdatingData && (!checkTime || isTIme) {
            //set var for updating data (in true)
            isUpdatingData = true
            
            checkUpdatingTime = checkTime
            updatingController = controller
            
            //show uploading indicator
            activityIndicatorHelper.createActivityIndicator(forController: updatingController!)
            
            //get data from url and save it in local store
            updatingDataTotal = self.countries.count
            updatingDataCount = 0
            
            for country in self.countries {
                clientAPI.getLocationsByCountry(country: country, completion: saveResponseData(country:items:error:))
            }
        }
    }
    
    //continue - get locations from next country/link
    private func nextLocations() {
        updatingDataCount += 1
        
        if updatingDataCount >= updatingDataTotal {
            //update data in controller
            updatingController?.didUpdate()
            
            isUpdatingData = false
            
            //save last update time in user defaults
            let seconds = getSeconds()
            UserDefaults.standard.set(seconds, forKey: "lastUpdatedTime")
            
            if error != "" {
                AlertView.show(title: StringConstants.error.rawValue, message: error, controller: updatingController!)
            }
            
            //hide and remove indicator
            activityIndicatorHelper.setActivityIndicator(forController: updatingController!, show: false)
            activityIndicatorHelper.removeActivityIndicator()
        }
    }
    
    //save response data in local store
    private func saveResponseData(country: Country, items: [LocationItem], error: String?) {
        if let error = error {
            //if get error, save error
            self.error += error
        } else {
            //transform in new structure and remove duplicates
            let newItems = splitByRegion(from: items)
            
            //save items in local store
            dataController.saveLocationsByCountry(country: country, items: newItems)
            
            //next country/link
            nextLocations()
        }
    }
    
    //create dictionary of regions with locations array, also remove duplicates
    private func splitByRegion(from array: [LocationItem]) -> [String:[LocationItem]] {
        var newArray: [LocationItem] = []
        var newStructureArray: [String:[LocationItem]] = [:]
        
        for item in array {
            //check the same name, latitude and longitude
            if !newArray.contains(where: { $0.name == item.name && $0.latitude == item.latitude && $0.longitude == item.longitude }) {
                newArray.append(item)
                
                //check region in dictionary
                if(newStructureArray[item.regionName] == nil) {
                    //create region in dictionary
                    newStructureArray[item.regionName] = []
                    newStructureArray[item.regionName]!.append(item)
                } else {
                    //exists, add location
                    newStructureArray[item.regionName]!.append(item)
                }
            }
        }
        
        newArray = []
        
        return newStructureArray
    }
    
    //check update time
    func isUpdateTime() -> Bool {
        if let lastTime = UserDefaults.standard.object(forKey: "lastUpdatedTime") as? Int64 {
            let nowSeconds = getSeconds()
            
            if (nowSeconds - lastTime) < updateTimeSeconds {
                return false
            }
        }
        
        return true
    }
    
    func getSeconds(forDate date: Date = Date()) -> Int64 {
        return Int64(date.timeIntervalSince1970)
    }
}
