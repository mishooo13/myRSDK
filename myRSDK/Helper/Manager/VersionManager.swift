//
//  VersionManager.swift
//  MyRes
//
//  Created by Other Logic on 5/21/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//
import UIKit
import Alamofire

public class VersionManager {
    
    
    public static let shared = VersionManager()
    
    var newVersionAvailable: Bool?
    var appStoreVersion: String?

    func checkAppStore(callback: ((_ versionAvailable: Bool, _ ourVersion: String?, _ version: String?)->Void)? = nil) {
        let ourBundleId = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
        Alamofire.request("https://itunes.apple.com/lookup?bundleId=\(ourBundleId)").responseJSON { response in
            var isNew: Bool = false
            var versionStr: String?
            var versionApp: String?

            if let json = response.result.value as? NSDictionary,
               let results = json["results"] as? NSArray,
               let entry = results.firstObject as? NSDictionary,
               let appVersion = entry["version"] as? String,
               let ourVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            {
                //print("response version \(ourVersion)   \(appVersion)")
                versionStr = appVersion
                versionApp = ourVersion
                
                if let appVersionAsDouble = Double(appVersion), let ourVersionAsDouble = Double(ourVersion) {
                    
                    if ourVersionAsDouble < appVersionAsDouble {
                        isNew = true
                    }else{
                        isNew = false
                    }
                }
                
                /*if ourVersion != appVersion {
                    isNew = true
                }else{
                    isNew = false
                }*/
            }

            self.appStoreVersion = versionStr
            self.newVersionAvailable = isNew
            callback?(isNew, versionApp, versionStr)
        }
    }
    
}
