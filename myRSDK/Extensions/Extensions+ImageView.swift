//
//  Extensions+ImageView.swift
//  Prego
//
//  Created by owner on 10/21/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit


extension UIImageView {
    func renderImage(color: UIColor){
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
}
