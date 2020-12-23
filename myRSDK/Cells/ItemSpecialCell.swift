//
//  ItemSpecialCell.swift
//  Prego
//
//  Created by owner on 10/2/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

protocol SpecialDelegate {
    func passSpecialText(text: String)
}

class ItemSpecialCell: UITableViewCell {

    @IBOutlet weak var specialField: UITextField!
    
    var delegate: SpecialDelegate?
    
    override func awakeFromNib() {
        specialField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        delegate?.passSpecialText(text: text)
    }
}
