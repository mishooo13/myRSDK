//
//  AppStoreUpdateVC.swift
//  MyRes
//
//  Created by Other Logic on 6/9/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit

let APPSTORELINK = "itms-apps://itunes.apple.com/app/id1518046060"

class AppStoreUpdateVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var updateAction: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("response hereee")
        VersionManager.shared.checkAppStore { (isNew, ourVersion, storeVersion) in
            if let storeVersion = storeVersion {
                self.subTitleLabel.text = "A new version of Myres is available. Please update to version \(storeVersion) now."
            }
            if !isNew {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }

    @IBAction func updateAction(_ sender: Any) {
        if let url = URL(string: APPSTORELINK),
            UIApplication.shared.canOpenURL(url)
        {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
}

