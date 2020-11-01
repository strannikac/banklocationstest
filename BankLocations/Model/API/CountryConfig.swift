//
//  CountryConfig.swift
//  BankLocations
//
//  Created by Alexander Sokhin on 11.10.2020.
//

import Foundation

//MARK: Country structure

struct CountryConfig {
    
    let name: String
    let endpoint: String
    
    // An array of countries
    static let list: [CountryConfig] = {
        return [
            CountryConfig(name: "Estonia", endpoint: "https://www.swedbank.ee/finder.json"),
            CountryConfig(name: "Latvia", endpoint: "https://www.swedbank.lv/finder.json"),
            CountryConfig(name: "Lithuania", endpoint: "https://www.swedbank.lt/finder.json")
        ]
    }()
}
