//
//  ChcekoutItemCell.swift
//  Prego
//
//  Created by owner on 9/25/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

class ChcekoutItemCell: UITableViewCell {

    @IBOutlet weak var itemQuantity: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    
    func calculatePrice(quantity: Int, totalPrice: Double){
        let allTotal: Double = Double(quantity) * totalPrice
        //allTotal = Double(round(100*allTotal)/100)
        totalPriceLabel.text = "\(allTotal) \("pound".getLocalizedValue())"
    }
}



