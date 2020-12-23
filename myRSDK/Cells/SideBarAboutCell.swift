//
//  SideBarAboutCell.swift
//  MyRes
//
//  Created by Other Logic on 5/20/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit

class SideBarAboutCell: UICollectionViewCell {
    
    var vc: SideBarFrameVC? = nil
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func getHelpAction(_ sender: Any) {
        NavigationManager.toContactusVC(vc!)
    }
    
    @IBAction func aboutAction(_ sender: Any) {
        NavigationManager.toAbout(vc!)
    }
    
    @IBAction func shareAction(_ sender: Any) {
        if let name = URL(string: APPSTORE_URL), !name.absoluteString.isEmpty {
            let objectsToShare = [name]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            vc?.present(activityVC, animated: true, completion: nil)
        }else  {
            // show alert for not available
        }
    }

}
