//
//  LoginFrameVC.swift
//  myRSDK
//
//  Created by Other Logic on 9/8/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit
//import FBSDKLoginKit
//import Firebase
//import FirebaseMessaging
//import AuthenticationServices

class LoginFrameVC: UIViewController {
//    @IBOutlet weak var emailField: UITextField!
//    @IBOutlet weak var passwordField: UITextField!
//    @IBOutlet weak var appleView: UIView!
//    @IBOutlet weak var facebookContainerView: UIView!
//
//    let FacebookSignInBtn = FBLoginButton()
//
//
    var isDismiss: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setUI()
//        addFacebookContainer()
//
//        if #available(iOS 13.0, *) {
//            signInWithApple()
//        }
    }
    
//    public init() {
//        super.init(nibName: "LoginFrameVC", bundle: Bundle(for: LoginFrameVC.self))
//    }
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func setUI(){
//        hideKeyboardWhenTappedAround()
//        Utilits.textFieldStyle(textField: emailField, imageName: "email")
//        Utilits.textFieldStyle(textField: passwordField, imageName: "password")
//    }
//
//    func addFacebookContainer(){
//        // add container
//
//        let containerView = UIView()
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        facebookContainerView.addSubview(containerView)
//        NSLayoutConstraint.activate([
//            containerView.leadingAnchor.constraint(equalTo: facebookContainerView.leadingAnchor, constant: 0),
//            containerView.trailingAnchor.constraint(equalTo: facebookContainerView.trailingAnchor, constant: 0),
//            containerView.topAnchor.constraint(equalTo: facebookContainerView.topAnchor, constant: 0),
//            containerView.bottomAnchor.constraint(equalTo: facebookContainerView.bottomAnchor, constant: 0),
//        ])
//
//        // add child view controller view to container
//
//        let controller = FacebookGoogleVC()
//        addChild(controller)
//        controller.view.translatesAutoresizingMaskIntoConstraints = false
//        containerView.addSubview(controller.view)
//
//        NSLayoutConstraint.activate([
//            controller.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
//            controller.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
//            controller.view.topAnchor.constraint(equalTo: containerView.topAnchor),
//            controller.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
//        ])
//
//        controller.didMove(toParent: self)
//    }
//
//    @IBAction func skippAction(_ sender: Any) {
//        if isDismiss {
//            dismiss(animated: true, completion: nil)
//        }else{
//            DefaultManager.saveSkipDefault(value: "Skipped")
//            if DefaultManager.getAreaDefault() == nil {
//                NavigationManager.toDetectLocation(self)
//            }else{
//                NavigationManager.toHome(self)
//            }
//        }
//    }
//
//    @IBAction func createAccountAction(_ sender: Any) {
//        NavigationManager.toSignUp(self)
//    }
//
//    @IBAction func loginAction(_ sender: Any) {
//
//        if !Connectivity.isConnectedToInternet {
//            AlertManager.showWrongAlertWithMessage(on: self, message: "internet_failed".getLocalizedValue())
//            return
//        }
//
////        guard let deviceToken = Utilits.getToken() else {
////            return
////        }
//
//        guard let email = emailField.text else {
//            return
//        }
//
//        guard let password = passwordField.text else {
//            return
//        }
//
//        if email.isEmpty {
//            return
//        }
//
//        if password.isEmpty {
//            return
//        }
//        showLoadingView(on: self.view)
//        LoginAPI.loginWithEmail(email: email, password: password, deviceToken: "deviceToken", view: self.view) { (error, success) in
//            self.hideLoadingView()
//            if error != nil || !success {
//                AlertManager.showLoginMobileFailed(on: self)
//                return
//            }
//
////            if self.isDismiss {
////                self.dismiss(animated: true, completion: nil)
////            }else{
////                if DefaultManager.getAreaDefault() == nil {
////                    NavigationManager.toDetectLocation(self)
////                }else{
////                    DefaultManager.saveSkipDefault(value: "Skipped")
////                    NavigationManager.toHome(self)
////                }
////            }
//        }
//    }
//
//    @available(iOS 13.0, *)
//    func signInWithApple(){
//        let appleBtn = ASAuthorizationAppleIDButton()
//        appleBtn.translatesAutoresizingMaskIntoConstraints = false
//        appleBtn.addTarget(self, action: #selector(didTapAppleBtn), for: .touchUpInside)
//        self.appleView.addSubview(appleBtn)
//        appleBtn.cornerRadius = 6
//
//        NSLayoutConstraint.activate([
//
//            appleBtn.heightAnchor.constraint(equalToConstant: self.appleView.frame.height),
//            appleBtn.centerYAnchor.constraint(equalTo: self.appleView.centerYAnchor),
//            appleBtn.leadingAnchor.constraint(equalTo: self.appleView.leadingAnchor, constant: 0),
//            appleBtn.trailingAnchor.constraint(equalTo: self.appleView.trailingAnchor, constant: 0)
//        ])
//    }
//
//    @available(iOS 13.0, *)
//    @objc
//    func didTapAppleBtn(){
//
//        let provider = ASAuthorizationAppleIDProvider()
//        let request = provider.createRequest()
//        request.requestedScopes = [.fullName ,.email]
//
//        let controller = ASAuthorizationController(authorizationRequests: [request])
//        controller.delegate = self // ASAuthorizationControllerDelegate
//        controller.presentationContextProvider = self // ASAuthorizationControllerPresentationContextProviding
//        controller.performRequests()
//
//    }
}
//
//
//
//extension LoginFrameVC: ASAuthorizationControllerDelegate {
//
//    @available(iOS 13.0, *)
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
//            return
//        }
//
//        if let firstName = appleIDCredential.fullName?.givenName, let lastName = appleIDCredential.fullName?.familyName ,let email = appleIDCredential.email {
//
//            appleLoginAPI(appleID: appleIDCredential.user, email: email, firstName: firstName, lastName: lastName)
//
//            print("AppleID Credential Authorization: userId: \(appleIDCredential.user), email: \(firstName)  \(lastName)  \(email)")
//        }else{
//            appleLoginAPI(appleID: appleIDCredential.user)
//        }
//    }
//
//    @available(iOS 13.0, *)
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        print("AppleID Credential failed with error: \(error.localizedDescription)")
//    }
//
//    func appleLoginAPI(appleID: String, email: String, firstName: String, lastName: String){
//
//        guard let deviceToken = Utilits.getToken() else {
//            return
//        }
//        showLoadingView(on: self.view)
//        LoginAPI.loginApple(firstName: firstName, lastName: lastName, email: email, mobile: "", appleId: appleID, deviceToken: deviceToken, view: self.view) { (error, success) in
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
//    func appleLoginAPI(appleID: String){
//
//        guard let deviceToken = Utilits.getToken() else {
//            return
//        }
//        showLoadingView(on: self.view)
//        LoginAPI.loginApple(appleId: appleID, deviceToken: deviceToken, view: self.view) { (error, success) in
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
//}
//
//
//extension LoginFrameVC: ASAuthorizationControllerPresentationContextProviding {
//    @available(iOS 13.0, *)
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return self.view.window!
//    }
//}
