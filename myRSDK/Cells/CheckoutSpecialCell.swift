//
//  CheckoutSpecialCell.swift
//  Lepacha
//
//  Created by Other Logic on 6/23/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit

protocol CheckoutSpecialDelegate {
    func passSpecialText(text: String)
}

class CheckoutSpecialCell: UITableViewCell {

    @IBOutlet weak var specialField: UITextField!
    var delegate: CheckoutSpecialDelegate?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mCollectionView: UICollectionView!
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
    //var mCollection: UICollectionView?
    
    
    override func awakeFromNib() {
        specialField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        delegate?.passSpecialText(text: text)
        
    }
    
    
    //Chips collection view
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func resizeCollectionView(){
        let height = mCollectionView.collectionViewLayout.collectionViewContentSize.height
        collectionHeightConstraint.constant = height
        mCollectionView.reloadData()
    }
    
}
