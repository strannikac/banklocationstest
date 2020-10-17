//
//  LocationType.swift
//  BankLocations
//
//  Created by Alexander Sokhin on 11.10.2020.
//

import Foundation
import UIKit

//MARK: location type

struct LocationType {
    
    let iso: String
    let title: String
    let bgColor: UIColor
    
    // An array of location types
    static let list: [LocationType] = {
        return [
            LocationType(iso: "BR", title: "Branch", bgColor: .systemBlue),
            LocationType(iso: "A", title: "ATM (Automated Teller Machine)", bgColor: .orange),
            LocationType(iso: "R", title: "BNA (Bunch Note Acceptor)", bgColor: .systemGreen)
        ]
    }()
}
