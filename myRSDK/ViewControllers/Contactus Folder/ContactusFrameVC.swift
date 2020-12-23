//
//  ContactusFrameVC.swift
//  myRSDK
//
//  Created by Other Logic on 9/13/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit

class ContactusFrameVC: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var mobileField: UITextField!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var mView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    public init() {
        super.init(nibName: "ContactusFrameVC", bundle: Bundle(for: ContactusFrameVC.self))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func callAction(_ sender: Any) {
        guard let number = URL(string: "tel://" + "19982") else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    
    func setUI(){
        hideKeyboardWhenTappedAround()
        Utilits.cornerLeftRight(view: mView)
        Utilits.textFieldStyle(textField: nameField, imageName: "user")
        Utilits.textFieldStyle(textField: emailField, imageName: "email")
        Utilits.textFieldStyle(textField: mobileField, imageName: "mobile")
        Utilits.textFieldStyle(textField: messageField)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        guard let name = nameField.text else {
            return
        }
        guard let email = emailField.text else {
            return
        }
        guard let phone = mobileField.text else {
            return
        }
        guard let message = messageField.text else {
            return
        }
        
        if name.isEmpty || email.isEmpty || phone.isEmpty || message.isEmpty {
            AlertManager.showWrongAlertWithMessage(on: self, message: "fields_required".getLocalizedValue())
            return
        }
        
        showLoadingView(on: self.view)
        ProfileAPI.contactUS(name: name, email: email, phone: phone, message: message) { (error, success) in
            self.hideLoadingView()
            if error != nil || !success {
                AlertManager.showWrongAlert(on: self)
                return
            }
            self.showToast(message: "rate_success".getLocalizedValue(), controller: self)
            self.dismiss(animated: true, completion: nil)
        }
    }

}
