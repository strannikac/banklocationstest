//
//  LocationTableViewCell.swift
//  BankLocations
//
//  Created by Alexander Sokhin on 16.10.2020.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet private weak var isoLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    
    func update(forLocation location: Location, types: [LocationType], colors: [UIColor]) {
        let type = Int(location.type)
        
        nameLabel.text = location.name
        addressLabel.text = location.address
        
        isoLabel.text = types[type].iso
        isoLabel.backgroundColor = colors[type]
        isoLabel.layer.masksToBounds = true
        isoLabel.layer.cornerRadius = isoLabel.bounds.width / 2
    }
}
