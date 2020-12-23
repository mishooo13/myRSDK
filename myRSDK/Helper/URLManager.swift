//
//  URLManager.swift
//  Prego
//
//  Created by owner on 8/21/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation

public class URLManager {
    static let mainURL: String              = "https://myres.me/myres/api/"
    static let imageURL: String             = "https://myres.me/myres/"

//    static let mainURL: String              = "https://myres.me/lepacha/api/"
//    static let imageURL: String             = "https://myres.me/lepacha/"
    
    public static let sliderURL             = mainURL + "slider"
    public static let loginURL              = mainURL + "login"
    public static let registerURL           = mainURL + "register"
    public static let facebookLoginURL      = mainURL + "login-with/facebook"
    public static let appleLoginURL         = mainURL + "login-with/apple"
    public static let favoritesURL          = mainURL + "favorites"
    public static let menuURL               = mainURL + "menu"
    public static let itemURL               = mainURL + "item/"
    public static let branchesURL           = mainURL + "branches"
    public static let addFavorite           = mainURL + "like/"
    public static let removeFavorite        = mainURL + "dislike/"
    public static let checkout              = mainURL + "orders/create"
    public static let addAddress            = mainURL + "profile/address/add"
    public static let Addressess            = mainURL + "profile/address"
    public static let coupon                = mainURL + "coupon/validation"
    public static let offers                = mainURL + "offers"
    public static let areas                 = mainURL + "areas"
    public static let history               = mainURL + "user/history"
    public static let rateOrder             = mainURL + "order/rate/"
    public static let historyDetails        = mainURL + "order/details/"
    public static let payment               = mainURL + "payment"
    public static let cancelOrder           = mainURL + "payment/cancel/"
    public static let updateProfile         = mainURL + "profile/update"
    public static let updatePassword        = mainURL + "profile/update/password"
    public static let checkPayment          = mainURL + "payment/success/"
    public static let deleteAddress         = mainURL + "profile/address/delete/"
    public static let contact               = mainURL + "contact_us"
    public static let locationImage         = mainURL + "splash"
    public static let setting               = mainURL + "settings"
    public static let deviceType            = mainURL + "profile/device/type"
    public static let restaurants           = mainURL + "restaurants"
    
    
    
    
    
}
