//
//  Parsing.swift
//  myRSDK
//
//  Created by Other Logic on 9/3/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit
import Alamofire

public class Parsing {
    
    
    //Get response from server {TRUE or FALSE}
    static func getResponse(jsonData: DataResponse<Any>?) -> Bool {
        
        var response: Bool = false
        
        do{
            let resultObject = try JSONDecoder().decode(Response.self, from: (jsonData?.data!)!)
            if resultObject.response {
                response = true
            }else{
                response = false
            }
        }catch {
            print("Error: \(error)")
        }
        
        return response
    }
    
    static func parseErrorMessage(jsonData: DataResponse<Any>?) -> ResponseMessage? {
        
        var user: ResponseMessage?
        do{
            user = try JSONDecoder().decode(ResponseMessage.self, from: (jsonData?.data!)!)
            
        }catch {
            print("Error: \(error)")
        }
        return user!
    }
    
    //Parse Login
    static func parseLogin(jsonData: DataResponse<Any>?) -> User {
        
        var user: User?
        do{
            user = try JSONDecoder().decode(User.self, from: (jsonData?.data!)!)
            
        }catch {
            print("Error: \(error)")
        }
        return user!
    }
    
    static func parseFavorites(jsonData: DataResponse<Any>?) -> FavoriteModel? {
        
        var user: FavoriteModel?
        do{
            user = try JSONDecoder().decode(FavoriteModel.self, from: (jsonData?.data!)!)
            
        }catch {
            print("Error: \(error)")
        }
        return user!
    }
    
    
    
    static func parseMenus(jsonData: DataResponse<Any>?) -> MenuModel? {
        
        var user: MenuModel?
        do{
            user = try JSONDecoder().decode(MenuModel.self, from: (jsonData?.data!)!)
            
        }catch {
            print("Error: \(error)")
        }
        return user!
    }
    
    static func parseItem(jsonData: DataResponse<Any>?) -> ItemModel? {
        
        var user: ItemModel?
        do{
            user = try JSONDecoder().decode(ItemModel.self, from: (jsonData?.data!)!)
            
        }catch {
            print("Error: \(error)")
        }
        return user!
    }
    
    static func parseBranches(jsonData: DataResponse<Any>?) -> BranchModel? {
        
        var user: BranchModel?
        do{
            user = try JSONDecoder().decode(BranchModel.self, from: (jsonData?.data!)!)
            
        }catch {
            print("Error: \(error)")
        }
        return user!
    }
    
    static func parseLocationImage(jsonData: DataResponse<Any>?) -> DetectLocationModel? {
        
        var user: DetectLocationModel?
        do{
            user = try JSONDecoder().decode(DetectLocationModel.self, from: (jsonData?.data!)!)
            
        }catch {
            print("Error: \(error)")
        }
        return user!
    }
    
    static func parseAddress(jsonData: DataResponse<Any>?) -> AddressModel? {
        
        var user: AddressModel?
        do{
            user = try JSONDecoder().decode(AddressModel.self, from: (jsonData?.data!)!)
            
        }catch {
            print("Error: \(error)")
        }
        return user!
    }
    
    static func parseHome(jsonData: DataResponse<Any>?) -> HomeSlider? {
        
        var user: HomeSlider?
        do{
            user = try JSONDecoder().decode(HomeSlider.self, from: (jsonData?.data!)!)
            
        }catch {
            print("Error: \(error)")
        }
        return user!
    }
    
    static func parseCoupon(jsonData: DataResponse<Any>?) -> CouponModel? {
        
        var user: CouponModel?
        do{
            user = try JSONDecoder().decode(CouponModel.self, from: (jsonData?.data!)!)
            
        }catch {
            print("Error: \(error)")
        }
        return user!
    }
    
    static func parseOffer(jsonData: DataResponse<Any>?) -> OfferModel? {
        
        var user: OfferModel?
        do{
            user = try JSONDecoder().decode(OfferModel.self, from: (jsonData?.data!)!)
            
        }catch {
            print("Error: \(error)")
        }
        return user!
    }
    
    static func parseAreas(jsonData: DataResponse<Any>?) -> AreaModel? {
        
        var user: AreaModel?
        do{
            user = try JSONDecoder().decode(AreaModel.self, from: (jsonData?.data!)!)
            
        }catch {
            print("Error: \(error)")
        }
        return user!
    }
    
    static func parseHistory(jsonData: DataResponse<Any>?) -> HistoryModel? {
        
        var user: HistoryModel?
        do{
            user = try JSONDecoder().decode(HistoryModel.self, from: (jsonData?.data!)!)
            
        }catch {
            print("Error: \(error)")
        }
        return user!
    }
    
    static func parseHistoryDetails(jsonData: DataResponse<Any>?) -> HistoryDetailsModel? {
        
        var user: HistoryDetailsModel?
        do{
            user = try JSONDecoder().decode(HistoryDetailsModel.self, from: (jsonData?.data!)!)
            
        }catch {
            print("Error: \(error)")
        }
        return user!
    }
    
    static func parseCheckout(jsonData: DataResponse<Any>?) -> Checkout? {
        
        var user: Checkout?
        do{
            user = try JSONDecoder().decode(Checkout.self, from: (jsonData?.data!)!)
            
        }catch {
            print("Error: \(error)")
        }
        return user!
    }
    
    static func parseUpdateProfile(jsonData: DataResponse<Any>?) -> ResponseUpdateProfile? {
        
        var user: ResponseUpdateProfile?
        do{
            user = try JSONDecoder().decode(ResponseUpdateProfile.self, from: (jsonData?.data!)!)
            
        }catch {
            print("Error: \(error)")
        }
        return user!
    }
    
    static func parseSettings(jsonData: DataResponse<Any>?) -> AppSettingsModel? {
        
        var user: AppSettingsModel?
        do{
            user = try JSONDecoder().decode(AppSettingsModel.self, from: (jsonData?.data!)!)
            
        }catch {
            print("Error: \(error)")
        }
        return user!
    }
    
    static func parseReasturantChain(jsonData: DataResponse<Any>?) -> ReasturantChainModel? {
        
        var user: ReasturantChainModel?
        do{
            user = try JSONDecoder().decode(ReasturantChainModel.self, from: (jsonData?.data!)!)
            
        }catch {
            print("Error: \(error)")
        }
        return user!
    }
}



