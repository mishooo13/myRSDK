//
//  HomeLocationCell.swift
//  MyRes
//
//  Created by Other Logic on 11/21/19.
//  Copyright © 2019 Other Logic. All rights reserved.
//

import UIKit

protocol LocationDelegate {
    func locationClicked()
}

class HomeLocationCell: UICollectionViewCell {
    
    var delegate: LocationDelegate?
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //setTitle()
    }
    
    func setTitle(){
        
    }
    
    @IBAction func locationAction(_ sender: Any) {
        delegate?.locationClicked()
    }

}
