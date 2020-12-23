//
//  AboutFrameVC.swift
//  myRSDK
//
//  Created by Other Logic on 9/13/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit

class AboutFrameVC: UIViewController {

    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var versionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkAppVersion()
    }
    
    public init() {
        super.init(nibName: "AboutFrameVC", bundle: Bundle(for: AboutFrameVC.self))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkAppVersion(){
        if let ourVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String{
            self.versionLabel.text = "Myres \(ourVersion)"
        }
    }
    
    @IBAction func aboutAction(_ sender: Any) {
        
        toAboutContent(title: "terms".getLocalizedValue(), url: "http://prego-foods.com/about.html")
    }
    
    @IBAction func termsAction(_ sender: Any) {
        
        toAboutContent(title: "terms".getLocalizedValue(), url: "http://myres.me/lepacha/terms.html")
    }
    @IBAction func refundAction(_ sender: Any) {
        
        toAboutContent(title: "refund".getLocalizedValue(), url: "http://myres.me/lepacha/refund.html")
    }
    
    @IBAction func privacyAction(_ sender: Any) {
        
        toAboutContent(title: "privacy".getLocalizedValue(), url: "http://myres.me/lepacha/privacy.html")
    }
    
    @IBAction func deliveryAction(_ sender: Any) {
        
        toAboutContent(title: "privacy".getLocalizedValue(), url: "http://myres.me/lepacha/deliverypolicy.html")
    }
    
    func toAboutContent(title: String, url: String){
        let newVC = AboutWebFrameVC()
        
        newVC.linkURL = url
        newVC.mTitle = title
        newVC.modalPresentationStyle = .fullScreen
        
        present(newVC, animated: true, completion: nil)
    }

}
