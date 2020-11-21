//
//  LocationItem.swift
//  BankLocations
//
//  Created by Alexander Sokhin on 11.10.2020.
//

import Foundation

struct LocationItem: Codable {
    let latitude: Double
    let longitude: Double
    let type: Int16
    let name: String
    let address: String
    let regionName: String
    let availability: String?
    let info: String?
    let nocash: Bool?
    let coinStation: Bool?
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case type = "t"
        case name = "n"
        case address = "a"
        case regionName = "r"
        case availability = "av"
        case info = "i"
        case nocash = "ncash"
        case coinStation = "cs"
    }
}
