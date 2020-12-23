//
//  ReasturantChainCell.swift
//  MyRes
//
//  Created by Other Logic on 7/13/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit

class ReasturantChainCell: UITableViewCell {
    
    @IBOutlet weak var mImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func seImage(url: String) {
        ImagesManager.setImage(url: url, image: mImageView)
    }
    
}
