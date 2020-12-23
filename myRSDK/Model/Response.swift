//
//  Response.swift
//  Prego
//
//  Created by owner on 9/4/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation

struct Response : Codable{
    
    let response: Bool
    
    enum CodingKeys: String, CodingKey {
        case response = "response"
    }
}


struct ResponseMessage : Codable{
    
    let response: Bool
    let messages: String?
    
    enum CodingKeys: String, CodingKey {
        case response = "response"
        case messages
    }
}


struct ResponseUpdateProfile: Codable {
    let response: Bool?
    let data: UpdateProfileToken?
    let lang: String?
}

// MARK: - DataClass
struct UpdateProfileToken: Codable {
    let apiToken: String?
    
    enum CodingKeys: String, CodingKey {
        case apiToken = "api_token"
    }
}
