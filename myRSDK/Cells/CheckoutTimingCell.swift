//
//  CheckoutTimingCell.swift
//  Lepacha
//
//  Created by Other Logic on 6/23/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit

protocol TimingDelegate {
    func nowPressed()
    func laterPressed(laterTextField: UITextField)
}

class CheckoutTimingCell: UITableViewCell {
    
    @IBOutlet weak var nowBtn: UIButton!
    @IBOutlet weak var laterBtn: UIButton!
    @IBOutlet weak var laterField: UITextField!
    @IBOutlet weak var nowImage: UIImageView!
    @IBOutlet weak var laterImage: UIImageView!
    @IBOutlet weak var timingStack: UIStackView!
    @IBOutlet weak var nowView: UIView!
    
    var delegate: TimingDelegate?

    @IBAction func nowAction(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.nowImage.image = UIImage(named: "radio-full", in: frameworkBundle, compatibleWith: .none)
            self.laterImage.image = UIImage(named: "radio-empty", in: frameworkBundle, compatibleWith: .none)
        }
        delegate?.nowPressed()
    }
    
    @IBAction func laterAction(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.nowImage.image = UIImage(named: "radio-empty", in: frameworkBundle, compatibleWith: .none)
            self.laterImage.image = UIImage(named: "radio-full", in: frameworkBundle, compatibleWith: .none)
        }
        delegate?.laterPressed(laterTextField: laterField)
    }
    
}
