//
//  SplashVC.swift
//  Prego
//
//  Created by owner on 8/19/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

public class SplashVC: UIViewController {
    
    public var token: String?
    public var phone: String?

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            if self.token == nil && self.phone == nil {
                AlertManager.showWrongAlert(on: self)
            }else{
                DefaultManager.saveTokenDefault(token: self.token!)
                DefaultManager.savePhoneDefault(token: self.phone!)
                NavigationManager.toDetectLocation(self)
            }
            
            //NavigationManager.toLogin(self)
        })
        
        
        
        
    }
    
    public init() {
        super.init(nibName: "SplashVC", bundle: Bundle(for: SplashVC.self))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
