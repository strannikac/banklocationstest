//
//  LocationItem.swift
//  BankLocations
//
//  Created by Alexander Sokhin on 11.10.2020.
//

import Foundation

struct LocationItem: Codable {
    let lat: Double
    let lon: Double
    let t: Int
    let n: String
    let a: String
    let r: String
    let av: String?
    let i: String?
    let ncash: Bool?
    let cs: Bool?
    
    static func transform(from array: [AnyObject]) -> [LocationItem] {
        var locations: [LocationItem] = []
        
        let count = array.count
        
        for i in 0..<count {
            var latitude = 0.0
            var longitude = 0.0
            var type = 0
            var name = ""
            var address = ""
            var region = ""
            var availability = ""
            var info = ""
            var nocash = false
            var coinStation = false
            
            if let val = array[i]["n"] as? String {
                name = val
            }
            
            if let val = array[i]["a"] as? String {
                address = val
            }
            
            if let val = array[i]["r"] as? String {
                region = val
            }
            
            if name != "" && address != "" && region != "" {
                if let val = array[i]["lat"] as? Double {
                    latitude = val
                }
                
                if let val = array[i]["lon"] as? Double {
                    longitude = val
                }
                
                if let val = array[i]["t"] as? Int {
                    type = val
                }
                
                if let val = array[i]["av"] as? String {
                    availability = val
                }
                
                if let val = array[i]["i"] as? String {
                    info = val
                }
                
                if let val = array[i]["ncash"] as? Int, val == 1 {
                    nocash = true
                }
                
                if let val = array[i]["cs"] as? Int, val == 1 {
                    coinStation = true
                }
                
                let item = LocationItem(
                    lat: latitude,
                    lon: longitude,
                    t: type,
                    n: name,
                    a: address,
                    r: region,
                    av: availability,
                    i: info,
                    ncash: nocash,
                    cs: coinStation
                )
                
                locations.append(item)
            }
            
        }
        
        return locations
    }
}
