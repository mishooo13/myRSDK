//
//  ProfileFrameVC.swift
//  myRSDK
//
//  Created by Other Logic on 9/13/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit

enum ProfileContainer: Int {
    case editProfile = 1
    case orders = 2
    case ponits = 3
    case address = 4
}

class ProfileFrameVC: UIViewController {
    
    @IBOutlet weak var editProfileLabel: UILabel!
    @IBOutlet weak var ordersLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var editProfileView: UIView!
    @IBOutlet weak var ordersView: UIView!
    @IBOutlet weak var pointsView: UIView!
    @IBOutlet weak var addressView: UIView!
    
    @IBOutlet weak var mContainerView: UIView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var countPointsLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userBackgroundImage: UIImageView!
    @IBOutlet weak var userImageView: UIView!
    
    var seletedBackgroundColor: UIColor = AppColorsManager.greenColor!
    var unSeletedBackgroundColor: UIColor = UIColor.lightGray
    
    var seletedLabelColor: UIColor = UIColor.white
    var unSeletedLabelColor: UIColor = UIColor.black
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addContainer(view: mContainerView, containerController: ProfileInfoFrameVC())
        
        fillUI()
    }
    
    public init() {
        super.init(nibName: "ProfileFrameVC", bundle: Bundle(for: ProfileFrameVC.self))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func fillUI(){
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = userBackgroundImage.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        userBackgroundImage.addSubview(blurEffectView)
        
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
            //userNameLabel.text = name
        }
    }
    
    @IBAction func editProfileAction(_ sender: Any) {
        editProfileSelected()
    }
    @IBAction func ordersAction(_ sender: Any) {
        ordersSelected()
    }
    @IBAction func pointsAction(_ sender: Any) {
        pointsSelected()
    }
    @IBAction func addressAction(_ sender: Any) {
        addressSelected()
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        Utilits.logout(vc: self)
    }
    
    func editProfileSelected(){
        
        self.changeContainer(index: ProfileContainer.editProfile.rawValue)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
            self.editProfileView.backgroundColor = self.seletedBackgroundColor
            self.ordersView.backgroundColor = self.unSeletedBackgroundColor
            self.pointsView.backgroundColor = self.unSeletedBackgroundColor
            self.addressView.backgroundColor = self.unSeletedBackgroundColor
            
            self.editProfileLabel.textColor = self.seletedLabelColor
            self.ordersLabel.textColor = self.unSeletedLabelColor
            self.pointsLabel.textColor = self.unSeletedLabelColor
            self.addressLabel.textColor = self.unSeletedLabelColor
            
            self.view.layoutIfNeeded()
        }) { (success) in }
    }
    
    func ordersSelected(){
        
        self.changeContainer(index: ProfileContainer.orders.rawValue)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
            self.editProfileView.backgroundColor = self.unSeletedBackgroundColor
            self.ordersView.backgroundColor = self.seletedBackgroundColor
            self.pointsView.backgroundColor = self.unSeletedBackgroundColor
            self.addressView.backgroundColor = self.unSeletedBackgroundColor
            
            self.editProfileLabel.textColor = self.unSeletedLabelColor
            self.ordersLabel.textColor = self.seletedLabelColor
            self.pointsLabel.textColor = self.unSeletedLabelColor
            self.addressLabel.textColor = self.unSeletedLabelColor
            
            
            self.view.layoutIfNeeded()
        }) { (success) in  }
    }
    
    func pointsSelected(){
        
        self.changeContainer(index: ProfileContainer.ponits.rawValue)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
            self.editProfileView.backgroundColor = self.unSeletedBackgroundColor
            self.ordersView.backgroundColor = self.unSeletedBackgroundColor
            self.pointsView.backgroundColor = self.seletedBackgroundColor
            self.addressView.backgroundColor = self.unSeletedBackgroundColor
            
            self.editProfileLabel.textColor = self.unSeletedLabelColor
            self.ordersLabel.textColor = self.unSeletedLabelColor
            self.pointsLabel.textColor = self.seletedLabelColor
            self.addressLabel.textColor = self.unSeletedLabelColor
            
            
            self.view.layoutIfNeeded()
        }) { (success) in  }
    }
    
    func addressSelected(){
        
        self.changeContainer(index: ProfileContainer.address.rawValue)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
            self.editProfileView.backgroundColor = self.unSeletedBackgroundColor
            self.ordersView.backgroundColor = self.unSeletedBackgroundColor
            self.pointsView.backgroundColor = self.unSeletedBackgroundColor
            self.addressView.backgroundColor = self.seletedBackgroundColor
            
            self.editProfileLabel.textColor = self.unSeletedLabelColor
            self.ordersLabel.textColor = self.unSeletedLabelColor
            self.pointsLabel.textColor = self.unSeletedLabelColor
            self.addressLabel.textColor = self.seletedLabelColor
            
            
            self.view.layoutIfNeeded()
        }) { (success) in  }
    }
    
    func changeContainer(index: Int){
        
        switch index {
        case ProfileContainer.editProfile.rawValue:
           
            addContainer(view: mContainerView, containerController: ProfileInfoFrameVC())
            break
        case ProfileContainer.orders.rawValue:
            
            addContainer(view: mContainerView, containerController: HistoryFrameVC())
            break
        case ProfileContainer.address.rawValue:
            
            addContainer(view: mContainerView, containerController: ProfileAddressFrameVC())
            
            break
        case ProfileContainer.ponits.rawValue:
            //            let targetVC = getPointsVC(self)
            //            mContainerView.addSubview(targetVC.view)
            //            targetVC.view.frame = mContainerView.bounds
            //            targetVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            //            targetVC.didMove(toParent: self)
            break
        default:
            break
        }
        
        
    }
    
}


extension ProfileFrameVC {
    
    func getPointsVC(_ vc: UIViewController) -> PointsVC {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let VC = storyBoard.instantiateViewController(withIdentifier: "PointsVC") as! PointsVC
        vc.addChild(VC)
        return VC
    }
    
}
