//
//  History.swift
//  Prego
//
//  Created by owner on 10/22/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation


struct HistoryModel: Codable {
    let response: Bool?
    let data: HistoryData?
    let lang: String?
}

// MARK: - DataClass
struct HistoryData: Codable {
    let details: [History]?
}

// MARK: - Detail
struct History: Codable {
    let id, userID: Int?
    let orderID, orders: String?
    let address: Int?
    let subTotal, total: Double?
    let branchID, paymentMethod: Int?
    let deliveryType: String?
    let coupon: String?
    let status, createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case orderID = "order_id"
        case orders, address
        case subTotal = "sub_total"
        case total
        case branchID = "branch_id"
        case paymentMethod = "payment_method"
        case deliveryType = "delivery_type"
        case coupon, status
        case createdAt = "created_at"
    }
}




struct HistoryDetailsModel: Codable {
    let response: Bool?
    let data: DataClass?
    let lang: String?
}

// MARK: - DataClass
struct DataClass: Codable {
    let order: [Order]?
}

// MARK: - Order
struct Order: Codable {
    let id, userID: Int?
    let orderID, orders: String?
    let address: [HistoryAddress]?
    let subTotal, total: Double?
    let branchID, paymentMethod: Int?
    let deliveryType: String?
    let coupon: String?
    let status, createdAt: String?
    let updatedAt, deletedAt: String?
    let items: [HistoryItem]?
    let branch: [HistoryBranch]?
    let deliveryFees: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case orderID = "order_id"
        case orders, address
        case subTotal = "sub_total"
        case total
        case branchID = "branch_id"
        case paymentMethod = "payment_method"
        case deliveryType = "delivery_type"
        case coupon, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case items, branch
        case deliveryFees = "delivery_fees"
    }
}

// MARK: - Address
struct HistoryAddress: Codable {
    let id, userID: Int?
    let addressName, lat, lng: String?
    let country, state: Int?
    let city: Int?
    let zone: Int?
    let street, building: String?
    let floor, apartment: Int?
    let address1, address2, additional: String?
    let createdAt, updatedAt: String?
    let area: HistoryArea?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case addressName = "address_name"
        case lat, lng, country, state, city, area, zone, street, building, floor, apartment, address1, address2, additional
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct HistoryArea: Codable {
    let id, country, state, city: Int?
    let areaNameEn, areaNameAr: String?
    let lat, lng: String?
    let deliveryFees, lastDelivery: String?
    let status: Int?
    let createdAt, updatedAt: String?
    let deletedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, country, state, city
        case areaNameEn = "area_name_en"
        case areaNameAr = "area_name_ar"
        case lat, lng
        case deliveryFees = "delivery_fees"
        case lastDelivery = "last_delivery"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

// MARK: - Branch
struct HistoryBranch: Codable {
    let id, area: Int?
    let nameEn, nameAr, addressEn, addressAr: String?
    let branchOpen, close: String?
    let preparationTime: Int?
    let lat, lng: String?
    let status: String?
    let createdAt, updatedAt: String?
    let deletedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, area
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case addressEn = "address_en"
        case addressAr = "address_ar"
        case branchOpen = "open"
        case close
        case preparationTime = "preparation_time"
        case lat, lng, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

// MARK: - Item
struct HistoryItem: Codable {
    let id, item: Int?
    let choices: String?
    let extras, options: [HistoryExtra]?
    let special: String?
    let count: Int?
    let subTotal, totalPrice, createdAt: String?
    let updatedAt, deletedAt, updatedBy, deletedBy: String?
    let info: [HistoryInfo]?
    let name: HistoryItemName?
    let totalExtrasPrice, totalOptionsPrice: String?
    
    enum CodingKeys: String, CodingKey {
        case id, item, choices, extras, options, special, count
        case subTotal = "sub_total"
        case totalPrice = "total_price"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case updatedBy = "updated_by"
        case deletedBy = "deleted_by"
        case info, name
        case totalExtrasPrice = "total_extras_price"
        case totalOptionsPrice = "total_options_price"
    }
}

// MARK: - Extra
struct HistoryExtra: Codable {
    let id: Int?
    let categoryEn, categoryAr, nameEn, nameAr: String?
    let descriptionEn, descriptionAr, priceEn, priceAr: String?
    let image: String?
    let extraRequired, status: Int?
    let createdAt, updatedAt: String?
    let deletedAt: String?
    
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
        case extraRequired = "required"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

// MARK: - Info
struct HistoryInfo: Codable {
    let id: Int?
    let itemCode, sizeEn, sizeAr, extras: String?
    let image, priceEn, priceAr, oldPriceEn: String?
    let oldPriceAr, offerPriceEn, offerPriceAr: String?
    let status: String?
    let createdAt, updatedAt: String?
    let deletedAt: String?
    
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
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

// MARK: - Name
struct HistoryItemName: Codable {
    let name: String?
    let nameAr: String?
    let offer: Int?
    
    enum CodingKeys: String, CodingKey {
        case name = "name_en"
        case nameAr = "name_ar"
        case offer
    }
}
