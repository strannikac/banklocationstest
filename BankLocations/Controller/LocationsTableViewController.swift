//
//  LocationsTableViewController.swift
//  BankLocations
//
//  Created by Alexander Sokhin on 16.10.2020.
//

import UIKit

//MARK: locations table view controller (show locations by region)

class LocationsTableViewController: UITableViewController {
    
    //vars from parent controller
    var dataController: DataController!
    var locationsUpdater: LocationsUpdater!
    
    var countryId: Int16 = 0
    var regionName: String = ""
    
    @IBOutlet var contentTableView: UITableView!
    
    private var locations:[Location] = []
    private var locationTypes:[LocationType] = []
    private var selectedLocation: Location?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTypes = LocationType.list
        
        if regionName != "" {
            self.title = regionName
        }
        
        self.didUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.locationsUpdater.start(controller: self)
    }
    
    // MARK: Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell") as! LocationTableViewCell
        
        let type = Int(self.locations[indexPath.row].type)
        
        cell.nameLabel.text = self.locations[indexPath.row].name
        cell.addressLabel.text = self.locations[indexPath.row].address
        
        cell.isoLabel.text = self.locationTypes[type].iso
        cell.isoLabel.backgroundColor = self.locationTypes[type].bgColor
        cell.isoLabel.layer.masksToBounds = true
        cell.isoLabel.layer.cornerRadius = cell.isoLabel.bounds.width / 2
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedLocation = self.locations[indexPath.row]
        performSegue(withIdentifier: "LocationDetailsSegue", sender: self)
    }
    
    //MARK: segue for next controller

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LocationDetailsSegue" {
            let controller = segue.destination as! LocationDetailsViewController
            controller.location = self.selectedLocation
        }
    }
}

//MARK: protocol implementation for updating table view

extension LocationsTableViewController: UpdatingDelegate {
    func didUpdate() {
        var isErr = false
        
        //get region by country id and name
        if(self.countryId > 0 && self.regionName != "") {
            let currentRegion = self.dataController.getRegionByNameAndCountry(name: self.regionName, country: self.countryId)
            
            if let region = currentRegion, let regionLocations = region.locations {
                self.locations = regionLocations.allObjects as! [Location]
                self.locations.sort(by: { $0.name! < $1.name! })
                
                DispatchQueue.main.async {
                    self.contentTableView.reloadData()
                }
            } else {
                isErr = true
            }
        } else {
            isErr = true
        }
        
        if isErr {
            AlertView.show(title: StringConstants.notice.rawValue, message: StringConstants.errEmptyData.rawValue, controller: self)
        }
    }
}
