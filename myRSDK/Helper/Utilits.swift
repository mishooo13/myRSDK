//
//  Utilits.swift
//  Prego
//
//  Created by owner on 8/20/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit
import DropDown
//import Firebase


public class Utilits {
    
    public static func getToken() -> String? {
//        guard let token = Messaging.messaging().fcmToken else {
//            return nil
//        }
//        print("device key \(token)")
//        return token
        
        return ""
    }
    
    static func textFieldStyle(textField: UITextField, imageName: String){
        textField.layer.cornerRadius = 6
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        
        if DefaultManager.getLanguageDefault() == Config.English {
            textField.setLeftPaddingPoints(10)
            
            if !imageName.isEmpty {
                if let mImage = UIImage(named: imageName, in: frameworkBundle, compatibleWith: .none) {
                    textField.setIcon(mImage)
                }
            }
        }else{
            textField.setLeftPaddingPoints(10)
            textField.setRightPaddingPoints(10)
        }
        
        
    }
    
    static func textFieldStyle(textField: UITextField, imageName: String, borderColor: UIColor){
        textField.layer.cornerRadius = 6
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        if DefaultManager.getLanguageDefault() == Config.English {
            textField.setLeftPaddingPoints(10)
            if !imageName.isEmpty {
                if let mImage = UIImage(named: imageName, in: frameworkBundle, compatibleWith: .none) {
                    textField.setIcon(mImage)
                }
            }
        }else{
            textField.setLeftPaddingPoints(10)
            textField.setRightPaddingPoints(10)
        }
    }
    
    static func textFieldStyle(textField: UITextField){
        textField.layer.cornerRadius = 6
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        
        if DefaultManager.getLanguageDefault() == Config.English {
            textField.setLeftPaddingPoints(10)
        }else{
            textField.setLeftPaddingPoints(10)
            textField.setRightPaddingPoints(10)
        }
    }
    
    static func cornerLeftRight(view: UIView){
        if #available(iOS 11.0, *){
            view.layer.masksToBounds = true
            view.clipsToBounds = true
            view.layer.cornerRadius = 8
            view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }
    
    static func cornerLeftRightBtn(button: UIButton){
        if #available(iOS 11.0, *){
            button.layer.masksToBounds = true
            button.clipsToBounds = true
            button.layer.cornerRadius = 8
            button.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }
    
    static func currentDateTime() -> String{
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        let interval = date.timeIntervalSince1970
        return "\(dateString) \(interval)"
    }
    
    static func getBagVC(_ vc: UIViewController) -> BagFrameVC {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let VC = storyBoard.instantiateViewController(withIdentifier: "BagVC") as! BagFrameVC
        vc.addChild(VC)
        return VC
    }
    
    static func englishAction(_ vc: UIViewController) {
        let mLang = DefaultManager.getLanguageDefault()
        if mLang != Config.English {
            //Locaizable
            
            
            DefaultManager.saveLanguageDefault(language: Config.English)
            
            L102Language.setAppleLAnguageTo(lang: Config.English)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            
            let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
            rootviewcontroller.rootViewController = vc.storyboard?.instantiateViewController(withIdentifier: "SplashVC")
            let mainwindow = (UIApplication.shared.delegate?.window!)!
            mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
            UIView.transition(with: mainwindow, duration: 0.4, animations: {}) { (finished) in
                //L102Localizer.DoTheMagic()
            }
            
            
        }
    }
    
    static func arabicActin(_ vc: UIViewController) {
        let mLang = DefaultManager.getLanguageDefault()
        if mLang != Config.Arablic {
            //Locaizable
            
            DefaultManager.saveLanguageDefault(language: Config.Arablic)
            
            L102Language.setAppleLAnguageTo(lang: Config.Arablic)
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            
            let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
            rootviewcontroller.rootViewController = vc.storyboard?.instantiateViewController(withIdentifier: "SplashVC")
            let mainwindow = (UIApplication.shared.delegate?.window!)!
            mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
            UIView.transition(with: mainwindow, duration: 0.4, animations: {}) { (finished) in
                //L102Localizer.DoTheMagic()
            }
            
            
        }
    }
    
    static func splitPrice(price: Double) -> String{
        /*let priceAsString: String = "\(price)"
         if priceAsString.isEmpty {
         return ""
         }
         let priceAsArr: [String] = priceAsString.components(separatedBy: ".")
         if priceAsArr.count == 1 {
         return "\(priceAsArr[0]).00"
         }else if priceAsArr.count == 2 {
         if priceAsArr[1].count == 1 {
         return "\(priceAsArr[0]).\(priceAsArr[1])0"
         }else{
         return "\(priceAsArr[0]).\(priceAsArr[1])"
         }
         }else {
         return priceAsString
         }*/
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        if let formattedTipAmount = formatter.string(from: price as NSNumber) {
            return formattedTipAmount
        }else{
            return ""
        }
    }
    
    static func getCurrentDate() -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        return result
    }
    
    static func getCurrentTime() -> String{
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let result = "\(hour):\(minutes)"
        
        return result
    }
    
    
    
    public static func configureDropDown(dropDown: DropDown, dropDownWidth: CGFloat){
        DropDown.appearance().textColor = UIColor.black
        if DefaultManager.getLanguageDefault() == Config.English {
            DropDown.appearance().textFont = AppFontManager.font(size: 16, weight: .medium)
        }else{
            DropDown.appearance().textFont = AppFontManager.fontType(type: .droidKufi, size: 16, weight: .bold)
        }
        
        DropDown.appearance().backgroundColor = AppColorsManager.grayColor
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        DropDown.appearance().cornerRadius = 10
        DropDown.appearance().cellHeight = 50
        
        dropDown.width = dropDownWidth
        dropDown.direction = .any
        dropDown.dismissMode = .onTap
    }
    
    public static func renderImage(renderedImage: UIImageView, renderedColor: UIColor){
        renderedImage.image = renderedImage.image?.withRenderingMode(.alwaysTemplate)
        renderedImage.tintColor = renderedColor
    }
    
    public static func share(vc: UIViewController){
        let text = "This is the text...."
        let image = UIImage(named: "first.jpg")
        let myWebsite = NSURL(string:"https://stackoverflow.com")
        let shareAll = [text , image! , myWebsite!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = vc.view
        vc.present(activityViewController, animated: true, completion: nil)
    }
    
    public static func logout(vc: UIViewController){
        
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        
        NavigationManager.toSplash(vc)
    }
    
    public static func isOpened(){
        
        guard let data = DefaultManager.getAreaDefault() else {
            return
        }
        
        guard let branches = data.branches else {
            return
        }
        
        if branches.isEmpty {
            return
        }
        
        guard let openTime = branches[0].branchOpen else {
            return
        }
        
        guard let closeTime = branches[0].branchClose else {
            return
        }
        
        //let currentTime: String = "\(getCurrentTime()):00"
        let currentTime: String = "\(getCurrentTime()):00"
        
        if openTime.isEmpty || closeTime.isEmpty || currentTime.isEmpty{
            return
        }
        
        let openTimesArr = splitString(mTime: openTime)
        let closeTimesArr = splitString(mTime: closeTime)
        let currentTimesArr = splitString(mTime: currentTime)
        
        if openTimesArr.count < 2 || closeTimesArr.count < 2 || currentTimesArr.count < 2 {
            return
        }
        
        let startHourTime = openTimesArr[0].removeStartZero(openTimesArr[0])
        let closeHourTime = closeTimesArr[0].removeStartZero(closeTimesArr[0])
        let currentHourTime = currentTimesArr[0].removeStartZero(currentTimesArr[0])
        
        //let startMinTime = openTimesArr[1]
        //let closeMinTime = closeTimesArr[1]
        //let currentMinTime = currentTimesArr[1]
        
        
        
        //First case if current time > open time && < close time
        if currentHourTime > startHourTime && currentHourTime < closeHourTime {
            print("timmmes open  \(openTime)   \(closeTime)  \(currentTime)")
        }else{
            print("timmmes a7aa  \(openTime)   \(closeTime)  \(currentTime)")
        }
        
        //print("timmmes \(openTime)  \(closeTime)  \(getCurrentTime())")
    }
    
    static func splitString(mTime: String) -> [String]{
        return mTime.components(separatedBy: ":")
    }
    
    static func splitStringWithComma(value: String) -> [String]{
        return value.components(separatedBy: ",")
    }
    
    static func CARDIPAD(_ constraint: NSLayoutConstraint, constant: CGFloat){
        switch UIDevice.current.userInterfaceIdiom {
        case .phone, .carPlay, .tv, .unspecified:
            break
        case .pad:
            constraint.constant = constant
            break
        @unknown default:
            break
        }
    }
    
    
    public static func checkIsOpen() -> Bool{
        /*guard let area = DefaultManager.getAreaDefault() else {
            return false
        }
        
        guard let status = area.status else {
            return false
        }
        
        if status == Config.branchOpen {
            return true
        }else{
            return false
        }*/
        
        guard let chain = DefaultManager.getReasrturantDefault() else {
            return false
        }
        guard let status = chain.branchStatus else {
            return false
        }
        if status == "closed" {
            return false
        }else{
            return true
        }
        
    }
    
    public static func getSelectedAreaID() -> String? {
        guard let selectedArea = DefaultManager.getAreaDefault() else{
            return nil
        }
        guard let areaID = selectedArea.id else {
            return nil
        }
        return "\(areaID)"
    }
    
    public static func getSelectedReasturantID() -> String? {
        guard let selectedRes = DefaultManager.getReasrturantDefault() else{
            return nil
        }
        guard let ResID = selectedRes.id else {
            return nil
        }
        return "\(ResID)"
    }
    
    public static func getDeliveryFees() -> String? {
        guard let chain = DefaultManager.getReasrturantDefault() else {
            return nil
        }
        guard let fees = chain.deliveryFees else{
            return nil
        }
        return fees
    }
    
    static func getPriceFromInfo(info: [Info]) -> Double?{
        if info.isEmpty {
            return nil
        }
        guard let priceObject = info[0].price else {
            return nil
        }
        guard let price = priceObject.price else {
            return nil
        }
        return price
    }
    
    static func getPriceFromInfo(info: [ItemInfo]) -> Double?{
        if info.isEmpty {
            return nil
        }
        guard let priceObject = info[0].price else {
            return nil
        }
        guard let price = priceObject.price else {
            return nil
        }
        return price
    }
    
    static func getPriceFromInfo(info: Info) -> Double?{
        
        guard let priceObject = info.price else {
            return nil
        }
        guard let price = priceObject.price else {
            return nil
        }
        return price
    }
    
    static func getPriceFromInfo(info: [ItemInfo], size: Int) -> Double?{
        if info.isEmpty {
            return nil
        }
        guard let priceObject = info[size].price else {
            return nil
        }
        guard let price = priceObject.price else {
            return nil
        }
        return price
    }
}


extension String {
    
    func removeStartZero(_ value: String) -> String {
        let newVal = value
        if newVal.hasPrefix("0") {
            
            return String(newVal.dropFirst())
        }
        return newVal
    }
}
