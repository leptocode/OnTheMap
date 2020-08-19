//
//  UserProfile.swift
//  OnTheMap
//
//  Created by Fabio Italiano on 8/13/20.
//  Copyright © 2020 Fabio Italiano. All rights reserved.
//

import Foundation

struct UserProfile: Codable {
    let firstName: String
    let lastName: String
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case nickname
    }
 
}
