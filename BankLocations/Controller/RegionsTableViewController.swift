//
//  ViewController.swift
//  BankLocations
//
//  Created by Alexander Sokhin on 09.10.2020.
//

import UIKit

//MARK: regions table view controller (show regions)

class RegionsTableViewController: UITableViewController {
    
    //core data object
    private let dataController = DataController(modelName: "BankLocations")
    
    @IBOutlet var contentTableView: UITableView!
    private var countries:[Country] = []
    
    private var selectedRegion: Region?
    
    private var locationsUpdater: LocationsUpdater?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataController.load()
        
        countries = dataController.getCountries()
        if countries.count < 1 {
            dataController.setCountries()
            countries = dataController.getCountries()
        }
        
        locationsUpdater = LocationsUpdater(dataController: self.dataController, countries: countries)
        
        //update data
        locationsUpdater!.startUpdate(controllerDelegate: self, checkTime: false)
    }
    
    // MARK: Table View Sections (header of sections)
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //return self.tableSections[section]
        return countries[section].name
    }
    
    // MARK: Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //return self.tableSections.count
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let regions = countries[section].regions {
            return regions.allObjects.count
        }
        
        //return regions.count
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegionTableViewCell")!
        
        let regions = getSortedRegions(countryIndex: indexPath.section)
        cell.textLabel?.text = regions[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let regions = getSortedRegions(countryIndex: indexPath.section)
        selectedRegion = regions[indexPath.row]
        performSegue(withIdentifier: "LocationsSegue", sender: self)
    }
    
    //MARK: segue for next controller

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LocationsSegue" {
            let controller = segue.destination as! LocationsTableViewController
            controller.dataController = dataController
            controller.region = selectedRegion
        }
    }
    
    private func getSortedRegions(countryIndex: Int) -> [Region] {
        if let regions = countries[countryIndex].regions?.allObjects as? [Region] {
            return regions.sorted(by: { $0.name! < $1.name! })
        }
        
        return []
    }
    
    //MARK: button for update locations
    
    @IBAction func updateLocations(_ sender: Any) {
        locationsUpdater!.startUpdate(controllerDelegate: self)
    }
    
}

//MARK: protocol implementation for updating table view

extension RegionsTableViewController: UpdatingDelegate {
    func didUpdate() {
        countries = dataController.getCountries()
        
        DispatchQueue.main.async {
            self.contentTableView.reloadData()
        }
    }
}

