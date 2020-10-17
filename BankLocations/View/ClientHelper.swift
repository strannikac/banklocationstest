//
//  ClientHelper.swift
//  BankLocations
//
//  Created by Alexander Sokhin on 15.10.2020.
//

import Foundation

//MARK: client helper - additional functions for client side

class ClientHelper {
    
    //get seconds for date
    class func getSeconds(forDate date: Date = Date()) -> Int64 {
        return Int64(date.timeIntervalSince1970)
    }
}
