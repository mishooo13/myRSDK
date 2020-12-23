//
//  OfferCell.swift
//  Prego
//
//  Created by owner on 10/8/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

class OfferCell: UITableViewCell {

    @IBOutlet weak var mImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    func seImage(url: String) {
        ImagesManager.setImage(url: url, image: mImageView)
        //mImageView.image = UIImage(named: url)
    }
    
    func setPrice(info: [Info]) {
        if !info.isEmpty {
            if let price = info[0].priceAr {
                if info.count == 1 {
                    priceLabel.text = "\(price) \("pound".getLocalizedValue())"
                }else{
                    priceLabel.text = "\("price_start".getLocalizedValue()) \(price) \("pound".getLocalizedValue())"
                }
            }
        }
    }
    
}
