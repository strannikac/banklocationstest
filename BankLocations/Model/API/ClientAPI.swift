//
//  ClientAPI.swift
//  BankLocations
//
//  Created by Alexander Sokhin on 10.10.2020.
//

import Foundation

//MARK: api for requests

class ClientAPI {
    
    //cookie for request
    private let cookieForRequest = "Swedbank-Embedded=iphone-app"
    
    //MARK: regions and locations from url
    
    //get data from api (url) for country
    func getLocationsByCountry(country: Endpoint, completion: @escaping (_ country: Endpoint, [LocationItem], String?) -> Void) {
        guard let url = URL(string: country.url) else {
            completion(country, [], StringConstants.errUrl.rawValue)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(cookieForRequest, forHTTPHeaderField: "Cookie")
        request.httpShouldHandleCookies = true
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(country, [], error?.localizedDescription)
                return
            }
            
            let decoder = JSONDecoder()
        
            do {
                //try to parse data in array of struct
                let responseObj = try? decoder.decode([LocationItem].self, from: data)
                
                if let responseObj = responseObj {
                    completion(country, responseObj, nil)
                } else {
                    //try to parse data in dictionary
                    let dictionaryObj = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject]
                    
                    if let dictionaryObj = dictionaryObj {
                        var items: [LocationItem] = []
                        let count = dictionaryObj.count
                        
                        for i in 0..<count {
                            if let jsonData = try? JSONSerialization.data(withJSONObject: dictionaryObj[i], options: .prettyPrinted), let item = try? decoder.decode(LocationItem.self, from: jsonData) {
                                items.append(item)
                            }
                        }
                        
                        completion(country, items, nil)
                    } else {
                        completion(country, [], StringConstants.errResponseData.rawValue)
                    }
                }
            } catch {
                completion(country, [], error.localizedDescription)
            }
        }
        
        task.resume()
    }
}
