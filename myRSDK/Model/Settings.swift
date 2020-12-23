//
//  Settings.swift
//  MyRes
//
//  Created by Other Logic on 5/11/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import Foundation

struct AppSettingsModel: Codable {
    let response: Bool?
    let data: AppSettings?
    let lang: String?
}

// MARK: - DataClass
struct AppSettings: Codable {
    let settings: AppSetting?
}

// MARK: - Settings
struct AppSetting: Codable {
    let minAmountOrder, tax: String?
    let cardPayment: String?
    let pickUp: String?

    enum CodingKeys: String, CodingKey {
        case minAmountOrder = "min_amount_order"
        case tax
        case cardPayment = "card_payment"
        case pickUp = "pick_up"
    }
}
