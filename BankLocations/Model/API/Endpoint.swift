//
//  Endpoint.swift
//  BankLocations
//
//  Created by Alexander Sokhin on 11.10.2020.
//

import Foundation

//MARK: Endpoint for country structure

struct Endpoint {
    
    let name: String
    let url: String
    
    // An array of countries
    static let list: [Endpoint] = {
        return [
            Endpoint(name: "Estonia", url: "https://www.swedbank.ee/finder.json"),
            Endpoint(name: "Latvia", url: "https://www.swedbank.lv/finder.json"),
            Endpoint(name: "Lithuania", url: "https://www.swedbank.lt/finder.json")
        ]
    }()
}
