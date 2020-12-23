//
//  PointsVC.swift
//  MyRes
//
//  Created by Other Logic on 12/17/19.
//  Copyright © 2019 Other Logic. All rights reserved.
//

import UIKit

class PointsVC: UIViewController {
    
    @IBOutlet weak var redeemBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    func setUI(){
        redeemBtn.layer.borderWidth = 1
        redeemBtn.layer.borderColor = AppColorsManager.greenColor?.cgColor
    }

}
