//
//  PhoneAuthManager.swift
//  Prego
//
//  Created by owner on 10/3/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit
//import FirebaseAuth


public class PhoneAuthManager {
    
    class func PhoneProvider(phoneNumber: String, completion: @escaping (_ error: String?, _ success: Bool)->Void) {
        
        //For testing mobile
        //Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        
        /*PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print("erorr vervication \(error.localizedDescription)")
                completion(error.localizedDescription, false)
                return
            }
            UserDefaults.standard.set(verificationID, forKey: Config.authVerificationID)
            completion(nil, true)
        }*/
    }
    
}
