//
//  ItemOptionCell.swift
//  Prego
//
//  Created by owner on 9/18/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

class ItemOptionCell: UITableViewCell {

    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var mImage: UIImageView!
    
    
    func setPrice(price: String){
        guard let mPrice = Double(price) else {
            priceLabel.text = "\(price) \("pound".getLocalizedValue())"
            return
        }
        priceLabel.text = "\(Utilits.splitPrice(price: mPrice)) \("pound".getLocalizedValue())"
    }
}
