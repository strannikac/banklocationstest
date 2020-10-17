//
//  LocationsUpdater.swift
//  BankLocations
//
//  Created by Alexander Sokhin on 11.10.2020.
//

import Foundation
import UIKit

//MARK: Location Updater - updating location data process

class LocationsUpdater {
    
    private var dataController: DataController = (UIApplication.shared.delegate as? AppDelegate)!.dataController
    
    private let updateTimeSeconds: Int64 = 3600
    
    //vars for updating process
    private var isUpdatingData = false
    private var updatingDataCount = 0
    private var updatingDataTotal = 0
    private var checkUpdatingTime = true
    
    private var countries: [Country] = []
    
    //vars for view controller
    private var updatingController: UpdatingDelegate? = nil
    private var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    //MARK: updating process functions
    
    //start to update bank locations data
    func start(controller: UpdatingDelegate, checkTime: Bool = true) {
        let isTIme = self.isUpdateTime()
        
        if !self.isUpdatingData && (!checkTime || isTIme) {
            //set var for updating data (in true)
            self.isUpdatingData = true
            
            self.checkUpdatingTime = checkTime
            self.updatingController = controller
            
            //show uploading indicator
            self.createActivityIndicator()
            
            //remove all local data
            self.dataController.resetAllData()
            
            //get data from url and save it in local store
            self.countries = Country.list
            self.updatingDataTotal = self.countries.count
            self.updatingDataCount = 0
            
            //start with first country
            ClientAPI.getLocationsByCountry(country: countries[0], completion: self.saveResponseData(country:items:error:))
        }
    }
    
    //continue - get locations from next country/link
    private func next() {
        self.updatingDataCount += 1
        
        if self.updatingDataCount >= self.updatingDataTotal {
            //update data in controller
            self.updatingController?.didUpdate()
            
            //hide and remove indicator
            self.setActivityIndicator(show: false)
            self.removeActivityIndicator()
            
            self.isUpdatingData = false
            
            //save last update time in user defaults
            let seconds = ClientHelper.getSeconds()
            UserDefaults.standard.set(seconds, forKey: "lastUpdatedTime")
        } else {
            //get data for next country
            ClientAPI.getLocationsByCountry(country: self.countries[self.updatingDataCount], completion: self.saveResponseData(country:items:error:))
        }
    }
    
    //start again or continue uploading data process (after error, for example)
    private func continueAfterError() {
        /* here may be another way, for example:
         1) we can continue process with next country (link)
         2) we can do some delay (10 seconds, for example) and start process again after delay
         Now we start process again without delay (we guess we need all data from all countries or nothing
         */
        self.start(controller: self.updatingController!, checkTime: self.checkUpdatingTime)
    }
    
    //save response data in local store
    private func saveResponseData(country: Country, items: [LocationItem], error: String?) {
        if let error = error {
            //if get error, show alert and stop uploading
            AlertView.show(title: StringConstants.error.rawValue, message: error, controller: self.updatingController!, handler: continueAfterError)
            
            //hide and remove indicator
            self.setActivityIndicator(show: false)
            self.removeActivityIndicator()
            
            self.isUpdatingData = false
        } else {
            //transform in new structure and remove duplicates
            let newItems = self.splitByRegion(from: items)
            
            //save items in local store
            self.dataController.saveLocationsByCountry(country: country.id, items: newItems)
            
            //next country/link
            self.next()
        }
    }
    
    //create dictionary of regions with locations array, also remove duplicates
    private func splitByRegion(from array: [LocationItem]) -> [String:[LocationItem]] {
        var newArray: [LocationItem] = []
        var newStructureArray: [String:[LocationItem]] = [:]
        
        for item in array {
            //check the same name, latitude and longitude
            if !newArray.contains(where: { $0.n == item.n && $0.lat == item.lat && $0.lon == item.lon }) {
                newArray.append(item)
                
                //check region in dictionary
                if(newStructureArray[item.r] == nil) {
                    //create region in dictionary
                    newStructureArray[item.r] = []
                    newStructureArray[item.r]!.append(item)
                } else {
                    //exists, add location
                    newStructureArray[item.r]!.append(item)
                }
            }
        }
        
        newArray = []
        
        return newStructureArray
    }
    
    //check update time
    func isUpdateTime() -> Bool {
        if let lastTime = UserDefaults.standard.object(forKey: "lastUpdatedTime") as? Int64 {
            let nowSeconds = ClientHelper.getSeconds()
            
            if (nowSeconds - lastTime) < self.updateTimeSeconds {
                return false
            }
        }
        
        return true
    }
    
    //MARK: functions for activity indicator
    
    //create activity indicator in controller
    private func createActivityIndicator() {
        if let controller = self.updatingController {
            DispatchQueue.main.async {
                let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
                controller.view.addSubview(indicator)
                
                indicator.backgroundColor = UIColor.white.withAlphaComponent(0.8)
                indicator.color = .red
                indicator.style = .large
                
                indicator.translatesAutoresizingMaskIntoConstraints = false
                
                let navigationBarHeight = controller.navigationController?.navigationBar.bounds.height ?? 0
                let tabBarHeight = controller.tabBarController?.tabBar.bounds.height ?? 0
                
                let w = controller.view.bounds.size.width
                let h = controller.view.bounds.size.height - navigationBarHeight - tabBarHeight - 20
                
                indicator.widthAnchor.constraint(equalToConstant: w).isActive = true
                indicator.heightAnchor.constraint(equalToConstant: h).isActive = true
                
                indicator.hidesWhenStopped = true
                indicator.center = controller.view.center
                
                self.activityIndicatorView = indicator
                
                self.setActivityIndicator(show: true)
            }
        }
    }
    
    //show or hide activity indicator
    private func setActivityIndicator(show: Bool) {
        DispatchQueue.main.async {
            self.activityIndicatorView.isHidden = !show
            self.updatingController?.view.isUserInteractionEnabled = !show
            
            if show {
                self.activityIndicatorView.startAnimating()
            } else {
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    private func removeActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicatorView.removeFromSuperview()
        }
    }
}
