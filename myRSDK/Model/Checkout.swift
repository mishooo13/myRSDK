//
//  CheckoutModel.swift
//  Prego
//
//  Created by owner on 10/29/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation


struct Checkout: Codable {
    let response: Bool?
    let data: CheckoutData?
    
    enum CodingKeys: String, CodingKey {
        case response
        case data
    }
}

// MARK: - DataClass
struct CheckoutData: Codable {
    let orderID: Int?
    let SDKToken: String?
    
    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case SDKToken = "SDK_TOKEN"
    }
}
