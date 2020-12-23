//
//  Branches.swift
//  Prego
//
//  Created by owner on 9/23/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation

struct BranchModel: Codable {
    let response: Bool?
    let data: BranchData?
    let lang: String?
}

// MARK: - DataClass
struct BranchData: Codable {
    let branches: [Branch]?
}

// MARK: - Branch
struct Branch: Codable {
    let id: Int?
    let area: Area?
    let nameEn, nameAr, addressEn, addressAr: String?
    let lat, lng: String?
    let status: String?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, area
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case addressEn = "address_en"
        case addressAr = "address_ar"
        case lat, lng, status
        case createdAt = "created_at"
    }
}

// MARK: - Area
struct Area: Codable {
    let id, country, state, city: Int?
    let areaNameEn, areaNameAr, lat, llng: String?
    let status: Int?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, country, state, city
        case areaNameEn = "area_name_en"
        case areaNameAr = "area_name_ar"
        case lat, llng, status
        case createdAt = "created_at"
    }
}
