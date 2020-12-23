//
//  HomeSlider.swift
//  Prego
//
//  Created by owner on 10/1/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation

struct HomeSlider: Codable {
    let response: Bool?
    let data: HomeSliderData?
    let lang: String?
}

// MARK: - DataClass
struct HomeSliderData: Codable {
    let slider: [Slider]?
}

// MARK: - Slider
struct Slider: Codable {
    let id, itemID: Int?
    let offerID: Int?
    let link: String?
    let type: String?
    let status: Int?
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case itemID = "item_id"
        case offerID = "offer_id"
        case link, type, status
        case image
    }
}
