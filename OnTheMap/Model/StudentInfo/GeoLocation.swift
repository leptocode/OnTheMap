//
//  Location.swift
//  OnTheMap
//
//  Created by Fabio Italiano on 8/14/20.
//  Copyright © 2020 Fabio Italiano. All rights reserved.
//

import Foundation

struct GeoLocation: Codable {
    
    let objectId: String
    let uniqueKey: String?

    let firstName: String?
    let lastName: String?

    let latitude: Double?
    let longitude: Double?

    let mapString: String?
    let mediaURL: String?

    let createdOn: String
    let updatedOn: String
    
    var locationLabel: String {
        var name = ""
        
        if let firstName = firstName {
            name = firstName
        }
    
        if let lastName = lastName {
            if name.isEmpty {
                name = lastName
            } else {
                name += " \(lastName)"
            }
        }
        
        if name.isEmpty {
            name = "FirstName LastName"
        }
        
        return name
    }
}
