//
//  AppFontManager.swift
//  Prego
//
//  Created by owner on 8/21/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

enum AppFontWeight: String {
    case bold = "Bold"
    case medium = "Medium"
    case regular = "Regular"
}

enum AppFontType: String {
    case roboto = "Roboto"
    case droidKufi = "DroidArabicKufi" //"ArbFONTS-DroidKufi"
}

class AppFontManager: NSObject {
    static func font(size: CGFloat, weight: AppFontWeight) -> UIFont {
        let name = "Roboto" + "-" + weight.rawValue
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func fontType(type: AppFontType ,size: CGFloat, weight: AppFontWeight) -> UIFont {
        let name = type.rawValue + "-" + weight.rawValue
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func fontType(type: AppFontType ,size: CGFloat) -> UIFont {
        let name = type.rawValue
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
