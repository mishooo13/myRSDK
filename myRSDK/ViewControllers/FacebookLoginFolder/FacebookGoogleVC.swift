//
//  FacebookGoogleVC.swift
//  Prego
//
//  Created by owner on 9/4/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit
//import FBSDKLoginKit
//import Firebase
//import FirebaseMessaging


internal class FacebookGoogleVC: UIViewController/* ,LoginButtonDelegate, MessagingDelegate*/{

//    let FacebookSignInBtn = FBLoginButton()
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        
//        //Firebase Auth
//        Messaging.messaging().delegate = self
//
//        //Facebook Login
//        FacebookLogin()
//    }
//
//    public init() {
//        super.init(nibName: "FacebookGoogleVC", bundle: Bundle(for: FacebookGoogleVC.self))
    }
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    /// Facebook Login API
//    func FacebookLogin() {
//
//        FacebookSignInBtn.delegate = self
//        FacebookSignInBtn.permissions = ["public_profile","email"]
//    }
//
//    @IBAction func facebookAction(_ sender: Any) {
//
//
//        FacebookSignInBtn.permissions = ["public_profile","email"]
//
//        LoginManager().logIn(permissions: ["public_profile","email"], from: self) { (result, error) in
//            if error != nil {
//                print("Failed")
//                return
//            }
//
//            if (AccessToken.current) != nil{
//                self.fetchUserProfile()
//            }
//        }
//    }
//
//    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
//        if error != nil {
//            print(error ?? "Error")
//            return;
//        }
//        print("Login success")
//        if let _ = AccessToken.current{
//            fetchUserProfile()
//        }
//    }
//
//    @IBAction func googleAction(_ sender: Any) {
//
//    }
//
//
//    func fetchUserProfile(){
//
//        let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields":"id, email, first_name, last_name, picture.type(large)"])
//
//        graphRequest.start { (connection, result, error) in
//            if(error != nil){
//                print("\(String(describing: error?.localizedDescription))")
//                return
//            }
//            let fields = result as? [String:Any]
//            let id = fields!["id"] as? String
//            let email = fields!["email"]
//            let firstName = fields!["first_name"]
//            let lastName = fields!["last_name"]
//            let url = "https://graph.facebook.com/\(id!)/picture?type=large&return_ssl_resources=1"
//            print("login -> \(String(describing: id)) ")
//            print("login -> \(String(describing: email)) ")
//            print("login -> \(String(describing: firstName)) ")
//            print("login -> \(String(describing: lastName)) ")
//            print("login -> \(String(describing: url)) ")
//
//            self.facebookLoginAPI(facebook: id!, email: email as! String, firstName: firstName as! String, lastName: lastName as! String)
//        }
//    }
//
//    func facebookLoginAPI(facebook: String, email: String, firstName: String, lastName: String){
//
//        guard let deviceToken = Utilits.getToken() else {
//            return
//        }
//        showLoadingView(on: self.view)
//        LoginAPI.loginFacebook(firstName: firstName, lastName: lastName, email: email, mobile: "", facebookId: facebook, deviceToken: deviceToken, view: self.view) { (error, success) in
//            self.hideLoadingView()
//            if error != nil || !success {
//                AlertManager.showWrongAlert(on: self)
//                return
//            }
//            if DefaultManager.getAreaDefault() != nil {
//                NavigationManager.toHome(self)
//            }else{
//                NavigationManager.toDetectLocation(self)
//            }
//        }
//    }
//
//    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
//        print("Log out")
//    }

}
