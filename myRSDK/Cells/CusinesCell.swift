//
//  CusinesCell.swift
//  Prego
//
//  Created by owner on 8/21/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

class CusinesCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    
    func seImage(url: String) {
        ImagesManager.setImage(url: url, image: imageView)
        //imageView.image = UIImage(named: url)
    }

}
