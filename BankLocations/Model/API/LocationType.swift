//
//  LocationType.swift
//  BankLocations
//
//  Created by Alexander Sokhin on 11.10.2020.
//

import Foundation

//MARK: location type

struct LocationType {
    
    let iso: String
    let title: String
    
    // An array of location types
    static let list: [LocationType] = {
        return [
            LocationType(iso: "BR", title: "Branch"),
            LocationType(iso: "A", title: "ATM (Automated Teller Machine)"),
            LocationType(iso: "R", title: "BNA (Bunch Note Acceptor)")
        ]
    }()
}
