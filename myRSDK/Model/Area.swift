//
//  Area.swift
//  Prego
//
//  Created by owner on 10/16/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation

struct AreaModel: Codable {
    let response: Bool?
    let data: AreaData?
    let lang: String?
}

// MARK: - DataClass
struct AreaData: Codable {
    let areas: [AreaClass]?
}

// MARK: - Area
struct AreaClass: Codable {
    let id, country, state, city: Int?
    let areaNameEn, areaNameAr: String?
    let lat, lng: String?
    let status: Int?
    let branches: [AreaBranch]?
    
    enum CodingKeys: String, CodingKey {
        case id, country, state, city
        case areaNameEn = "area_name_en"
        case areaNameAr = "area_name_ar"
        case lat, lng, status
        case branches
    }
}

// MARK: - Branch
struct AreaBranch: Codable {
    let id, area: Int?
    let nameEn, nameAr, addressEn, addressAr: String?
    let branchOpen, branchClose: String?
    let preparationTime: Int?
    let lat, lng: String?
    let status: Int?
    let priceList: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, area
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case addressEn = "address_en"
        case addressAr = "address_ar"
        case branchOpen = "open"
        case branchClose = "close"
        case preparationTime = "preparation_time"
        case lat, lng, status
        case priceList = "price_list"
    }
}
