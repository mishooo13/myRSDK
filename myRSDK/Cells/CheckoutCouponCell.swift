//
//  CheckoutCouponCell.swift
//  Prego
//
//  Created by mac on 11/6/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

protocol CouponDelegate {
    func passCoupon(coupon: String, discountValue: Double) -> Void
    func removeCoupon() -> Void
    func showCouponLoadingView() -> Void
    func hideCouponLoadingView() -> Void
}

class CheckoutCouponCell: UITableViewCell {
    
    var totalPriceValue: Double = 0
    var address: Address?
    var branch: Branch?
    var isAddress: Bool = false
    var isPickup: Bool = false
    var vc: UIViewController?
    var delegate: CouponDelegate?
    var carts: [Cart]?
    var paymenyType: String = ""

    @IBOutlet weak var couponLabel: UILabel!
    @IBOutlet weak var couponField: UITextField!
    @IBOutlet weak var couponBtn: UIButton!
    
    let REMOVE_TAG = 1
    let ADD_TAG = 0
    
    
    //Coupon Validation
    @IBAction func couponAction(_ sender: UIButton) {
        print("total priiiiiice coupon \(totalPriceValue)")
        if sender.tag == ADD_TAG {
            addCoupon()
        }else if sender.tag == REMOVE_TAG{
            removeCoupon()
        }
    }
    
    func addCoupon(){
        if !Connectivity.isConnectedToInternet {
            AlertManager.showWrongAlertWithMessage(on: vc!, message: "internet_failed".getLocalizedValue())
            return
        }
        guard let coupoun = couponField.text else {
            return
        }
        if coupoun.isEmpty {
            return
        }
        getCoupon(mCoupon: coupoun)
    }
    
    func removeCoupon(){
        couponLabel.text = "add_promo".getLocalizedValue()
        couponLabel.textColor = UIColor.darkGray
        couponBtn.tag = ADD_TAG
        couponBtn.setTitle("add".getLocalizedValue(), for: .normal)
        couponField.text = ""
        
        delegate?.removeCoupon()
    }
    
    func getCoupon(mCoupon: String){
        guard let token = DefaultManager.getUserToken() else {
            return
        }
        delegate?.showCouponLoadingView()
        MenuAPI.coupon(apiToken: token, mCoupon: mCoupon, mDay: Utilits.getCurrentDate(), mTime: Utilits.getCurrentTime(), view: self) { (error, success, model) in
            self.delegate?.hideCouponLoadingView()
            if error != nil || !success {
                self.invalidCoupon()
                return
            }
            guard let coupon = model?.coupon else {
                self.invalidCoupon()
                return
            }
            self.validCoupon(coupon: coupon)
        }
    }
    
    func validCoupon(coupon: Coupon){
        if let minumPrice = coupon.discountForAmountMoreThan {
            print("reponse case 1")
            if totalPriceValue >= Double(minumPrice){
                print("reponse case 3")
                setCouponAsValid(coupon: coupon)
            }else{
                invalidCouponWithMinium(minumPrice: minumPrice)
            }
        }else{
            print("reponse case 2")
            setCouponAsValid(coupon: coupon)
        }
    }
    
    func setCouponAsValid(coupon: Coupon){
        
        if let included = coupon.includeItems {
            print("responseCoupoun \(Utilits.splitStringWithComma(value: included))")
            
            if included.isEmpty {
                self.invalidCoupon()
                return
            }
            
            var subTotalOfIncluded: Double = 0
            let includedItems = Utilits.splitStringWithComma(value: included)
            includedItems.forEach { (infoID) in
                carts?.forEach({ (cart) in
                    
                    if let id = cart.info_id {
                        if infoID == id {
                            print("responseID \(infoID)  \(id)")
                            subTotalOfIncluded += Double(cart.quantity) * cart.total_price
                        }
                    }
                })
            }
            
            if subTotalOfIncluded == 0 {
                self.invalidCoupon()
                return
            }
            print("responsePrice \(subTotalOfIncluded)")
            completeDiscountValue(coupon: coupon, price: subTotalOfIncluded)
            
        }else{
            if totalPriceValue != 0 {
                completeDiscountValue(coupon: coupon, price: totalPriceValue)
            }
            
        }
    }
    
    func completeDiscountValue(coupon: Coupon, price: Double){
        var discountValue: Double = 0
        if let fixedPrice = coupon.fixed {
            //First case if coupon have fixed money to discount
            print("reponse case 4")
            if fixedPrice != 0 {
                print("amount after delv firstttttt")
                discountValue = Double(fixedPrice)
            }
        }
        
        if let percentage = coupon.percentage, let maxDiscount = coupon.maxDiscountAmount {
            //Second case if have percenatge with limit of money
            if percentage != 0 && maxDiscount != 0 {
                print("amount after delv secooond")
                let discount: Double = getPriceDiscountPrice(percentage: percentage, price: price)
                if discount >= Double(maxDiscount) {
                    discountValue = Double(maxDiscount)
                }else{
                    discountValue = discount
                }
            }
        }
        
        if let percentage = coupon.percentage {
            //Third Case if coupon have percenage without conditions
            if percentage != 0 && discountValue == 0{
                print("amount after delv thirrrd")
                discountValue = getPriceDiscountPrice(percentage: percentage, price: price)
            }
        }else {
            //Fourth in have not value
            invalidCoupon()
        }
        
        //Check payment discount
        if isAddress{
            if let fee = Utilits.getDeliveryFees(), let deliveryFee = Double(fee) {
                
                //Discount delivery fee
                if let freeDelivery = coupon.freeDelivery {
                    if freeDelivery == "1" {
                        discountValue += deliveryFee
                    }
                    print("discount value freeDelivery \(freeDelivery)   \(discountValue)")
                }
                
                //Discount delivery fee if payment with visa
                if let freeOnPayCard = coupon.freeOnPayCard {
                    if freeOnPayCard == "1" {
                        if paymenyType.isEmpty {
                            invalidCoupon()
                            return
                        }else{
                            if paymenyType == PaymentMehod.VISA.rawValue {
                                discountValue += deliveryFee
                            }else{
                                invalidCoupon()
                                return
                            }
                        }
                    }
                    print("discount value freeDelivery \(PaymentMehod.VISA.rawValue)  \(paymenyType)   \(freeOnPayCard)   \(discountValue)")
                }
                
            }
        }
        
        
        
        print("discounnnnt \(discountValue)")
        if discountValue != 0 {
            guard let coupoun = couponField.text else {
                return
            }
            if coupoun.isEmpty {
                return
            }
            delegate?.passCoupon(coupon: coupoun, discountValue: discountValue)
            
            
            
            
            self.couponLabel.textColor = AppColorsManager.greenColor
            if DefaultManager.getLanguageDefault() == Config.English {
                guard let couponTxt = coupon.couponDescription else {
                    return
                }
                self.couponLabel.text = couponTxt
            }else{
                guard let couponTxt = coupon.couponDescriptionAr else {
                    return
                }
                self.couponLabel.text = couponTxt
            }
            couponBtn.tag = REMOVE_TAG
            couponBtn.setTitle("remove".getLocalizedValue(), for: .normal)
        }else{
            if let fixedPrice = coupon.fixed {
                if fixedPrice == 0 {
                    guard let coupoun = couponField.text else {
                        return
                    }
                    if coupoun.isEmpty {
                        return
                    }
                    delegate?.passCoupon(coupon: coupoun, discountValue: discountValue)
                    
                    
                    
                    self.couponLabel.textColor = AppColorsManager.greenColor
                    if DefaultManager.getLanguageDefault() == Config.English {
                        guard let couponTxt = coupon.couponDescription else {
                            return
                        }
                        self.couponLabel.text = couponTxt
                    }else{
                        guard let couponTxt = coupon.couponDescriptionAr else {
                            return
                        }
                        self.couponLabel.text = couponTxt
                    }
                    couponBtn.tag = REMOVE_TAG
                    couponBtn.setTitle("remove".getLocalizedValue(), for: .normal)
                }
            }
        }
    }
    
    func getPriceDiscountPrice(percentage: Int, price: Double) -> Double{
        
        /*var deliveryFee: Double = 0
        if isPickup {
            deliveryFee = 0
        }else if isAddress{
            guard let area = address?.area else{
                return 0
            }
            guard let fee = area.delivery_fees else {
                return 0
            }
            
            //get delivery fee for the area
            deliveryFee = Double(fee)!
        }*/
        
        let discountPrice: Double = (price * Double(percentage)) / 100
        return discountPrice
    }
    
    func invalidCoupon(){
        self.couponLabel.text = "invalid_coupon".getLocalizedValue()
        self.couponLabel.textColor = UIColor.red
    }
    
    func invalidCouponWithMinium(minumPrice: Int){
        self.couponLabel.text = "\("minium_order".getLocalizedValue()) \(minumPrice) \("pound".getLocalizedValue())"
        self.couponLabel.textColor = UIColor.red
    }
}
