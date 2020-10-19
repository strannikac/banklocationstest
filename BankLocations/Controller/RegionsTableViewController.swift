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
    private var tableSections:[String] = []
    private var regions:[[Region]] = []
    private var countries:[Country] = []
    
    private var selectedRegion: Region?
    
    private var locationsUpdater: LocationsUpdater?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataController.load()
        
        self.countries = Country.list
        for country in self.countries {
            tableSections.append(country.name)
            regions.append([])
        }
        
        self.locationsUpdater = LocationsUpdater(dataController: self.dataController)
        
        //update data
        if let locationsUpdater = self.locationsUpdater {
            locationsUpdater.start(controller: self, checkTime: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let locationsUpdater = self.locationsUpdater {
            locationsUpdater.start(controller: self)
        }
    }
    
    // MARK: Table View Sections (header of sections)
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.tableSections[section]
    }
    
    // MARK: Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableSections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.regions[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegionTableViewCell")!
        
        cell.textLabel?.text = self.regions[indexPath.section][indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRegion = self.regions[indexPath.section][indexPath.row]
        performSegue(withIdentifier: "LocationsSegue", sender: self)
    }
    
    //MARK: segue for next controller

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LocationsSegue" {
            let controller = segue.destination as! LocationsTableViewController
            controller.dataController = self.dataController
            controller.locationsUpdater = self.locationsUpdater
            
            if let name = self.selectedRegion?.name, let country = self.selectedRegion?.countryId {
                controller.countryId = country
                controller.regionName = name
            }
        }
    }
}

//MARK: protocol implementation for updating table view

extension RegionsTableViewController: UpdatingDelegate {
    func didUpdate() {
        //get regions by country id
        let count = self.countries.count
        for i in 0..<count {
            self.regions[i] = self.dataController.getRegionsByCountry(country: self.countries[i].id)
        }
        
        DispatchQueue.main.async {
            self.contentTableView.reloadData()
        }
    }
}

