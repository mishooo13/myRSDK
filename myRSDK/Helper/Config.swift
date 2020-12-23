//
//  Config.swift
//  Prego
//
//  Created by owner on 8/21/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation

let PREGO_WEBISTE = "http://itunes.apple.com/app/id1518046060"
let APPSTORE_URL = "https://itunes.apple.com/us/app/myapp/id1518046060?ls=1&mt=8"

let CURRENCY = "EGP"
let COMMAND = "PURCHASE"


var frameworkBundle:Bundle? {
    let bundleId = "com.otherlogic.myRSDK"
    return Bundle(identifier: bundleId)
}

public class Config {
    
    static let placeHolder: String = "holder.png"
    
    
    //User defaults
    static let tokenDefault             = "token"
    static let skipDefault              = "skip"
    static let guideDefault             = "guide"
    static let userDefault              = "user"
    static let cartDefault              = "cart"
    static let languageDefault          = "language"
    static let titleBranchDefault       = "titleBranch"
    static let addressBranchDefault     = "addressBranch"
    static let areaDefault              = "areaDefault"
    static let deviceDefault            = "deviceDefault"
    static let menuDefault              = "menuDefault"
    static let phoneDefault             = "phoneDefault"
    static let reasturantDefault        = "reasturantDefault"
    static let multiChainDefault        = "multiChainDefault"
    
    static let authVerificationID       = "authVerificationID"
    
    static let English                  = "en"
    static let Arablic                  = "ar"
    
    static let OFFER                    = "1"
    static let ITEM                     = "1"
    
    static let EMPTY_TAG : Int          = 101
    
    static let branchOpen               = "open"
    static let branchClose              = "closed"
    
}
