//
//  Extensions+Controller.swift
//  Prego
//
//  Created by owner on 8/20/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit
import JGProgressHUD

let hud = JGProgressHUD(style: .dark)

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension UIViewController {
    func addContainer(view: UIView, containerController: UIViewController){
        // add container

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])

        // add child view controller view to container

        let controller = containerController
        
        addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(controller.view)

        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            controller.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        controller.didMove(toParent: self)
    }
}



extension UIViewController {
    
    func setupBagView(bagView: UIView){
//        let bagVC = Utilits.getBagVC(self)
//        bagVC.isFromHome = true
//        bagView.addSubview(bagVC.view)
//        bagVC.view.frame = bagView.bounds
//        bagVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        bagVC.didMove(toParent: self)
        
        addContainer(view: bagView, containerController: BagFrameVC())
    }
    
    func setupHomeBagView(bagView: UIView){
//        let bagVC = Utilits.getBagVC(self)
//        bagVC.isFromHome = true
//        bagView.addSubview(bagVC.view)
//        bagVC.view.frame = bagView.bounds
//        bagVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        bagVC.didMove(toParent: self)
        
        addContainer(view: bagView, containerController: BagFrameVC())
    }
}

extension UIViewController {
    func hideStatusBarLine(){
        self.navigationController?.navigationBar.shouldRemoveShadow(true)
    }
    
    func needLogin() -> Bool {
        guard DefaultManager.getUserToken() != nil else {
            return true
        }
        return false
    }
}

extension UIViewController {
    
    func showToast(message: String, controller: UIViewController) {
        
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 20;
        toastContainer.clipsToBounds  =  true
        
        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font.withSize(10.0)
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0
        toastLabel.tag = 1
        
        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)
        
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
        toastContainer.addConstraints([a1, a2, a3, a4])
        
        let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1, constant: 65)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -65)
        let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: controller.view, attribute: .bottom, multiplier: 1, constant: -75)
        controller.view.addConstraints([c1, c2, c3])
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
    
}


extension UIViewController {
    func loopThroughSubViewAndFlipTheImageIfItsAUIButton(subviews: [UIView]) {
        if subviews.count > 0 {
            for subView in subviews {
                if (subView is UIButton) && subView.tag < 0 {
                    print("button rotate")
                    let btn = subView as! UIButton
                    btn.transform = btn.transform.rotated(by: CGFloat(Double.pi * 2))
                }
                loopThroughSubViewAndFlipTheImageIfItsAUIImageView(subviews: subView.subviews)
            }
        }
    }
    
    func loopThroughSubViewAndFlipTheImageIfItsAUIImageView(subviews: [UIView]) {
        if subviews.count > 0 {
            for subView in subviews {
                if (subView is UIImageView) && subView.tag < 0 {
                    let toRightArrow = subView as! UIImageView
                    if let _img = toRightArrow.image {
                        toRightArrow.image = UIImage(cgImage: _img.cgImage!, scale:_img.scale , orientation: UIImage.Orientation.upMirrored)
                        //toRightArrow.tintColor = UIColor.darkGray
                    }
                }
                loopThroughSubViewAndFlipTheImageIfItsAUIImageView(subviews: subView.subviews)
            }
        }
    }
}



extension UIViewController {
    
    func APPLanguage() -> String {
        var lang: String = Config.English
        if let language = getLanguage(){
            if language.isEmpty{
                lang = Config.English
            }else{
                lang = language
            }
        }else{
            let deviceLang = Locale.current.languageCode
            if (deviceLang?.isEmpty)! || deviceLang == nil {
                lang = Config.English
            }else{
                lang = deviceLang!
            }
        }
        return lang
    }
    
    func getLanguage() -> String? {
        var language: String? = nil
        if let lang = UserDefaults.standard.string(forKey: Config.languageDefault) {
            language = lang
        }
        return language
    }
}

extension UICollectionViewCell {
    
    func APPLanguage() -> String {
        var lang: String = Config.English
        if let language = getLanguage(){
            if language.isEmpty{
                lang = Config.English
            }else{
                lang = language
            }
        }else{
            let deviceLang = Locale.current.languageCode
            if (deviceLang?.isEmpty)! || deviceLang == nil {
                lang = Config.English
            }else{
                lang = deviceLang!
            }
        }
        return lang
    }
    
    func getLanguage() -> String? {
        var language: String? = nil
        if let lang = UserDefaults.standard.string(forKey: Config.languageDefault) {
            language = lang
        }
        return language
    }
}

extension UITableViewCell {
    
    func APPLanguage() -> String {
        var lang: String = Config.English
        if let language = getLanguage(){
            if language.isEmpty{
                lang = Config.English
            }else{
                lang = language
            }
        }else{
            let deviceLang = Locale.current.languageCode
            if (deviceLang?.isEmpty)! || deviceLang == nil {
                lang = Config.English
            }else{
                lang = deviceLang!
            }
        }
        return lang
    }
    
    func getLanguage() -> String? {
        var language: String? = nil
        if let lang = UserDefaults.standard.string(forKey: Config.languageDefault) {
            language = lang
        }
        return language
    }
}

extension UIViewController {
    func showLoadingView(on view: UIView){
        hud.textLabel.text = "loading".getLocalizedValue()
        hud.show(in: view)
    }
    
    func hideLoadingView(){
        hud.dismiss(animated: true)
    }
    
    func showEmptyView(on view: UIView, title: String, mImage: UIImage){
        /*let requiredView:EmptyView = Bundle.main.loadNibNamed("EmptyView", owner: frameworkBundle, options: nil)?.first as! EmptyView
        requiredView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        requiredView.tag =  Config.EMPTY_TAG
        requiredView.mImage.image = mImage
        requiredView.mTitle.text = title
        
        requiredView.mImage.image = requiredView.mImage.image?.withRenderingMode(.alwaysTemplate)
        requiredView.mImage.tintColor = AppColorsManager.greenColor
        view.addSubview(requiredView)*/


        let bundle = frameworkBundle
        let requiredView = bundle?.loadNibNamed("EmptyView", owner: nil, options: nil)?.first as! EmptyView
        
        requiredView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        requiredView.tag =  Config.EMPTY_TAG
        requiredView.emptyImage.image = mImage
        requiredView.emptyLabel.text = title
        
        requiredView.emptyImage.image = requiredView.emptyImage.image?.withRenderingMode(.alwaysTemplate)
        requiredView.emptyImage.tintColor = AppColorsManager.greenColor
        
        view.addSubview(requiredView)
        
    }
    
    func hideEmptyDataView(view: UIView){
        if let viewWithTag = view.viewWithTag(Config.EMPTY_TAG) {
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                UIView.animate(withDuration: 0.5, animations: {
                    
                    viewWithTag.alpha = 0
                }, completion: { (success) in
                    viewWithTag.removeFromSuperview()
                })
            })
        }
    }
    
    func showInternetFailed(view: UIView){
        
        if let image = UIImage(named: "failed-internet.png", in: frameworkBundle, with: .none){
            showEmptyView(on: view, title: "internet_failed".getLocalizedValue(), mImage: image)
        }
    }
}

class EmptyViewVC: UIViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "EmptyView", bundle: frameworkBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIViewController {
    
    func startAvoidingKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameWillChangeNotification(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameWillChangeNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameWillChangeNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func stopAvoidingKeyboard() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardFrameWillChangeNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let keyboardFrameInView = view.convert(keyboardFrame, from: nil)
        let safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame.insetBy(dx: 0, dy: -additionalSafeAreaInsets.bottom)
        let intersection = safeAreaFrame.intersection(keyboardFrameInView)
        
        let animationDuration: TimeInterval = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.3
        let animationCurveRawNSN = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: animationCurve, animations: {
            self.additionalSafeAreaInsets.bottom = intersection.height
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
