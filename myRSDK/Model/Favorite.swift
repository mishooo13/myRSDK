//
//  Favorite.swift
//  Prego
//
//  Created by owner on 9/12/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation


struct FavoriteModel: Codable {
    let response: Bool?
    let data: FavoriteClass?
    let lang: String?
}

// MARK: - DataClass
struct FavoriteClass: Codable {
    let favorites: [Favorite]?
}

// MARK: - Favorite
struct Favorite: Codable {
    let id, userID, itemID, status: Int?
    let itemName: ItemName?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case itemID = "item_id"
        case status
        case itemName = "item_name"
    }
}

// MARK: - ItemName
struct ItemName: Codable {
    let id: Int?
    let nameEn, nameAr, desriptionEn, desriptionAr: String?
    let code, extras: String?
    let menuID, sectionID: Int?
    let image: String?
    let status: Int?
    let info: [Info]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case desriptionEn = "description_en"
        case desriptionAr = "description_ar"
        case code, extras
        case menuID = "menu_id"
        case sectionID = "section_id"
        case image, status
        case info
    }
}

// MARK: - Info
struct Info: Codable {
    let id: Int?
    let itemCode, size, extras, priceEn: String?
    let priceAr, oldPriceEn, oldPriceAr, offerPriceEn: String?
    let offerPriceAr, createdAt: String?
    let price: InfoPrice?
    
    enum CodingKeys: String, CodingKey {
        case id
        case itemCode = "item_code"
        case size, extras
        case priceEn = "price_en"
        case priceAr = "price_ar"
        case oldPriceEn = "old_price_en"
        case oldPriceAr = "old_price_ar"
        case offerPriceEn = "offer_price_en"
        case offerPriceAr = "offer_price_ar"
        case createdAt = "created_at"
        case price
    }
}

struct InfoPrice: Codable {
    let id: Int?
    let priceList, itemId: Int?
    let price: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case priceList = "price_list"
        case price
        case itemId = "item_id"
    }
}
