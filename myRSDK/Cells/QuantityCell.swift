//
//  QuantityCell.swift
//  Prego
//
//  Created by owner on 9/22/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

protocol QuantityDelegate {
    func quantityFun(quantity: Int) -> Void
    func errorMessage(message: String) -> Void
}

class QuantityCell: UITableViewCell {

    @IBOutlet weak var quanLabel: UILabel!
    @IBOutlet weak var mView: UIView!
    
    var delegate: QuantityDelegate?
    var quantity: Int = 1
    
    override func awakeFromNib() {
        mView.shadowAndBorderForTableViewCell(cell: mView, cornerRadious: 8)
    }
    
    @IBAction func moreAction(_ sender: Any) {
        quantity += 1
        quanLabel.text = "\(quantity)"
        delegate?.quantityFun(quantity: quantity)
    }
    
    @IBAction func minusAction(_ sender: Any) {
        if quantity == 1 {
            delegate?.errorMessage(message: "quatity_error".getLocalizedValue())
            
        }else{
            quantity -= 1
            quanLabel.text = "\(quantity)"
            delegate?.quantityFun(quantity: quantity)
        }
    }
}
