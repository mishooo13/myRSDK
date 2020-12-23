//
//  RegularExpression.swift
//  Prego
//
//  Created by owner on 9/4/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation


public class RegularExpression {
    
    static func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,30}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    static func isValidPhone(phone:String) -> Bool {
        let phoneRegEx = "^[0-9]{11}$"
        
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: phone.trimmingCharacters(in: .whitespaces))
    }
    
    static func isValidPassword(password:String) -> Bool {
        if password.count < 6 {
            return false
        }else{
            return true
        }
    }
    
    static func isValidName(name: String) -> Bool {
        if name.isEmpty {
            return false
        }else{
            return true
        }
    }
    
    static func isValidEmpty(text: String) -> Bool {
        if text.isEmpty {
            return false
        }else{
            return true
        }
    }
}
