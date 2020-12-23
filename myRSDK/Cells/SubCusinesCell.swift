//
//  SubCusinesCell.swift
//  Prego
//
//  Created by owner on 8/21/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

class SubCusinesCell: UITableViewCell {

    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var mImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    
    override func awakeFromNib() {
        if APPLanguage() == Config.Arablic {
            priceLabel.textAlignment = .left
        }
    }
    
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
