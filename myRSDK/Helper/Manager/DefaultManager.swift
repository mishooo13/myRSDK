//
//  DefaultManager.swift
//  Prego
//
//  Created by owner on 9/4/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation

class DefaultManager {
    
    //User object defualts
    static func saveUserDefault(user: User) {
        
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: Config.userDefault)
            UserDefaults.standard.synchronize()
        }
    }
    
    static func getUserDefault() -> User? {
        
        var user: User?
        if let userData = UserDefaults.standard.data(forKey: Config.userDefault),
            let userDefault = try? JSONDecoder().decode(User.self, from: userData) {
            
            user = userDefault
        }
        return user
    }
    
    
    //Language defaults
    static func saveLanguageDefault(language: String) {
        let userdef = UserDefaults.standard
        userdef.set(language , forKey: Config.languageDefault)
        userdef.synchronize()
    }
    

    static func saveTitleBranchDefault(value: String) {
        let userdef = UserDefaults.standard
        userdef.set(value , forKey: Config.titleBranchDefault)
        userdef.synchronize()
    }
    
    static func saveAddressBranchDefault(value: String) {
        let userdef = UserDefaults.standard
        userdef.set(value , forKey: Config.addressBranchDefault)
        userdef.synchronize()
    }
    
    static func getLanguage() -> String? {
        var language: String? = nil
        if let lang = UserDefaults.standard.string(forKey: Config.languageDefault) {
            language = lang
        }
        return language
    }
    
    static func getLanguageDefault() -> String {
        var lang: String = Config.English
        if let language = getLanguage(){
            if language.isEmpty{
                lang = Config.English
            }else{
                lang = language
            }
        }else{
            let deviceLang = Locale.current.languageCode
            if (deviceLang?.isEmpty)! || deviceLang == nil {
                lang = Config.English
            }else{
                lang = deviceLang!
            }
        }
        return lang
    }
    
    
    
    
    //token defaults
    static func saveTokenDefault(token: String) {
        UserDefaults.standard.set(token , forKey: Config.tokenDefault)
    }
    
    public static func getUserToken() -> String? {
        
        var token: String? = nil
        if let tok = UserDefaults.standard.string(forKey: Config.tokenDefault) {
            token = tok
        }
        return token
    }
    
    //Phone default
    static func savePhoneDefault(token: String) {
        UserDefaults.standard.set(token , forKey: Config.phoneDefault)
    }
    
    public static func getUserPhone() -> String? {
        
        var token: String? = nil
        if let tok = UserDefaults.standard.string(forKey: Config.phoneDefault) {
            token = tok
        }
        return token
    }
    
    //Skipped defaults
    static func saveSkipDefault(value: String) {
        UserDefaults.standard.set(value , forKey: Config.skipDefault)
    }
    
    public static func getSkipped() -> String? {
        
        var token: String? = nil
        if let tok = UserDefaults.standard.string(forKey: Config.skipDefault) {
            token = tok
        }
        return token
    }
    
    static func saveGuideDefault(value: String) {
        UserDefaults.standard.set(value , forKey: Config.guideDefault)
    }
    
    public static func getGuideSkipped() -> String? {
        
        var token: String? = nil
        if let tok = UserDefaults.standard.string(forKey: Config.guideDefault) {
            token = tok
        }
        return token
    }
    
    
    static func saveAreaDefault(value: AreaClass) {
        
        if let encoded = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(encoded, forKey: Config.areaDefault)
            UserDefaults.standard.synchronize()
        }
    }
    
    
    static func getAreaDefault() -> AreaClass? {
        
        var user: AreaClass?
        if let userData = UserDefaults.standard.data(forKey: Config.areaDefault),
            let userDefault = try? JSONDecoder().decode(AreaClass.self, from: userData) {
            
            user = userDefault
        }
        return user
    }
    
    static func removeAreaDeafult() {
        UserDefaults.standard.removeObject(forKey: Config.areaDefault)
    }
    
    static func saveReasrturantDefault(value: Chain) {
        
        if let encoded = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(encoded, forKey: Config.reasturantDefault)
            UserDefaults.standard.synchronize()
        }
    }
    
    
    static func getReasrturantDefault() -> Chain? {
        
        var user: Chain?
        if let userData = UserDefaults.standard.data(forKey: Config.reasturantDefault),
            let userDefault = try? JSONDecoder().decode(Chain.self, from: userData) {
            
            user = userDefault
        }
        return user
    }
    
    static func getAreaPriceListDefault() -> Int? {
        
        /*guard let area = getAreaDefault() else {
            return nil
        }
        guard let branches = area.branches else {
            return nil
        }
        if branches.isEmpty {
            return nil
        }
        guard let priceList = branches[0].priceList else {
            return nil
        }
        return priceList*/
        
        guard let chain = getReasrturantDefault() else{
            return nil
        }
        guard let priceList = chain.priceList else {
            return nil
        }
        return priceList
    }
    
    static func saveDeviceType(value: Bool) {
        UserDefaults.standard.set(value , forKey: Config.deviceDefault)
    }
    
    public static func getDeviceType() -> Bool {
        return UserDefaults.standard.bool(forKey: Config.deviceDefault)
    }
    
    //token defaults
    static func saveMenuIdDefault(token: String) {
        UserDefaults.standard.set(token , forKey: Config.menuDefault)
    }
    
    public static func getMenuID() -> String? {
        
        var token: String? = nil
        if let tok = UserDefaults.standard.string(forKey: Config.menuDefault) {
            token = tok
        }
        return token
    }
    
    static func saveIsMultiChain(value: Bool) {
           UserDefaults.standard.set(value , forKey: Config.multiChainDefault)
       }
       
       public static func getIsMultiChain() -> Bool {
           return UserDefaults.standard.bool(forKey: Config.multiChainDefault)
       }
}


