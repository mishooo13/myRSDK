//
//  AlertManager.swift
//  Prego
//
//  Created by owner on 9/4/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit
import PMAlertController

public class AlertManager {
    private static func oneAction(on vc: UIViewController, mTitle: String,
                                  mActionTitle: String,mMessage: String) {
        
        let alertVC = PMAlertController(title: mTitle, description: mMessage, image: UIImage(named: "logo22.png"), style: .alert)
        
        alertVC.addAction(PMAlertAction(title: mActionTitle, style: .cancel, action: { () -> Void in
            print("Capture action Cancel")
        }))
        
        vc.present(alertVC, animated: true, completion: nil)
    }
    
    private static func oneActionWithDismiss(on vc: UIViewController, mTitle: String,
                                             mActionTitle: String,mMessage: String) {
        
        let alertVC = PMAlertController(title: mTitle, description: mMessage, image: UIImage(named: "logo22.png"), style: .alert)
        
        alertVC.addAction(PMAlertAction(title: mActionTitle, style: .cancel, action: { () -> Void in
            vc.dismiss(animated: true, completion: nil)
        }))
        
        vc.present(alertVC, animated: true, completion: nil)
    }
    
    class func oneActionWithResponse(on vc: UIViewController, message: String ,completion: @escaping (_ success: Bool)->Void) {
        
        let alertVC = PMAlertController(title: "warning".getLocalizedValue(), description: message, image: UIImage(named: "logo22.png"), style: .alert)
        
        alertVC.addAction(PMAlertAction(title:  "ok".getLocalizedValue(), style: .cancel, action: { () -> Void in
            completion(true)
        }))
        
        vc.present(alertVC, animated: true, completion: nil)
    }
    
    static func showWrongAlert(on vc: UIViewController){
        oneAction(on: vc, mTitle: "warning".getLocalizedValue() , mActionTitle: "ok".getLocalizedValue(), mMessage: "wrong_message".getLocalizedValue())
    }
    
    static func showWrongAlertWithMessage(on vc: UIViewController, message: String){
        oneAction(on: vc, mTitle: "warning".getLocalizedValue() , mActionTitle: "ok".getLocalizedValue(), mMessage: message)
    }
    
    static func showLoginMobileFailed(on vc: UIViewController){
        oneAction(on: vc, mTitle: "wrong".getLocalizedValue(), mActionTitle: "ok".getLocalizedValue(), mMessage: "wrong_email_or_password".getLocalizedValue())
    }
    
    static func showInvalidPassword(on vc: UIViewController){
        oneAction(on: vc, mTitle: "wrong".getLocalizedValue(), mActionTitle: "submit".getLocalizedValue(), mMessage: "minimum_password_length".getLocalizedValue())
    }
    
    static func showConfirmPassword(on vc: UIViewController){
        oneAction(on: vc, mTitle: "wrong".getLocalizedValue(), mActionTitle: "submit".getLocalizedValue(), mMessage: "confirm_password".getLocalizedValue())
    }
    
    static func showInvalidMobile(on vc: UIViewController){
        oneAction(on: vc, mTitle: "warning".getLocalizedValue(), mActionTitle: "submit".getLocalizedValue(), mMessage: "invalid_mobile".getLocalizedValue())
    }
    
    static func showFillDataWithMessage(on vc: UIViewController, message: String){
        oneAction(on: vc, mTitle: "warning".getLocalizedValue(), mActionTitle: "submit".getLocalizedValue(),
                  mMessage: "\(message) \("empty_data_message".getLocalizedValue())" )
    }
    
    static func showInvalidEmail(on vc: UIViewController){
        oneAction(on: vc, mTitle: "warning".getLocalizedValue(), mActionTitle: "submit".getLocalizedValue(), mMessage: "email_input_matching".getLocalizedValue())
    }
    
    static func showDuplicateEmail(on vc: UIViewController){
        oneAction(on: vc, mTitle: "warning".getLocalizedValue(), mActionTitle: "ok".getLocalizedValue(), mMessage: "dupicate_email".getLocalizedValue())
    }
    
    static func showWrongAlertWithMessageAndAction(on vc: UIViewController, message: String){
        oneActionWithDismiss(on: vc, mTitle: "warning".getLocalizedValue() , mActionTitle: "ok".getLocalizedValue(), mMessage: message)
    }
    
    static func showUpdateMobile(on vc: UIViewController){
        oneAction(on: vc, mTitle: "alert".getLocalizedValue(), mActionTitle: "ok".getLocalizedValue(), mMessage: "update_phone".getLocalizedValue())
    }
    
    static func showNetworkFailed(on vc: UIViewController){
        let alert = UIAlertController(title: "Internet".getLocalizedValue(), message: "internet_failed".getLocalizedValue(), preferredStyle: .alert)
        let mAction = UIAlertAction(title: "ok".getLocalizedValue(), style: .default) { (action) in
            
            vc.dismiss(animated: true, completion: nil)
        }
        alert.addAction(mAction)
        vc.present(alert, animated: true)
    }
    
    static func reoderSuccess(on vc: UIViewController){
        let alertVC = PMAlertController(title: "success".getLocalizedValue(), description: "reorder_success".getLocalizedValue(), image: UIImage(named: "logo22.png"), style: .alert)
        
        alertVC.addAction(PMAlertAction(title: "yes".getLocalizedValue(), style: .default, action: { () -> Void in
            NavigationManager.toCart(vc)
        }))
        
        vc.present(alertVC, animated: true, completion: nil)
    }
    
    static func showDissmissVC(on vc: UIViewController){
        
        let alertVC = PMAlertController(title: "warning".getLocalizedValue(), description: "wrong_message".getLocalizedValue(), image: UIImage(named: "logo22.png"), style: .alert)
        
        alertVC.addAction(PMAlertAction(title: "ok".getLocalizedValue(), style: .cancel, action: { () -> Void in
            vc.dismiss(animated: true, completion: nil)
        }))
        
        vc.present(alertVC, animated: true, completion: nil)
    }
    
}
