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
    
    static func transform(from array: [AnyObject]) -> [LocationItem] {
        var locations: [LocationItem] = []
        
        let count = array.count
        
        for i in 0..<count {
            if let latitude = array[i]["lat"] as? Double,
               let longitude = array[i]["lon"] as? Double,
               let type = array[i]["t"] as? Int16,
               let name = array[i]["n"] as? String,
               let address = array[i]["a"] as? String,
               let regionName = array[i]["r"] as? String
            {
                let item = LocationItem(
                    latitude: latitude,
                    longitude: longitude,
                    type: type,
                    name: name,
                    address: address,
                    regionName: regionName,
                    availability: array[i]["av"] as? String,
                    info: array[i]["i"] as? String,
                    nocash: array[i]["ncash"] as? Int == 1 ? true : false,
                    coinStation: array[i]["cs"] as? Int == 1 ? true : false
                )
                
                locations.append(item)
            }
        }
        
        return locations
    }
}
