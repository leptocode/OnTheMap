//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Fabio Italiano on 8/13/20.
//  Copyright © 2020 Fabio Italiano. All rights reserved.
//

import Foundation

struct StudentAttributes: Codable {
    
    let uniqueKey: String?
    let objectId: String?
    
    let firstName: String
    let lastName: String
    
    let latitude: Double?
    let longitude: Double?
    
    let mapString: String?
    let mediaURL: String?
    
    let createdOn: String?
    let updatedOn: String?
    
    init(_ dictionary: [String: AnyObject]) {
        
        self.uniqueKey = dictionary["uniqueKey"] as? String ?? ""
        self.objectId = dictionary["objectId"] as? String
        
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        
        self.latitude = dictionary["latitude"] as? Double ?? 0.0
        self.longitude = dictionary["longitude"] as? Double ?? 0.0
        
        self.mapString = dictionary["mapString"] as? String ?? ""
        self.mediaURL = dictionary["mediaURL"] as? String ?? ""
        
        self.createdOn = dictionary["createdOn"] as? String
        self.updatedOn = dictionary["updatedOn"] as? String
    }
    
    var labelName: String {
        var name = ""
        if !firstName.isEmpty {
            name = firstName
        }
        if !lastName.isEmpty {
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
