//
//  SideBarCategoryCell.swift
//  MyRes
//
//  Created by Other Logic on 5/20/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit

class SideBarCategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func seImage(url: String) {
        ImagesManager.setImage(url: url, image: categoryImage)
        //imageView.image = UIImage(named: url)
    }

}
