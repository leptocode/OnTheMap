//
//  LoginAccount.swift
//  OnTheMap
//
//  Created by Fabio Italiano on 8/2/20.
//  Copyright © 2020 Fabio Italiano. All rights reserved.
//

import Foundation

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Login: Codable {
    let account: Account
    let session: Session
}

