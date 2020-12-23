//
//  HomeFoodsCell.swift
//  MyRes
//
//  Created by Other Logic on 11/24/19.
//  Copyright © 2019 Other Logic. All rights reserved.
//

import UIKit

class HomeFoodsCell: UICollectionViewCell {
    
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
        if info.count == 1 {
            if let price = Utilits.getPriceFromInfo(info: info) {
                priceLabel.isHidden = false
                priceLabel.text = "\(Utilits.splitPrice(price: price)) \("pound".getLocalizedValue())"
            }else{
                priceLabel.isHidden = true
            }
        }else{
            if let price = Utilits.getPriceFromInfo(info: info) {
                priceLabel.isHidden = false
                priceLabel.text = "\("price_start".getLocalizedValue()) \(Utilits.splitPrice(price: price)) \("pound".getLocalizedValue())"
            }else{
                priceLabel.isHidden = true
            }
        }
    }

}
