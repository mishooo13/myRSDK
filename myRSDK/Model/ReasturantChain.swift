//
//  ReasturantChain.swift
//  MyRes
//
//  Created by Other Logic on 7/13/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import Foundation

struct ReasturantChainModel: Codable {
    let response: Bool?
    var data: ReasturantChain?
    let lang: String?
}


struct ReasturantChain: Codable {
    var restaurants: [Chain]?
}

struct Chain: Codable {
    let id: Int?
    let nameEn, nameAr: String?
    let images: String?
    let status: String?
    let branchStatus: String?
    let priceList: Int?
    let deliveryFees: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "res_name_en"
        case nameAr = "res_name_ar"
        case images = "image"
        case status
        case branchStatus = "branch_status"
        case priceList = "price_list"
        case deliveryFees = "delivery_fees"
    }
}
