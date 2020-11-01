//
//  LocationDetailsViewController.swift
//  BankLocations
//
//  Created by Alexander Sokhin on 16.10.2020.
//

import UIKit

class LocationDetailsViewController: UIViewController {
    
    var location: Location!
    
    private var locationTypes:[LocationType] = []
    
    //labels
    @IBOutlet weak var typeTitleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressTitleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var regionTitleLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var availabilityTitleLabel: UILabel!
    @IBOutlet weak var availabilityLabel: UILabel!
    @IBOutlet weak var infoTitleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add some things in design
        setDesign()
        
        //show info of location
        showInfo()
    }
    
    private func setDesign() {
        //uppercase text in title labels
        typeTitleLabel.text = typeTitleLabel.text?.uppercased()
        nameTitleLabel.text = nameTitleLabel.text?.uppercased()
        addressTitleLabel.text = addressTitleLabel.text?.uppercased()
        regionTitleLabel.text = regionTitleLabel.text?.uppercased()
        availabilityTitleLabel.text = availabilityTitleLabel.text?.uppercased()
        infoTitleLabel.text = infoTitleLabel.text?.uppercased()
    }
    
    private func showInfo() {
        locationTypes = LocationType.list
        let type = Int(location.type)
        
        let name = location.name?.replacingOccurrences(of: "\n", with: "") ?? ""
        
        if name != "" {
            self.title = name
        }
        
        typeLabel.text = locationTypes[type].title
        nameLabel.text = name
        addressLabel.text = location.address?.replacingOccurrences(of: "\n", with: "") ?? ""
        
        regionLabel.text = ""
        if let region = location.region?.name {
            regionLabel.text = region
        }
        
        let availability = location.availability?.replacingOccurrences(of: "\n", with: "") ?? ""
        
        if availability == "" {
            availabilityLabel.isHidden = true
            availabilityTitleLabel.isHidden = true
        } else {
            availabilityLabel.text = availability
        }
        
        //only for branch
        if type == 0 {
            var infoTotal = ""
            
            let info = location.info?.replacingOccurrences(of: "\n", with: "") ?? ""
            
            if info != "" {
                infoTotal += info
            }
            
            if location.nocash {
                if infoTotal != "" {
                    infoTotal += "\n"
                }
                infoTotal += StringConstants.nocashBranch.rawValue
            }
            
            if location.coinStation {
                if infoTotal != "" {
                    infoTotal += "\n"
                }
                infoTotal += StringConstants.hasCoinStation.rawValue
            }
            
            if infoTotal == "" {
                infoLabel.isHidden = true
                infoTitleLabel.isHidden = true
            } else {
                infoLabel.text = infoTotal
            }
        } else {
            infoLabel.isHidden = true
            infoTitleLabel.isHidden = true
        }
    }
}
