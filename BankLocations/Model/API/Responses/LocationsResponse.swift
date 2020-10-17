//
//  LocationsResponse.swift
//  BankLocations
//
//  Created by Alexander Sokhin on 11.10.2020.
//

import Foundation

struct LocationsResponse: Codable {
    
    let page: Int
    let results: [MovieItem]
    let totalPages: Int
    let totalResults: Int
}
