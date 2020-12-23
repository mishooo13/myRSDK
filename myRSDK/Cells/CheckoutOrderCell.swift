//
//  CheckoutOrderCell.swift
//  Prego
//
//  Created by Other Logic on 11/11/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

protocol OrderDelegate {
    func makeOrder(grandTotal: Double) -> Void
}

class CheckoutOrderCell: UITableViewCell {

    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var deliveryTitleLabel: UILabel!
    @IBOutlet weak var deliveryFeeLabel: UILabel!
    @IBOutlet weak var deliveryFeeView: UIView!
    @IBOutlet weak var AmountPriceLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var taxView: UIView!
    @IBOutlet weak var placeOrderBtn: UIButton!
    
    @IBOutlet weak var couponLabel: UILabel!
    @IBOutlet weak var couponValueLabel: UILabel!
    @IBOutlet weak var couponView: UIView!
    
    @IBOutlet weak var vatText: UILabel!
    
    var address: Address?
    var branch: Branch?
    var delegate: OrderDelegate?
    var vc: UIViewController?
    var isAddress: Bool = false
    var isPickup: Bool = false
    var areaList: [AreaClass] = []
    
    var grandTotal: Double = 0.0
    
    override func awakeFromNib() {
        Utilits.cornerLeftRight(view: subView)
        subView.layer.shadowColor = UIColor.gray.cgColor
        subView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        subView.layer.shadowRadius = 12.0
        subView.layer.shadowOpacity = 0.7
    }
    
    func setDefaultArea(){
        print("responseeeA7aa \(areaList.count)")
        areaList.forEach({ (area) in
            
            if self.isAddress {
                guard let id = area.id else {
                    return
                }
                
                guard let choosedArea = address?.area else {
                    return
                }
                
                guard let choosedAreaID = choosedArea.id else {
                    return
                }
                
                if id == choosedAreaID {
                    DefaultManager.saveAreaDefault(value: area)
                }
                checkOpen()
                print("area id \(id)  \(choosedAreaID)")
            }
            
            if self.isPickup {
                guard let id = area.id else {
                    return
                }
                
                guard let choosedArea = branch?.area else {
                    return
                }
                
                guard let choosedAreaID = choosedArea.id else {
                    return
                }
                
                if id == choosedAreaID {
                    DefaultManager.saveAreaDefault(value: area)
                }
                checkOpen()
            }
            
        })
    }
    
    
    func checkOpen(){
        if !Utilits.checkIsOpen() {
            placeOrderBtn.isUserInteractionEnabled = false
            placeOrderBtn.setTitle("branchClose".getLocalizedValue(), for: .normal)
        }
    }
    
    func calculatePrice(isPickup: Bool, isAddress: Bool,totalPriceValue: Double, totalAmount: Double, discountValue: Double, vatPercentage: Double){
        
        if vatPercentage == 0 {
            hasNoVAT(isPickup: isPickup, isAddress: isAddress, totalPriceValue: totalPriceValue, totalAmount: totalAmount, discountValue: discountValue, vatPercentage: vatPercentage)
        }else{
            hasVAT(isPickup: isPickup, isAddress: isAddress, totalPriceValue: totalPriceValue, totalAmount: totalAmount, discountValue: discountValue, vatPercentage: vatPercentage)
        }
        
        
    }
    
    func hasNoVAT(isPickup: Bool, isAddress: Bool,totalPriceValue: Double, totalAmount: Double, discountValue: Double, vatPercentage: Double){
        
        print("response valuees \(totalPriceValue)  \(totalAmount)  \(discountValue)")
        
        taxView.isHidden = true
        vatText.isHidden = false
        
        totalPriceLabel.text = "\(Utilits.splitPrice(price: totalPriceValue.rounded(toPlaces: 2))) \("pound".getLocalizedValue())"
        
        var deliveryFee: Double = 0.0
        grandTotal = 0.0
        
        //Check if pickup or deleivery
        if isPickup {
            deliveryFeeView.isHidden = true
        }else if isAddress{
            
            guard let fee = Utilits.getDeliveryFees() else {
                return
            }
            
            //get delivery fee for the area
            deliveryFee = Double(fee)!
            deliveryFeeLabel.text = "\(Utilits.splitPrice(price: deliveryFee)) \("pound".getLocalizedValue())"
        }
        
        //Calculate the VAT
        let amountAfterDelivery = totalPriceValue + deliveryFee
        print("amount after delv \(amountAfterDelivery)   \(discountValue)")
        //taxFee = Double((amountAfterDelivery * 14) / 100)
        let amount: Double = amountAfterDelivery
        taxLabel.text = ""
        
        //Calcluate discount value
        if discountValue == 0 {
            grandTotal = amount
            couponView.isHidden = true
        }else{
            couponView.isHidden = false
            grandTotal = amount - discountValue
            couponValueLabel.text = "\(Utilits.splitPrice(price: discountValue)) \("pound".getLocalizedValue())"
        }
        
        //self.totalAmount = amount
        AmountPriceLabel.text = "\(Utilits.splitPrice(price: grandTotal.rounded(toPlaces: 2))) \("pound".getLocalizedValue())"
    }
    
    func hasVAT(isPickup: Bool, isAddress: Bool,totalPriceValue: Double, totalAmount: Double, discountValue: Double, vatPercentage: Double){
        
        taxView.isHidden = false
        vatText.isHidden = true
        print("response valuees \(totalPriceValue)  \(totalAmount)  \(discountValue)")
        
        totalPriceLabel.text = "\(Utilits.splitPrice(price: totalPriceValue.rounded(toPlaces: 2))) \("pound".getLocalizedValue())"
        
        var deliveryFee: Double = 0.0
        var taxFee: Double = 0.0
        grandTotal = 0.0
        
        //Check if pickup or deleivery
        if isPickup {
            deliveryFeeView.isHidden = true
        }else if isAddress{
            
            guard let fee = Utilits.getDeliveryFees() else {
                return
            }
            
            //get delivery fee for the area
            deliveryFee = Double(fee)!
            deliveryFeeLabel.text = "\(Utilits.splitPrice(price: deliveryFee)) \("pound".getLocalizedValue())"
        }
        
        //Calculate the VAT
        let amountAfterDelivery = totalPriceValue + deliveryFee
        print("amount after delv \(amountAfterDelivery)   \(discountValue)")
        taxFee = Double((amountAfterDelivery * vatPercentage) / 100)
        let amount: Double = amountAfterDelivery + taxFee
        taxLabel.text = "\(Utilits.splitPrice(price: taxFee)) \("pound".getLocalizedValue())"
        
        //Calcluate discount value
        if discountValue == 0 {
            grandTotal = amount
            couponView.isHidden = true
        }else{
            couponView.isHidden = false
            grandTotal = amount - discountValue
            couponValueLabel.text = "\(Utilits.splitPrice(price: discountValue)) \("pound".getLocalizedValue())"
        }
        
        //self.totalAmount = amount
        AmountPriceLabel.text = "\(Utilits.splitPrice(price: grandTotal.rounded(toPlaces: 2))) \("pound".getLocalizedValue())"
    }
    
    @IBAction func placeOrderAction(_ sender: Any) {
        delegate?.makeOrder(grandTotal: grandTotal)
    }
}
