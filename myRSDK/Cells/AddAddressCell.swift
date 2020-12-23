//
//  AddAddressCell.swift
//  Prego
//
//  Created by Other Logic on 11/12/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

protocol AddAddressDelegate {
    func addressAction() -> Void
}

class AddAddressCell: UITableViewCell {
    
    var delegate: AddAddressDelegate?

    @IBAction func addAddressAction(_ sender: Any) {
        delegate?.addressAction()
    }
    
}
