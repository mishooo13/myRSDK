//
//  Item.swift
//  Prego
//
//  Created by owner on 9/16/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct ItemModel: Codable {
    let id: Int?
    let nameEn, nameAr, desriptionEn, desriptionAr: String?
    let code, extras: String?
    let menuID, sectionID: Int?
    let image: String?
    let status: Int?
    let offer: String?
    let createdAt: String?
    let itemExtras: [ItemExtra]?
    let favorite: Bool?
    let info: [ItemInfo]?
    let related: [Related]?
    
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
        case offer
        case createdAt = "created_at"
        case itemExtras = "item_extras"
        case info, related
        case favorite
    }
}

// MARK: - Related
struct Related: Codable {
    let id, item, related: Int?
    let choices: [ChoicesInfo]?
    let max, min: Int?
    let createdAt: String?
    let itemExtras: [ItemExtra]?
    let itemInfo: ItemInfo?
    
    enum CodingKeys: String, CodingKey {
        case id, item, related, choices, max, min
        case createdAt = "created_at"
        case itemExtras = "item_extras"
        case itemInfo = "item_info"
    }
}

// MARK: - RelatedItem
struct RelatedItem: Codable {
    let id, item, related: Int?
    let choices: String?
    let max, min: Int?
    let createdAt: String?
    let itemExtras: [ItemExtra]?
    let itemInfo: ItemInfo?
    
    enum CodingKeys: String, CodingKey {
        case id, item, related, choices, max, min
        case createdAt = "created_at"
        case itemExtras = "item_extras"
        case itemInfo = "item_info"
        
    }
}

// MARK: - Info
struct ItemInfo: Codable {
    let id: Int?
    let sizeEn, sizeAr: String?
    let itemCode, extras: String?
    let image: String?
    let priceEn, priceAr, oldPriceEn, oldPriceAr: String?
    let offerPriceEn, offerPriceAr, createdAt: String?
    let itemExtras: [ItemExtra]?
    let relatedItem: [RelatedItem]?
    let price: InfoPrice?
    
    enum CodingKeys: String, CodingKey {
        case id
        case itemCode = "item_code"
        case extras, image
        case priceEn = "price_en"
        case priceAr = "price_ar"
        case oldPriceEn = "old_price_en"
        case oldPriceAr = "old_price_ar"
        case offerPriceEn = "offer_price_en"
        case offerPriceAr = "offer_price_ar"
        case createdAt = "created_at"
        case itemExtras = "item_extras"
        case relatedItem = "related_item"
        case sizeEn = "size_en"
        case sizeAr = "size_ar"
        case price
    }
}

// MARK: - Info
struct ChoicesInfo: Codable {
    let id: Int?
    let itemCode, sizeEn, sizeAr: String?
    let extras: String?
    let image, priceEn, priceAr, oldPriceEn: String?
    let oldPriceAr, offerPriceEn, offerPriceAr: String?
    let status: Int?
    let itemExtras: [ItemExtra]?
    let itemName: ChoiceItemName?
    
    enum CodingKeys: String, CodingKey {
        case id
        case itemCode = "item_code"
        case sizeEn = "size_en"
        case sizeAr = "size_ar"
        case extras, image
        case priceEn = "price_en"
        case priceAr = "price_ar"
        case oldPriceEn = "old_price_en"
        case oldPriceAr = "old_price_ar"
        case offerPriceEn = "offer_price_en"
        case offerPriceAr = "offer_price_ar"
        case status
        case itemExtras = "item_extras"
        case itemName = "item_name"
    }
}

struct ChoiceItemName: Codable {
    let id: Int?
    let nameEn, nameAr, descriptionEn, descriptionAr: String?
    let extras: String?
    let menuID, sectionID: Int?
    let image: String?
    let status, offer, offerType: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case extras
        case menuID = "menu_id"
        case sectionID = "section_id"
        case image, status, offer
        case offerType = "offer_type"
    }
}

// MARK: - ItemExtra
struct ItemExtra: Codable {
    let id: Int?
    let categoryEn, categoryAr, nameEn, nameAr: String?
    let descriptionEn, descriptionAr: String?
    let priceEn, priceAr: String?
    let image: String?
    let createdAt: String?
    let data: [ItemExtra]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case categoryEn = "category_en"
        case categoryAr = "category_ar"
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case priceEn = "price_en"
        case priceAr = "price_ar"
        case image
        case createdAt = "created_at"
        case data
    }
}
