//
//  LoginAPI.swift
//  myRSDK
//
//  Created by Other Logic on 9/3/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginAPI : NSObject {
    
    class func loginWithEmail(email: String, password: String, deviceToken: String, view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool)->Void) {
        
        let url = URLManager.loginURL
        
        let parameters = ["email": email,
                          "password": password,
                          "device_token": deviceToken]
        
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<600)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false)
                    print(error)
                case .success( _):
                    print("response login \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        let user = Parsing.parseLogin(jsonData: response)
                        DefaultManager.saveUserDefault(user: user)
                        guard let data = user.data else {
                            return
                        }
                        guard let token = data.token else {
                            return
                        }
                        DefaultManager.saveTokenDefault(token: token)
                        completion(nil, true)
                        print("Login Success")
                    }else{
                        completion(nil, false)
                        print("Login Failed")
                    }
                }
        }
    }
    
    class func register(firstName: String, lastName: String, email: String, mobile: String, password: String, deviceToken: String, view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool)->Void) {
        
        let url = URLManager.registerURL
        
        let parameters = ["email": email,
                          "password": password,
                          "last_name": lastName,
                          "phone": mobile,
                          "first_name": firstName,
                          "device_token": deviceToken]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<600)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false)
                    print(error)
                case .success( _):
                    print("response login \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        let user = Parsing.parseLogin(jsonData: response)
                        DefaultManager.saveUserDefault(user: user)
                        guard let data = user.data else {
                            return
                        }
                        guard let token = data.token else {
                            return
                        }
                        DefaultManager.saveTokenDefault(token: token)
                        completion(nil, true)
                        print("Register Success")
                    }else{
                        completion(nil, false)
                        print("Register Failed")
                    }
                }
        }
    }
    
    
    class func loginFacebook(firstName: String, lastName: String, email: String, mobile: String, facebookId: String, deviceToken: String, view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool)->Void) {
        
        let url = URLManager.facebookLoginURL
        
        let parameters = ["facebook_id": facebookId,
                          "first_name": firstName,
                          "last_name": lastName,
                          "phone": mobile,
                          "email": email,
                          "device_token": deviceToken]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<800)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false)
                    print(error)
                case .success( _):
                    print("facebook login \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        let user = Parsing.parseLogin(jsonData: response)
                        DefaultManager.saveUserDefault(user: user)
                        guard let data = user.data else {
                            return
                        }
                        guard let token = data.token else {
                            return
                        }
                        DefaultManager.saveTokenDefault(token: token)
                        completion(nil, true)
                        print("Register Success")
                    }else{
                        completion(nil, false)
                        print("Register Failed")
                    }
                }
        }
    }
    
    class func loginApple(firstName: String, lastName: String, email: String, mobile: String, appleId: String, deviceToken: String, view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool)->Void) {
        
        let url = URLManager.appleLoginURL
        
        let parameters = ["apple_id": appleId,
                          "first_name": firstName,
                          "last_name": lastName,
                          "phone": mobile,
                          "email": email,
                          "device_token": deviceToken]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<800)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false)
                    print(error)
                case .success( _):
                    print("facebook login \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        let user = Parsing.parseLogin(jsonData: response)
                        DefaultManager.saveUserDefault(user: user)
                        guard let data = user.data else {
                            return
                        }
                        guard let token = data.token else {
                            return
                        }
                        DefaultManager.saveTokenDefault(token: token)
                        completion(nil, true)
                        print("Register Success")
                    }else{
                        completion(nil, false)
                        print("Register Failed")
                    }
                }
        }
    }
    
    class func loginApple(appleId: String, deviceToken: String, view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool)->Void) {
        
        let url = URLManager.appleLoginURL
        
        let parameters = ["apple_id": appleId,
                          "device_token": deviceToken]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<800)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false)
                    print(error)
                case .success( _):
                    print("facebook login \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        let user = Parsing.parseLogin(jsonData: response)
                        DefaultManager.saveUserDefault(user: user)
                        guard let data = user.data else {
                            return
                        }
                        guard let token = data.token else {
                            return
                        }
                        DefaultManager.saveTokenDefault(token: token)
                        completion(nil, true)
                        print("Register Success")
                    }else{
                        completion(nil, false)
                        print("Register Failed")
                    }
                }
        }
    }
    
    
    class func areasAPI(view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool, _ model: AreaModel?)->Void) {
        
        let url = URLManager.areas
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<800)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false, nil)
                    print(error)
                case .success( _):
                    print("facebook login \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        if let model = Parsing.parseAreas(jsonData: response) {
                            completion(nil, true, model)
                        }else{
                            completion(nil, false, nil)
                        }
                    }else{
                        completion(nil, false, nil)
                        print("Register Failed")
                    }
                }
        }
    }
}


