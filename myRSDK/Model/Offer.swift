//
//  Offer.swift
//  Prego
//
//  Created by owner on 10/9/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct OfferModel: Codable {
    let response: Bool?
    let data: OfferData?
    let lang: String?
}

// MARK: - DataClass
struct OfferData: Codable {
    let offers: [Offer]?
}

// MARK: - Offer
struct Offer: Codable {
    let id: Int?
    let nameEn, nameAr, descriptionEn, descriptionAr: String?
    let menuID, sectionID: Int?
    let image: String?
    let status, offer: Int?
    let createdAt, updatedAt: String?
    let info: [Info]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case menuID = "menu_id"
        case sectionID = "section_id"
        case image, status, offer
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case info
    }
}
