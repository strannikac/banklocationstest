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
        self.setDesign()
        
        //show info of location
        self.showInfo()
    }
    
    private func setDesign() {
        //uppercase text in title labels
        self.typeTitleLabel.text = self.typeTitleLabel.text?.uppercased()
        self.nameTitleLabel.text = self.nameTitleLabel.text?.uppercased()
        self.addressTitleLabel.text = self.addressTitleLabel.text?.uppercased()
        self.regionTitleLabel.text = self.regionTitleLabel.text?.uppercased()
        self.availabilityTitleLabel.text = self.availabilityTitleLabel.text?.uppercased()
        self.infoTitleLabel.text = self.infoTitleLabel.text?.uppercased()
    }
    
    private func showInfo() {
        self.locationTypes = LocationType.list
        let type = Int(self.location.type)
        
        let name = self.location.name?.replacingOccurrences(of: "\n", with: "") ?? ""
        
        if name != "" {
            self.title = name
        }
        
        self.typeLabel.text = self.locationTypes[type].title
        self.nameLabel.text = name
        self.addressLabel.text = self.location.address?.replacingOccurrences(of: "\n", with: "") ?? ""
        
        self.regionLabel.text = ""
        if let region = location.region?.name {
            self.regionLabel.text = region
        }
        
        let availability = self.location.availability?.replacingOccurrences(of: "\n", with: "") ?? ""
        
        if availability == "" {
            self.availabilityLabel.isHidden = true
            self.availabilityTitleLabel.isHidden = true
        } else {
            self.availabilityLabel.text = availability
        }
        
        //only for branch
        if type == 0 {
            var infoTotal = ""
            
            let info = self.location.info?.replacingOccurrences(of: "\n", with: "") ?? ""
            
            if info != "" {
                infoTotal += info
            }
            
            if self.location.nocash {
                if infoTotal != "" {
                    infoTotal += "\n"
                }
                infoTotal += StringConstants.nocashBranch.rawValue
            }
            
            if self.location.coinStation {
                if infoTotal != "" {
                    infoTotal += "\n"
                }
                infoTotal += StringConstants.hasCoinStation.rawValue
            }
            
            if infoTotal == "" {
                self.infoLabel.isHidden = true
                self.infoTitleLabel.isHidden = true
            } else {
                self.infoLabel.text = infoTotal
            }
        } else {
            self.infoLabel.isHidden = true
            self.infoTitleLabel.isHidden = true
        }
    }
}
