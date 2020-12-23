//
//  DetectLocationModel.swift
//  MyRes
//
//  Created by Other Logic on 5/13/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

struct DetectLocationModel: Codable {
    let response: Bool?
    let data: DetectLocation?
    let lang: String?
}

// MARK: - DataClass
struct DetectLocation: Codable {
    let settings: [Setting]?
}

// MARK: - Setting
struct Setting: Codable {
    let optionID: Int?
    let optionName, value, createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case optionID = "option_id"
        case optionName = "option_name"
        case value
        case createdAt = "created_at"
    }
}
