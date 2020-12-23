//
//  SideBarHomeCell.swift
//  MyRes
//
//  Created by Other Logic on 5/20/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit



class SideBarHomeCell: UICollectionViewCell {
    
    var vc: SideBarFrameVC? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func homeAction(_ sender: Any) {
        NotificationCenter.default.post(name: .didSideBar, object: nil)
    }
    
    @IBAction func ordersAction(_ sender: Any) {
//        guard DefaultManager.getUserToken() != nil else {
//            NavigationManager.toLoginDismiss(vc!)
//            return
//        }
        NavigationManager.toOrders(vc!)
    }
    
    @IBAction func offersAction(_ sender: Any) {
        NavigationManager.toOffers(vc!)
    }
    
    @IBAction func profileAction(_ sender: Any) {
//        guard DefaultManager.getUserToken() != nil else {
//            NavigationManager.toLoginDismiss(vc!)
//            return
//        }
        NavigationManager.toProfile(vc!)
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
//        guard DefaultManager.getUserToken() != nil else {
//            NavigationManager.toLoginDismiss(vc!)
//            return
//        }
        NavigationManager.toFavorites(vc!)
    }
}
