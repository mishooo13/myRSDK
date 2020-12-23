//
//  Coupon.swift
//  Prego
//
//  Created by owner on 10/7/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation

struct CouponModel: Codable {
    let response: Bool?
    let coupon: Coupon?
}

// MARK: - Coupon
struct Coupon: Codable {
    let code: String?
    let fixed, percentage, minAmount: Int?
    let discountForAmountMoreThan, maxDiscountAmount: Int?
    let couponDescription: String?
    let couponDescriptionAr: String?
    let freeDelivery: String?
    let freeOnPayCard: String?
    let includeItems: String?
    
    enum CodingKeys: String, CodingKey {
        case code, fixed, percentage, minAmount
        case discountForAmountMoreThan = "discount_for_amount_more_than"
        case maxDiscountAmount = "max_discount_amount"
        case couponDescription = "description_en"
        case couponDescriptionAr = "description_ar"
        case includeItems = "include_items"
        case freeOnPayCard = "free_on_pay_card"
        case freeDelivery = "free_delivery"
    }
}

