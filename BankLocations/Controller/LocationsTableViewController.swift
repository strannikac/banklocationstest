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
    
    var region: Region!
    
    @IBOutlet var contentTableView: UITableView!
    
    private var locations:[Location] = []
    private var selectedLocation: Location?
    
    private let locationTypes = LocationType.list
    private let locationTypeColors: [UIColor] = [.systemBlue, .orange, .systemGreen]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let regionLocations = region.locations?.allObjects as? [Location] {
            locations = regionLocations
            locations.sort(by: { $0.name! < $1.name! })
            
            DispatchQueue.main.async {
                self.contentTableView.reloadData()
            }
        }
        
        if region.name != "" {
            self.title = region.name
        }
    }
    
    // MARK: Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell") as! LocationTableViewCell
        
        cell.update(forLocation: locations[indexPath.row], types: locationTypes, colors: locationTypeColors)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedLocation = locations[indexPath.row]
        performSegue(withIdentifier: "LocationDetailsSegue", sender: self)
    }
    
    //MARK: segue for next controller

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LocationDetailsSegue" {
            let controller = segue.destination as! LocationDetailsViewController
            controller.location = selectedLocation
        }
    }
}
