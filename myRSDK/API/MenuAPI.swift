//
//  MenuAPI.swift
//  myRSDK
//
//  Created by Other Logic on 9/3/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MenuAPI : NSObject {
    
    class func menus(areaID: String, view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool,_ menu: [Menu]?)->Void) {
        
        guard let resID = Utilits.getSelectedReasturantID() else {
            completion(nil, false, nil)
            return
        }
        
        let url = "\(URLManager.menuURL)/\(areaID)/\(resID)"
        
        print("menu urrl \(url)")
        
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
                        if let model = Parsing.parseMenus(jsonData: response) {
                            
                            /*guard let newModel = removeNoPrices(model: model) else {
                                completion(nil, false, nil)
                                return
                            }*/
                            
                            guard let data = model.data else{
                                completion(nil, false, nil)
                                return
                            }
                            guard let list = data.menu else {
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
    
    static func removeNoPrices(model: MenuModel) -> MenuModel?{
        var newModel = model
        guard let data = model.data else {
            return nil
        }
        guard let menus = data.menu else {
            return nil
        }
        
        for (index, menu) in menus.enumerated() {
            
            guard let items = menu.items else {
                return nil
            }
            
            for (itemIndex, item) in items.enumerated() {
                guard let info = item.info else {
                    return nil
                }
                if info.isEmpty {
                    return nil
                }
                
                if info[0].price == nil {
                    newModel.data?.menu![index].items?.remove(at: itemIndex)
                    return nil
                }
            }
        }
        return newModel
    }
    
    
    class func item(itemID: String, priceList: Int,view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool,_ menu: ItemModel?)->Void) {
        
        let url = "\(URLManager.itemURL)\(itemID)/\(priceList)"
        var api_token: String = ""
        var apiTokenKey: String = ""
        if let token = DefaultManager.getUserToken() {
            api_token = token
            apiTokenKey = "api_token"
        }
        let parameters = [apiTokenKey: api_token]
        
        print("item url \(url)")
        
        Alamofire.request(url, method: .get, parameters: parameters,encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<800)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false, nil)
                    print(error)
                case .success( _):
                    print("item loading is \(String(describing: response.result.value))")
                    if let model = Parsing.parseItem(jsonData: response) {
                        print("successss")
                        completion(nil, true, model)
                    }else{
                        print("Failedddd")
                        completion(nil, false, nil)
                    }
                }
        }
    }
    
    class func branches(view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool,_ menu: BranchModel?)->Void) {
        
        guard let resID = Utilits.getSelectedReasturantID() else {
            completion(nil, false, nil)
            return
        }
        
        let url = "\(URLManager.branchesURL)/\(resID)"
        
        print("branchess url \(url)")
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<800)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false, nil)
                    print(error)
                case .success( _):
                    print("item loading is \(String(describing: response.result.value))")
                    if let model = Parsing.parseBranches(jsonData: response) {
                        print("successss")
                        completion(nil, true, model)
                    }else{
                        print("Failedddd")
                        completion(nil, false, nil)
                    }
                }
        }
    }
    
    class func favorite(isFav: Bool, itemID: String, api_token: String ,view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool)->Void) {
        
        var url: String = ""
        if isFav {
            print("unfavorite ya man")
            url = "\(URLManager.removeFavorite)\(itemID)"
        }else{
            print("favorite ya man")
            url = "\(URLManager.addFavorite)\(itemID)"
        }
        
        print("fav url is \(url)")
        let parameters = ["api_token": api_token]
        
        Alamofire.request(url, method: .get, parameters: parameters,encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<800)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false)
                    print(error)
                case .success( _):
                    print("item loading is \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        print("successss")
                        completion(nil, true)
                    }else{
                        print("Failedddd")
                        completion(nil, false)
                    }
                }
        }
    }
    
    
    
    class func checkout(apiToken: String, items: NSMutableDictionary, payment: String, deliveryType: String, lat: String, lng: String, address: String, area: String, mBranch: String, coupon: String, notes: String, mTime: String ,deviceID: String, carType: String, carColor: String, view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool, _ message: String?,_ model: Checkout?)->Void) {
        
        let url: String = URLManager.checkout
        
        let jsonData = try! JSONSerialization.data(withJSONObject: items, options: [])
        let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)!
        
        print("responseJsonss \(jsonString)")
        
        let parameters = ["api_token": apiToken,
                          "items": jsonString,
                          "delivery_type": deliveryType,
                          "payment": payment,
                          "lat": lat,
                          "lng": lng,
                          "address": address,
                          "area": area,
                          "branch": mBranch,
                          "coupon": coupon,
                          "notes": notes,
                          "time": mTime,
                          "car_model": carType,
                          "car_color": carColor,
                          "device_id": deviceID] as [String : Any]// as [String : Any]
        
        print("order parameters \(parameters)")
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<800)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false, nil, nil)
                    print("checkout error \(error.localizedDescription)")
                    
                case .success( _):
                    print("checkout results is \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        print("successss")
                        if let model = Parsing.parseCheckout(jsonData: response) {
                            completion(nil, true, nil, model)
                        }else{
                            completion(nil, false, nil, nil)
                        }
                    }else{
                        if let model = Parsing.parseErrorMessage(jsonData: response) {
                            guard let message = model.messages else {
                                completion(nil, false, nil, nil)
                                return
                            }
                            completion(nil, false, message, nil)
                        }else{
                            completion(nil, false, nil, nil)
                        }
                        print("Failedddd")
                    }
                }
        }
    }
    
    
    class func coupon(apiToken: String, mCoupon: String, mDay: String, mTime: String ,view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool, _ model: CouponModel?)->Void) {
        
        let url: String = URLManager.coupon
        
        let parameters = ["api_token": apiToken,
                          "coupon": mCoupon,
                          "day": mDay,
                          "time": mTime]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<800)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false, nil)
                    print(error)
                case .success( _):
                    print("checkout results is \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        print("successss")
                        if let model = Parsing.parseCoupon(jsonData: response) {
                            print("successss")
                            completion(nil, true, model)
                        }else{
                            print("Failedddd")
                            completion(nil, false, nil)
                        }
                    }else{
                        print("Failedddd")
                        completion(nil, false, nil)
                    }
                }
        }
    }
    
    class func checkPayment(apiToken: String, orderID: String, SDKToken: String ,view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool)->Void) {
        
        let url: String = "\(URLManager.checkPayment)\(orderID)"
        
        let parameters = ["api_token": apiToken,
                          "token": SDKToken]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<800)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false)
                    print(error)
                case .success( _):
                    print("payment results is \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        print("successss")
                        completion(nil, true)
                    }else{
                        print("Failedddd")
                        completion(nil, false)
                    }
                }
        }
    }
    
    class func offers(menuID: String, priceList: Int,view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool, _ model: OfferModel?)->Void) {
        
        let url: String = "\(URLManager.offers)/\(menuID)/\(priceList)"
        
        print("offer urls \(url)")
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<800)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false, nil)
                    print(error)
                case .success( _):
                    print("checkout results is \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        print("successss")
                        if let model = Parsing.parseOffer(jsonData: response) {
                            print("successss")
                            completion(nil, true, model)
                        }else{
                            print("Failedddd")
                            completion(nil, false, nil)
                        }
                    }else{
                        print("Failedddd")
                        completion(nil, false, nil)
                    }
                }
        }
    }
    
    class func SettingsAPI(view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool, _ model: AppSetting?)->Void) {
        
        let url: String = URLManager.setting
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<800)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false, nil)
                    print(error)
                case .success( _):
                    print("checkout results is \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        print("successss")
                        if let model = Parsing.parseSettings(jsonData: response) {
                            print("successss")
                            guard let data = model.data else {
                                completion(nil, false, nil)
                                return
                            }
                            if let subData = data.settings {
                                completion(nil, true, subData)
                            }else{
                                completion(nil, false, nil)
                            }
                            
                        }else{
                            print("Failedddd")
                            completion(nil, false, nil)
                        }
                    }else{
                        print("Failedddd")
                        completion(nil, false, nil)
                    }
                }
        }
    }
    
    class func cancelOrder(apiToken: String, orderID: String, SDKToken: String ,view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool)->Void) {
        
        let url: String = "\(URLManager.cancelOrder)\(orderID)"
        
        let parameters = ["api_token": apiToken,
                          "token": SDKToken]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<800)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false)
                    print(error)
                case .success( _):
                    print("payment results is \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        print("successss")
                        completion(nil, true)
                    }else{
                        print("Failedddd")
                        completion(nil, false)
                    }
                }
        }
    }
    
    class func reasturantChain(areaID: String, view: UIView ,completion: @escaping (_ error: Error?, _ success: Bool, _ model: ReasturantChainModel?)->Void) {
        
        let url: String = "\(URLManager.restaurants)/\(areaID)"
        //let url = URLManager.restaurants
        
        print("chain urls \(url)")
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<800)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false, nil)
                    print(error)
                case .success( _):
                    print("checkout results is \(String(describing: response.result.value))")
                    if Parsing.getResponse(jsonData: response){
                        print("successss")
                        if let model = Parsing.parseReasturantChain(jsonData: response) {
                            print("successss")
                            completion(nil, true, model)
                        }else{
                            print("Failedddd")
                            completion(nil, false, nil)
                        }
                    }else{
                        print("Failedddd")
                        completion(nil, false, nil)
                    }
                }
        }
    }
}

