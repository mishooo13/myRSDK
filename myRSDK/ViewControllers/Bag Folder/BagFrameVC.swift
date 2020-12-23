//
//  BagFrameVC.swift
//  myRSDK
//
//  Created by Other Logic on 9/10/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit

class BagFrameVC: UIViewController {

    @IBOutlet weak var cartImage: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var squareView: UIView!
    @IBOutlet weak var subSquareView: UIView!
    
    var isFromHome: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if isFromHome {
//            cartImage.renderImage(color: UIColor.black)
//            squareView.backgroundColor = UIColor.black
//            subSquareView.backgroundColor = UIColor.red
//            countLabel.textColor = UIColor.white
//        }else{
//            cartImage.renderImage(color: UIColor.white)
//        }
        
        cartImage.renderImage(color: UIColor.black)
        squareView.backgroundColor = UIColor.black
        subSquareView.backgroundColor = UIColor.red
        countLabel.textColor = UIColor.white
        
        observerHandling()
    }
    
    public init() {
        super.init(nibName: "BagFrameVC", bundle: Bundle(for: BagFrameVC.self))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCartData()
    }
    
    func observerHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAreaChanges), name: .didCartChanged, object: nil)
    }
    
    @objc func handleAreaChanges(){
        loadCartData()
    }
    
    func loadCartData(){
        if let carts = CoreDaTaHandler.getCarts() {
            if carts.count != 0 {
                squareView.isHidden = false
                countLabel.text = "\(carts.count)"
            }else{
                squareView.isHidden = true
            }
        }
    }
    
    @IBAction func bagAction(_ sender: Any) {
        NavigationManager.toCart(self)
    }
}
