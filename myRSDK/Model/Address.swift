//
//  Address.swift
//  Prego
//
//  Created by owner on 10/1/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation


// MARK: - Welcome
struct AddressModel: Codable {
    let response: Bool?
    let data: AddressData?
    let lang: String?
}

// MARK: - DataClass
struct AddressData: Codable {
    let address: [Address]?
}

// MARK: - Address
struct Address: Codable {
    let id, userID: Int?
    let addressName, lat, lng: String?
    let country, state: Int?
    //let city: AddressCity?
    let area: AddressArea?
    let zone: Int?
    let street, building: String?
    let floor, apartment: Int?
    let address1, address2: String?
    let additional: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case addressName = "address_name"
        case lat, lng, country, state, area, zone, street, building, floor, apartment, address1, address2, additional
    }
}

// MARK: - Area
struct AddressArea: Codable {
    let id, country, state, city: Int?
    let areaNameEn, areaNameAr: String?
    let lat, lng: String?
    let status: Int?
    let delivery_fees: String?
    let last_delivery: String?
    let createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, country, state, city
        case areaNameEn = "area_name_en"
        case areaNameAr = "area_name_ar"
        case lat, lng, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case last_delivery = "last_delivery"
        case delivery_fees = "delivery_fees"
    }
}

// MARK: - City
struct AddressCity: Codable {
    let id, country, state: Int?
    let nameEn, nameAr: String?
    let status: Int?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, country, state
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case status
        case createdAt = "created_at"
    }
}
