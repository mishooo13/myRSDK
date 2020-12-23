//
//  PhoneAuthVC.swift
//  Prego
//
//  Created by owner on 10/3/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit
//import FirebaseAuth

protocol PhoneAuthDelegate {
    func phoneAuthenticated(success: Bool) -> Void
}

class PhoneAuthVC: UIViewController {
    
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var sendAgainBtn: UIButton!
    @IBOutlet weak var timerView: UIView!
    
    var delegate: PhoneAuthDelegate?
    
    var verificationID: String = ""
    var phone: String = ""
    var isSignUp: Bool = false
    var toHome: Bool = false
    
    var countdownTimer: Timer!
    var totalTime = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        loadCode()
        startTimer()
    }
    
    func setUI(){
        self.hideKeyboardWhenTappedAround()
    }
    
    func loadCode(){
        if let code = UserDefaults.standard.string(forKey: "authVerificationID") {
            verificationID = code
        }
    }
    
    @IBAction func btnAction(_ sender: Any) {
        
        if verificationID.isEmpty {
            return
        }
        
        guard let code = codeField.text else {
            return
        }
        
        if code.isEmpty {
            showToast(message: "Please enter code", controller: self)
            return
        }
        
//        let credential = PhoneAuthProvider.provider().credential(
//            withVerificationID: verificationID,
//            verificationCode: code)
//
//        
//        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
//            if let error = error {
//                AlertManager.showFillDataWithMessage(on: self, message: error.localizedDescription)
//                return
//            }
//            if self.toHome {
//                self.updatePhone()
//            }else{
//                if self.isSignUp {
//                    self.delegate?.phoneAuthenticated(success: true)
//                    self.dismiss(animated: true, completion: nil)
//                }else{
//                    self.delegate?.phoneAuthenticated(success: true)
//                    self.dismiss(animated: true, completion: nil)
//                }
//            }
//            print("verfication is correct \(String(describing: authResult?.user.phoneNumber))")
//        }
    }
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        timerLabel.text = "\(timeFormatted(totalTime))"
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
        
        timerView.isHidden = true
        sendAgainBtn.isHidden = false
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    @IBAction func sendAgainAction(_ sender: Any) {
        
        if phone.isEmpty{
            return
        }
        if toHome {
            phone = "+2\(phone)"
        }
        PhoneAuthManager.PhoneProvider(phoneNumber: phone) { (error, success) in
            if error != nil {
                print("error")
                return
            }
            if success {
                self.timerView.isHidden = false
                self.sendAgainBtn.isHidden = true
                
                self.totalTime = 60
                self.startTimer()
            }
        }
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func updatePhone(){
        guard let token = DefaultManager.getUserToken() else {
            return
        }
        /*UserProfileAPI.updateMobile(token: token, mobile: phone, view: self.view) { (error, success) in
            self.hideLoadindView()
            if error != nil {
                Alert.showWrongAlert(on: self)
                return
            }
            
            if !success {
                Alert.showDuplicateMobilev2(on: self)
                return
            }
            NavigationManager.toHome(self)
        }*/
    }
}
