//
//  User.swift
//  Prego
//
//  Created by owner on 9/4/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation


struct User: Codable {
    let response: Bool?
    let data: UserClass?
    let lang: String?
    
}

// MARK: - DataClass
struct UserClass: Codable {
    let userData: UserData?
    let token: String?
    let user: UserModel?
}

// MARK: - UserData
struct UserData: Codable {
    let adminID, lookupID: Int?
    let name, avatar, userToken, deviceActiveToken: String?
    let createdBy: Int?
    let suspend: Int?
    let emailConfirmed, mobileConfirmed: Int?
    let createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case adminID = "admin_id"
        case lookupID = "lookup_id"
        case name, avatar
        case userToken = "user_token"
        case deviceActiveToken = "device_active_token"
        case createdBy = "created_by"
        case suspend
        case emailConfirmed = "email_confirmed"
        case mobileConfirmed = "mobile_confirmed"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


struct UserModel: Codable {
    let id: Int?
    let userName, email, phone: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userName = "user_name"
        case email, phone
    }
}
