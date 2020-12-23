//
//  CheckoutPaymentCell.swift
//  Prego
//
//  Created by Other Logic on 11/14/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

enum PaymentMehod: String {
    case Cash = "1"
    case VISA = "2"
}

protocol PaymentDelegate {
    func passPayment(method: String) ->Void
}

class CheckoutPaymentCell: UITableViewCell {

    @IBOutlet weak var cashBtn: UIButton!
    @IBOutlet weak var visaBtn: UIButton!
    @IBOutlet weak var cashImage: UIImageView!
    @IBOutlet weak var visaImage: UIImageView!
    @IBOutlet weak var paymentStack: UIStackView!
    @IBOutlet weak var visaView: UIView!
    
    var delegate: PaymentDelegate?
    
    @IBAction func caseAction(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.cashImage.image = UIImage(named: "radio-full", in: frameworkBundle, compatibleWith: .none)
            self.visaImage.image = UIImage(named: "radio-empty", in: frameworkBundle, compatibleWith: .none)
        }
        delegate?.passPayment(method: PaymentMehod.Cash.rawValue)
    }
    
    @IBAction func visaAction(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.cashImage.image = UIImage(named: "radio-empty", in: frameworkBundle, compatibleWith: .none)
            self.visaImage.image = UIImage(named: "radio-full", in: frameworkBundle, compatibleWith: .none)
        }
        delegate?.passPayment(method: PaymentMehod.VISA.rawValue)
    }
    
    func checkIFPaymentExist(checkPaymenyExist: String){
        if checkPaymenyExist == "1" {
            visaView.isHidden = false
        }else{
            visaView.isHidden = true
        }
    }
}
