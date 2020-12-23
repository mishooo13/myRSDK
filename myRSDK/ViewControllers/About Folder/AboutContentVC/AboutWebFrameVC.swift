//
//  AboutWebFrameVC.swift
//  myRSDK
//
//  Created by Other Logic on 9/13/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit
import WebKit

class AboutWebFrameVC: UIViewController {

    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var linkURL: String = ""
    var mTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        
        let url = URL(string: linkURL)
        let requestObj = URLRequest(url: url! as URL)
        webView.load(requestObj)
    }
    
    public init() {
        super.init(nibName: "AboutWebFrameVC", bundle: Bundle(for: AboutWebFrameVC.self))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUI(){
        titleLabel.text = mTitle
    }

}
