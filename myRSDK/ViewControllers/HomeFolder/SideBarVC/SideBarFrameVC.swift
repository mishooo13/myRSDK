//
//  SideBarFrameVC.swift
//  myRSDK
//
//  Created by Other Logic on 9/10/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit

enum SideBarSections {
    case Home
    case Category
    case About
}

protocol SideBarCategoryProtocol {
    func passMenuIndex(index: Int)
}

class SideBarFrameVC: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userBackgroundImage: UIImageView!
    @IBOutlet weak var mCollectionView: UICollectionView!
    
    var homeNIB                     = "SideBarHomeCell"
    let categoryNIB                 = "SideBarCategoryCell"
    let aboutNIB                    = "SideBarAboutCell"
    
    var sectionDic = [SideBarSections.Home: 0, SideBarSections.Category: 1,
                      SideBarSections.About: 2]
    
    var menuList: [Menu] = []
    
    var delegate: SideBarCategoryProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        observerHandling()
        fillUI()
        setNIBs()
        getMenu()
    }
    
    public init() {
        super.init(nibName: "SideBarFrameVC", bundle: Bundle(for: SideBarFrameVC.self))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func observerHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAreaChanges), name: .didAreaChanged, object: nil)
    }
    
    @objc func handleAreaChanges(){
        
        menuList.removeAll()
        mCollectionView.reloadData()
        
        getMenu()
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
            userNameLabel.text = name
        }
    }
    
    func setNIBs(){
        
        mCollectionView.register(UINib(nibName: homeNIB, bundle: frameworkBundle), forCellWithReuseIdentifier: homeNIB)
        mCollectionView.register(UINib(nibName: categoryNIB, bundle: frameworkBundle), forCellWithReuseIdentifier: categoryNIB)
        mCollectionView.register(UINib(nibName: aboutNIB, bundle: frameworkBundle), forCellWithReuseIdentifier: aboutNIB)
    }
    
    func getMenu(){
        guard let areaID = Utilits.getSelectedAreaID() else {
            return
        }
        showLoadingView(on: self.view)
        MenuAPI.menus(areaID: areaID, view: self.view) { (error, success, list) in
            self.hideLoadingView()
            if error != nil || !success {
                return
            }
            guard let mList = list else {
                return
            }
            if mList.isEmpty {
                /*self.sectionDic.removeValue(forKey: .Category)
                self.sectionDic[.About] = 1
                self.mCollectionView.deleteSections(IndexSet(integer: 1))*/
                self.mCollectionView.reloadData()
                return
            }
            self.menuList = mList[0].sections!
            self.mCollectionView.reloadData()
        }
    }

    @objc func openCloseSideBar(){
        
    }
    
    @IBAction func homeAction(_ sender: Any) {
        NotificationCenter.default.post(name: .didSideBar, object: nil)
    }
    
    @IBAction func ordersAction(_ sender: Any) {
        guard DefaultManager.getUserToken() != nil else {
            NavigationManager.toLoginDismiss(self)
            return
        }
        NavigationManager.toOrders(self)
    }
    
    @IBAction func offersAction(_ sender: Any) {
        NavigationManager.toOffers(self)
    }
    
    @IBAction func profileAction(_ sender: Any) {
        guard DefaultManager.getUserToken() != nil else {
            NavigationManager.toLoginDismiss(self)
            return
        }
        NavigationManager.toProfile(self)
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
        guard DefaultManager.getUserToken() != nil else {
            NavigationManager.toLoginDismiss(self)
            return
        }
        NavigationManager.toFavorites(self)
    }
    
    @IBAction func getHelpAction(_ sender: Any) {
        
    }
    
    @IBAction func aboutAction(_ sender: Any) {
        Utilits.arabicActin(self)
    }
    
    @IBAction func shareAction(_ sender: Any) {
        Utilits.englishAction(self)
    }
    
    @IBAction func arabicAction(_ sender: Any) {
        
    }
    
    @IBAction func englishAction(_ sender: Any) {
        
    }

}


extension SideBarFrameVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionDic.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == sectionDic[.Home] {
            return 1
        }else if section == sectionDic[.Category] {
            return menuList.count
        }else if section == sectionDic[.About]{
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == sectionDic[.Home] {
            let cell:SideBarHomeCell = collectionView.dequeueReusableCell(withReuseIdentifier: homeNIB, for: indexPath) as! SideBarHomeCell
            cell.vc = self
            return cell
        }else if indexPath.section == sectionDic[.Category] {
            let cell:SideBarCategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryNIB, for: indexPath) as! SideBarCategoryCell
            if APPLanguage() == Config.English {
                if let title = menuList[indexPath.row].nameEn {
                    cell.titleLabel.text = title
                }
            }else{
                if let title = menuList[indexPath.row].nameAr {
                    cell.titleLabel.text = title
                }
            }
            
            if let mUrl = menuList[indexPath.row].image {
                cell.seImage(url: mUrl)
            }
            return cell
        }else{
            let cell:SideBarAboutCell = collectionView.dequeueReusableCell(withReuseIdentifier: aboutNIB, for: indexPath) as! SideBarAboutCell
            cell.vc = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == sectionDic[.Home] {
            return CGSize(width: self.view.frame.width, height: 210)
        }else if indexPath.section == sectionDic[.About] {
            return CGSize(width: self.view.frame.width, height: 160)
        }else{
            return CGSize(width: self.view.frame.width, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == sectionDic[.Home] {
            return UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 20)
        }else if section == sectionDic[.Category] {
            return UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 20)
        }else if section == sectionDic[.About] {
            return UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 20)
        }
        return UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == sectionDic[.Category] {
            
            NotificationCenter.default.post(name: .didSideBar, object: nil)
            
            let rowDataDict:[String: Int] = ["row": indexPath.row]
            NotificationCenter.default.post(name: .didCategory, object: nil, userInfo: rowDataDict)
        }
    }
    
}
