//
//  ItemImageCell.swift
//  Prego
//
//  Created by owner on 9/18/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

protocol ItemImageDelegate {
    func dismissItem() -> Void
    func favoriteAction() -> Void
    func shareAction() -> Void
}

class ItemImageCell: UITableViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var favImage: UIButton!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemDetails: UILabel!
    
    var delegate: ItemImageDelegate?
    
    func setItemInfo(item: ItemModel, mImage: String, isFavorite: Bool){
        if APPLanguage() == Config.English {
            if let title = item.nameEn {
                itemName.text = title
            }
            if let desc = item.desriptionEn {
                itemDetails.text = desc
            }
        }else{
            if let title = item.nameAr {
                itemName.text = title
            }
            if let desc = item.desriptionAr {
                itemDetails.text = desc
            }
        }
        
        if let info = item.info {
            if !info.isEmpty {
                if let price = info[0].priceEn {
                    //itemPrice.text = "\(price) \(NSLocalizedString("pound", comment: ""))"
                }
            }
        }
        ImagesManager.setImage(url: mImage, image: itemImage)
        
        
        if isFavorite {
            
            
            if let image = UIImage(named: "selected", in: frameworkBundle, with: .none){
                favImage.setImage(image, for: .normal)
                favImage.tintColor = UIColor.red
            }
        }else{
            if let image = UIImage(named: "favorite", in: frameworkBundle, with: .none){
                favImage.setImage(image, for: .normal)
                favImage.tintColor = UIColor.darkGray
            }
           
        }
    }
    
    @IBAction func shareAction(_ sender: Any) {
        delegate?.shareAction()
    }
    
    @IBAction func favouriteAction(_ sender: Any) {
        delegate?.favoriteAction()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        delegate?.dismissItem()
    }
    
}
