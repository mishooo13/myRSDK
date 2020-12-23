//
//  AddressCell.swift
//  Prego
//
//  Created by owner on 9/23/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

protocol RemoveAddressDelegate {
    func removed() -> Void
}

class AddressCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    var delegate: RemoveAddressDelegate?
    
    @IBAction func removeAction(_ sender: Any) {
        removeAddress()
    }
    
    func removeAddress(){
        
        guard let token = DefaultManager.getUserToken() else {
            return
        }
        print("address data \(tag)")
        ProfileAPI.deleteAddress(token: token, id: "\(tag)") { (error, success) in
            if error != nil || !success{
                return
            }
            self.delegate?.removed()
        }
    }
}
