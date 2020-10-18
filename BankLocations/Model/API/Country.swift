//
//  Countries.swift
//  BankLocations
//
//  Created by Alexander Sokhin on 11.10.2020.
//

import Foundation

//MARK: Country structure

struct Country {
    
    let id: Int
    let name: String
    let endpoint: String
    
    // An array of countries
    static let list: [Country] = {
        return [
            Country(id: 1, name: "Estonia", endpoint: "https://www.swedbank.ee/finder.json"),
            Country(id: 2, name: "Latvia", endpoint: "https://www.swedbank.lv/finder.json"),
            Country(id: 3, name: "Lithuania", endpoint: "https://www.swedbank.lt/finder.json")
        ]
    }()
}
