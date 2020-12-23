//
//  SpalshViewController.swift
//  myRSDK
//
//  Created by Other Logic on 8/31/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit

class SpalshViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func toAlertAction(_ sender: Any) {
//        let alertVC = PMAlertController(title: "mTitle", description: "mMessage", image: UIImage(named: "logo22.png"), style: .alert)
//
//        alertVC.addAction(PMAlertAction(title: "mActionTitle", style: .cancel, action: { () -> Void in
//            print("Capture action Cancel")
//        }))
//
//        present(alertVC, animated: true, completion: nil)
        
//        if CoreDaTaHandler.saveCart(itemID: "1", image: "ee", title: "ttest", specialRequest: "ss", desc: "ss", quantity: 22, totalPrice: 33, infoId: "ss", optionsIds: "ss", extraIds: "ss", offer: true, couponOffer: true, mDate: "ssdd"){
//            print("suuuuuuuceeeseseesesss")
//        }
    }
    
    public init() {
        super.init(nibName: "SpalshViewController", bundle: Bundle(for: SpalshViewController.self))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
