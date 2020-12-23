//
//  Menu.swift
//  Prego
//
//  Created by owner on 9/12/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation


struct MenuModel: Codable {
    let response: Bool?
    var data: MenuData?
    let lang: String?
}

// MARK: - DataClass
struct MenuData: Codable {
    var menu: [Menu]?
}

// MARK: - Menu
struct Menu: Codable {
    let id: Int?
    let nameEn, nameAr, desriptionEn, desriptionAr: String?
    let image: String?
    let status: Int?
    let sections: [Menu]?
    let menuID, parent: Int?
    var items: [Item]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case desriptionEn = "description_en"
        case desriptionAr = "description_ar"
        case image, status
        case sections
        case menuID = "menu_id"
        case parent, items
    }
}

// MARK: - Item
struct Item: Codable {
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
