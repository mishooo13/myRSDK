//
//  ProfileAPI.swift
//  myRSDK
//
//  Created by Other Logic on 9/3/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileAPI : NSObject {
    
    class func slider(view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool,_ favorites: [Slider]?)->Void) {
        
        let url = URLManager.sliderURL
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<800)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false, nil)
                    print(error)
                case .success( _):
                    print("favorites list \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        if let model = Parsing.parseHome(jsonData: response) {
                            guard let data = model.data else {
                                completion(nil, false, nil)
                                return
                            }
                            guard let list = data.slider else {
                                completion(nil, false, nil)
                                return
                            }
                            completion(nil, true, list)
                        }else{
                            print("Failed")
                            completion(nil, false, nil)
                        }
                    }else{
                        completion(nil, false, nil)
                        print("Register Failed")
                    }
                }
        }
    }
    
    class func favorites(token: String, priceList: Int,view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool,_ favorites: [Favorite]?)->Void) {
        
        let url = "\(URLManager.favoritesURL)/\(priceList)"
        
        let parameters = ["api_token": token]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<800)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false, nil)
                    print(error)
                case .success( _):
                    print("favorites list \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        if let model = Parsing.parseFavorites(jsonData: response) {
                            guard let data = model.data else{
                                completion(nil, false, nil)
                                return
                            }
                            guard let list = data.favorites else {
                                completion(nil, false, nil)
                                return
                            }
                            completion(nil, true, list)
                        }else{
                            print("Failed")
                            completion(nil, false, nil)
                        }
                    }else{
                        completion(nil, false, nil)
                        print("Register Failed")
                    }
                }
        }
    }
    
    class func locationAPI(completion: @escaping (_ error: Error?, _ success: Bool, _ model: DetectLocationModel?)->Void) {
        
        let url = URLManager.locationImage
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<800)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false, nil)
                    print(error)
                case .success( _):
                    print("response location \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        if let model = Parsing.parseLocationImage(jsonData: response) {
                            print("successss")
                            completion(nil, true, model)
                        }else{
                            print("Failedddd")
                            completion(nil, false, nil)
                        }
                    }else{
                        completion(nil, false, nil)
                    }
                }
        }
    }
    
    class func addAddress(token: String, name: String,city: String, area: String, street: String, building: String, mFloor: String, apartment: String, lat: String, lang: String, aadditional: String ,view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool)->Void) {
        
        let url = URLManager.addAddress
        
        let parameters = ["api_token": token,
                          "name": name,
                          "city": city,
                          "area": area,
                          "street": street,
                          "building": building,
                          "floor": mFloor,
                          "apt": apartment,
                          "lat": lat,
                          "lng": lang,
                          "additional": aadditional]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<800)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false)
                    print(error)
                case .success( _):
                    print("favorites list \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        
                        completion(nil, true)
                    }else{
                        completion(nil, false)
                        print("Register Failed")
                    }
                }
        }
    }
    
    class func getAddresses(token: String, view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool, _ model: AddressModel?)->Void) {
        
        let url = URLManager.Addressess
        
        let parameters = ["api_token": token]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<800)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false, nil)
                    print(error)
                case .success( _):
                    print("favorites list \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        if let model = Parsing.parseAddress(jsonData: response) {
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
    
    class func history(token: String, view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool, _ model: HistoryModel?)->Void) {
        
        let url = URLManager.history
        
        let parameters = ["api_token": token]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<800)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false, nil)
                    print(error)
                case .success( _):
                    print("favorites list \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        if let model = Parsing.parseHistory(jsonData: response) {
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
    
    class func deviceType(token: String, view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool)->Void) {
        
        let url = URLManager.deviceType
        
        let parameters = ["api_token": token,
                          "device": "ios"]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<800)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false)
                    print(error)
                case .success( _):
                    print("favorites list \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        completion(nil, true)
                    }else{
                        completion(nil, false)
                        print("Register Failed")
                    }
                }
        }
    }
    
    class func historyDetails(token: String, orderID: String, view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool, _ model: HistoryDetailsModel?)->Void) {
        
        let url = "\(URLManager.historyDetails)\(orderID)"
        
        let parameters = ["api_token": token]
        
        print("history details  \(url)       \(token)")
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<800)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false, nil)
                    print(error)
                case .success( _):
                    print("history details \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        if let model = Parsing.parseHistoryDetails(jsonData: response) {
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
    
    class func rateOrder(token: String, rate: String, orderID: String, view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool)->Void) {
        
        let url = "\(URLManager.rateOrder)\(orderID)"
        print("url is \(url)")
        let parameters = ["api_token": token,
                          "rate": rate]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<800)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false)
                    print(error)
                case .success( _):
                    if Parsing.getResponse(jsonData: response){
                        completion(nil, true)
                    }else{
                        completion(nil, false)
                        print("Register Failed")
                    }
                }
        }
    }
    
    
    class func updateProfile(token: String, name: String, email: String, phone: String, gender: String, birthDate: String,view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool)->Void) {
        
        let url = URLManager.updateProfile
        
        let parameters = ["api_token": token,
                          "name": name,
                          "email": email,
                          "phone": phone,
                          "gender": gender,
                          "birthDate": birthDate]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<800)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false)
                    print(error)
                case .success( _):
                    print("update data \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        /*if let model = Parsing.parseUpdateProfile(jsonData: response) {
                         completion(nil, true)
                         }else{
                         completion(nil, false)
                         }*/
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
                    }else{
                        completion(nil, false)
                        print("Register Failed")
                    }
                }
        }
    }
    
    
    class func updatePassword(token: String, email: String, oldPass: String, newPass: String ,view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool)->Void) {
        
        let url = URLManager.updatePassword
        
        let parameters = ["api_token":token,
                          "email": email,
                          "password": oldPass,
                          "new_password": newPass]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<800)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false)
                    print(error)
                case .success( _):
                    print("update data \(String(describing: response.result.value))")
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
                    }else{
                        completion(nil, false)
                        print("Register Failed")
                    }
                }
        }
    }
    
    class func deleteAddress(token: String, id: String ,completion: @escaping (_ error: Error?, _ success: Bool)->Void) {
        
        let url = "\(URLManager.deleteAddress)\(id)"
        
        let parameters = ["api_token":token]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<800)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false)
                    print(error)
                case .success( _):
                    print("update data \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        completion(nil, true)
                    }else{
                        completion(nil, false)
                    }
                }
        }
    }
    
    class func contactUS(name: String, email: String, phone: String, message: String ,completion: @escaping (_ error: Error?, _ success: Bool)->Void) {
        
        let url = URLManager.contact
        
        let parameters = ["name": name,
                          "email": email,
                          "phone": phone,
                          "message": message]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<800)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false)
                    print(error)
                case .success( _):
                    print("update data \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        completion(nil, true)
                    }else{
                        completion(nil, false)
                    }
                }
        }
    }
    
}


