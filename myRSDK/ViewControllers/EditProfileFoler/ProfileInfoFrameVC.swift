//
//  ProfileInfoFrameVC.swift
//  myRSDK
//
//  Created by Other Logic on 9/13/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit

protocol PasswordDelegate {
    func passwordAction() -> Void
}

class ProfileInfoFrameVC: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var dateOfBirthField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var mobileField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var delegate: PasswordDelegate?
    
    let datePicker = UIDatePicker()
    let genderPicker = UIPickerView()
    
    let genderList: [String] = ["male".getLocalizedValue(),
                                "female".getLocalizedValue()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        loadData()
        
        showDatePicker()
    }
    
    public init() {
        super.init(nibName: "ProfileInfoFrameVC", bundle: Bundle(for: ProfileInfoFrameVC.self))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData(){
        guard let userModel = DefaultManager.getUserDefault() else{
            return
        }
        guard let data = userModel.data else{
            return
        }
        
        guard let user = data.user else{
            return
        }
        
        if let name = user.userName {
            nameField.text = name
        }
        
        if let email = user.email {
            emailField.text = email
        }
        
        if let mobile = user.phone {
            mobileField.text = mobile
        }
    }
    
    func setUI(){
        hideKeyboardWhenTappedAround()
        Utilits.textFieldStyle(textField: nameField)
        Utilits.textFieldStyle(textField: emailField)
        Utilits.textFieldStyle(textField: dateOfBirthField)
        Utilits.textFieldStyle(textField: genderField)
        Utilits.textFieldStyle(textField: mobileField)
        Utilits.textFieldStyle(textField: passwordField)
    }
    
    
    @IBAction func updateAction(_ sender: Any) {
        
        guard let token = DefaultManager.getUserToken() else {
            return
        }
        
        var choosedGender: String = ""
        var choosedBirthDate: String = ""
        
        guard let name = nameField.text else {
            return
        }
        guard let email = emailField.text else {
            return
        }
        
        guard let mobile = mobileField.text else {
            return
        }
        
        if !RegularExpression.isValidEmpty(text: name){
            AlertManager.showFillDataWithMessage(on: self, message: "name".getLocalizedValue())
            return
        }
        
        if !RegularExpression.isValidEmail(email: email){
            AlertManager.showInvalidEmail(on: self)
            return
        }
        
        if !RegularExpression.isValidPhone(phone: mobile){
            AlertManager.showInvalidMobile(on: self)
            return
        }
        
        if let gender = genderField.text {
            choosedGender = gender
        }
        if let DOB = dateOfBirthField.text {
            choosedBirthDate = DOB
        }
        showLoadingView(on: self.view)
        ProfileAPI.updateProfile(token: token, name: name, email: email, phone: mobile, gender: choosedGender, birthDate: choosedBirthDate, view: self.view) { (error, success) in
            self.hideLoadingView()
            if error != nil || !success {
                AlertManager.showWrongAlert(on: self)
                return
            }
            
            self.showToast(message: "update_success".getLocalizedValue(), controller: self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.dismiss(animated: true, completion: nil)
            })
            
            /*guard let data = model?.data else {
             return
             }
             guard let token = data.apiToken else {
             return
             }
             DefaultManager.saveTokenDefault(token: token)
             self.showToast(message: "update_success", controller: self)
             DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
             self.dismiss(animated: true, completion: nil)
             })*/
        }
    }
    
    
    
    @IBAction func passwordAction(_ sender: Any) {
        delegate?.passwordAction()
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "done".getLocalizedValue(), style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "cancel".getLocalizedValue(), style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        dateOfBirthField.inputAccessoryView = toolbar
        dateOfBirthField.inputView = datePicker
        
        
        //Gender ToolBar
        let genderToolbar = UIToolbar();
        genderToolbar.sizeToFit()
        let genderDoneButton = UIBarButtonItem(title: "done".getLocalizedValue(), style: .plain, target: self, action: #selector(genderDonePicker));
        
        genderToolbar.setItems([genderDoneButton], animated: false)
        
        genderPicker.delegate = self
        genderField.inputAccessoryView = genderToolbar
        genderField.inputView = genderPicker
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dateOfBirthField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    @objc func genderDonePicker(){
        self.view.endEditing(true)
    }

}


extension ProfileInfoFrameVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderList.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderField.text = genderList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as! UILabel?
        if label == nil {
            label = UILabel()
        }
        
        label?.tag = 1
        label?.text = genderList[row]
        label?.textAlignment = .center
        return label!
    }
    
    
    @IBAction func arabicAction(_ sender: Any) {
        Utilits.arabicActin(self)
    }
    
    @IBAction func englishAction(_ sender: Any) {
        Utilits.englishAction(self)
    }
}



