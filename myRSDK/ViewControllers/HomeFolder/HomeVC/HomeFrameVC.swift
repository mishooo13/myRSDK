//
//  HomeFrameVC.swift
//  myRSDK
//
//  Created by Other Logic on 9/10/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit

enum Sections {
    case Location
    case Offers
    case Menu
    case Foods
}


class HomeFrameVC: UIViewController {

    @IBOutlet weak var mCollectionView: UICollectionView!
    
    @IBOutlet weak var isOpenView: UIView!
    @IBOutlet weak var isOpenNSConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var areaView: UIView!
    @IBOutlet weak var areaConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomAreaConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bagView: UIView!
    
    
    var locationNIB                 = "HomeLocationCell"
    let offersNIB                   = "HomeOffersCell"
    let menuNIB                     = "HomeMenuCell"
    let foodsNIB                    = "HomeFoodsCell"
    
    let homeReusableViewID          = "HomeReusableView"
    
    var sectionTitles: [String] = ["offers_message".getLocalizedValue(), "menu_message".getLocalizedValue()]

    
    var locationTitle: String = "select_location".getLocalizedValue()
    
    var sectionDic = [Sections.Offers: 0, Sections.Foods: 1]
    
    var offerList: [Offer] = []
    var menuList: [Menu] = []
    var foodList: [Item] = []
    
    var foodListTag: Int = 0
    
    let StoreSegue: String = "toUpdateStore"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNIBs()
        setNotificationCenter()
        
        //getLocation()
        getMenu()
        
        if !DefaultManager.getDeviceType() {
            setDeviceType()
        }
        
        let layout = mCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        
        if let token = DefaultManager.getUserToken() {
            print("token is \(token)")
        }
    }
    
    public init() {
        super.init(nibName: "HomeFrameVC", bundle: Bundle(for: HomeFrameVC.self))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        setupBagView(bagView: bagView)
        
        //checkAppVersion()
        
        self.checkOpen()
    }
    
    func checkAppVersion(){
        VersionManager.shared.checkAppStore { (isNew, ourVersion, storeVersion) in
            if isNew{
                self.performSegue(withIdentifier: self.StoreSegue, sender: nil)
            }
            //print("response version \(ourVersion)   \(storeVersion)    \(isNew)")
        }
    }
    
    func setNIBs(){
        //mCollectionView.register(UINib(nibName: locationNIB, bundle: nil), forCellWithReuseIdentifier: locationNIB)
        
        mCollectionView.register(HomeOffersCell.self, forCellWithReuseIdentifier: offersNIB)
        
        mCollectionView.register(HomeMenuCell.self, forCellWithReuseIdentifier: menuNIB)
        
        mCollectionView.register(UINib(nibName: foodsNIB, bundle: frameworkBundle), forCellWithReuseIdentifier: foodsNIB)
        
        mCollectionView.register(UINib(nibName: homeReusableViewID, bundle: frameworkBundle), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: homeReusableViewID)
    }
    
    func setDeviceType(){
        guard let token = DefaultManager.getUserToken() else {
            return
        }
        ProfileAPI.deviceType(token: token, view: self.view) { (error, success) in
            if error != nil || !success{
                return
            }
            print("deviiiice type saaved")
            DefaultManager.saveDeviceType(value: true)
        }
    }
    
    func setNotificationCenter(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.setCategoryData(_:)), name: .didCategory, object: nil)
    }
    
    @objc func setCategoryData(_ notification: NSNotification) {
        if let row = notification.userInfo?["row"] as? Int {
            
            var section: Int = 0
            self.sectionDic.forEach { (key, value) in
                if key == .Foods {
                    section = value
                }
            }
            
            if let attributes = mCollectionView.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: section)) {
                var offsetY = attributes.frame.origin.y - mCollectionView.contentInset.top
                if #available(iOS 11.0, *) {
                    offsetY -= mCollectionView.safeAreaInsets.top
                }
                mCollectionView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true) // or animated: false
            }
            
            self.foodListTag = row
            getFoodList(tag: row)
        }
    }

    @IBAction func sideBarAction(_ sender: Any) {
        NotificationCenter.default.post(name: .didSideBar, object: nil)
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    func getOffers(menuID: String){
        guard let priceList = DefaultManager.getAreaPriceListDefault() else {
            return
        }
        showLoadingView(on: self.view)
        MenuAPI.offers(menuID: menuID, priceList: priceList,view: self.view) { (error, success, model) in
            self.hideLoadingView()
            if error != nil || !success {
                return
            }
            guard let data = model?.data else {
                return
            }
            guard let list = data.offers else {
                return
            }
            if list.isEmpty {
                
                self.sectionTitles.remove(at: 0)
                self.sectionDic.removeValue(forKey: .Offers)
                //self.sectionDic[.Menu] = 0
                self.sectionDic[.Foods] = 0
                self.mCollectionView.deleteSections(IndexSet(integer: 0))
                self.mCollectionView.reloadData()
                return
            }
            self.offerList = list
            //self.mCollectionView.reloadData()
            self.mCollectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    
    
    func getMenu(){
        
        guard let areaID = Utilits.getSelectedAreaID()else {
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
                self.mCollectionView.reloadData()
                return
            }
            self.menuList = mList[0].sections!
            self.getFoodList(tag: 0)
            self.mCollectionView.reloadData()
            guard let menuID = mList[0].id else {
                return
            }
            DefaultManager.saveMenuIdDefault(token: "\(menuID)")
            self.getOffers(menuID: "\(menuID)")
        }
    }
    
    
    
    func getFoodList(tag: Int){
        if menuList.isEmpty {
            return
        }
        guard let items = menuList[tag].items else {
            return
        }
        removeNoPricesItems(items: items)
    }
    
    func removeNoPricesItems(items: [Item]) {
        var newFoodList: [Item] = []
        for (_, item) in items.enumerated() {
            if let info = item.info {
                if !info.isEmpty {
                    if info[0].price != nil {
                        newFoodList.append(item)
                    }
                }
            }
        }
        
        self.foodList = newFoodList
        if sectionDic.count == 1 {
            self.mCollectionView.reloadSections(IndexSet(integer: 0))
        }else{
            self.mCollectionView.reloadSections(IndexSet(integer: 1))
        }
        
    }
    
    func getLocation(){
        if let selectedItem = DefaultManager.getAreaDefault() {
            if APPLanguage() == Config.English {
                
                guard let title = selectedItem.areaNameEn else {
                    return
                }
                locationTitle = title
            }else{
                
                guard let title = selectedItem.areaNameAr else {
                    return
                }
                locationTitle = title
            }
            self.mCollectionView.reloadSections(IndexSet(integer: sectionDic[.Location]!))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toArea" {
            let embedVC = segue.destination as! AreaFrameWorkVC
            embedVC.delegate = self
        }
    }
}



extension HomeFrameVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionDic.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("nnnnnn \(section)")
        if section == sectionDic[.Location] {
            return 1
        }else if section == sectionDic[.Offers] {
            return 1
        }else if section == sectionDic[.Foods] {
            return foodList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == sectionDic[.Location] {
            let cell:HomeLocationCell = collectionView.dequeueReusableCell(withReuseIdentifier: locationNIB, for: indexPath) as! HomeLocationCell
            cell.delegate = self
            cell.titleLabel.text = locationTitle
            return cell
        }else if indexPath.section == sectionDic[.Offers] {
            let cell:HomeOffersCell = collectionView.dequeueReusableCell(withReuseIdentifier: offersNIB, for: indexPath) as! HomeOffersCell
            cell.homeVC = self
            cell.offerList = self.offerList
            return cell
        }else if indexPath.section == sectionDic[.Menu]{
            let cell:HomeMenuCell = collectionView.dequeueReusableCell(withReuseIdentifier: menuNIB, for: indexPath) as! HomeMenuCell
            cell.delegate = self
            cell.tag = indexPath.row
            cell.foodListTag = self.foodListTag
            cell.moveToCell(index: self.foodListTag)
            cell.menuList = menuList
            return cell
        }else if indexPath.section == sectionDic[.Foods]{
            let cell:HomeFoodsCell = collectionView.dequeueReusableCell(withReuseIdentifier: foodsNIB, for: indexPath) as! HomeFoodsCell
            cell.shadowAndBorderForCell(cell: cell, radius: 8)
            let item = foodList[indexPath.row]
            if APPLanguage() == Config.English {
                if let name = item.nameEn {
                    cell.titleLabel.text = name
                }
                if let desc = item.desriptionEn {
                    cell.detailsLabel.text = desc
                }
            }else{
                if let name = item.nameAr {
                    cell.titleLabel.text = name
                }
                if let desc = item.desriptionAr {
                    cell.detailsLabel.text = desc
                }
                
            }
            if let info = item.info {
                cell.setPrice(info: info)
            }
            if let image = item.image {
                cell.seImage(url: image)
            }
            return cell
        }else{
            let cell:HomeFoodsCell = collectionView.dequeueReusableCell(withReuseIdentifier: foodsNIB, for: indexPath) as! HomeFoodsCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == sectionDic[.Location] {
            return CGSize(width: view.frame.width, height: 100)
        }else if indexPath.section == sectionDic[.Offers] {
            return CGSize(width: view.frame.width, height: 270)
        }else if indexPath.section == sectionDic[.Menu]{
            return CGSize(width: view.frame.width, height: 50)
        }else{
            let width = view.frame.size.width - 30
            return CGSize(width: width, height: 270)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == sectionDic[.Foods] {
            return UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
        }else if section == sectionDic[.Offers] {
            return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        }
        return UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var resuable: UICollectionReusableView? = nil
        if kind == UICollectionView.elementKindSectionHeader {
            
            if indexPath.section == sectionDic[.Foods] {
                let cell:HomeMenuCell = collectionView.dequeueReusableCell(withReuseIdentifier: menuNIB, for: indexPath) as! HomeMenuCell
                cell.delegate = self
                cell.tag = indexPath.row
                cell.foodListTag = self.foodListTag
                cell.moveToCell(index: self.foodListTag)
                cell.menuList = menuList
                resuable = cell
                return resuable!
            }else{
                let cell: HomeReusableView = (collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: homeReusableViewID, for: indexPath) as? HomeReusableView)!
                cell.headerLabel.text = sectionTitles[indexPath.section]
                resuable = cell
                return resuable!
            }
        }
        return resuable!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == sectionDic[.Offers] {
            return CGSize(width: 0, height: 40)
        }else if section == sectionDic[.Foods]{
            return CGSize(width: self.mCollectionView.bounds.width, height: 70)
            
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == sectionDic[.Foods] {
            toOrder(row: indexPath.row)
        }
    }
    
    func toOrder(row: Int){
        guard let itemID = foodList[row].id else {
            return
        }
        
        let newVC = DetailsFrameVC()
        newVC.modalPresentationStyle = .fullScreen
        newVC.itemID = "\(itemID)"
        present(newVC, animated: true, completion: nil)
    }
    
}


extension HomeFrameVC: MenuDelegate {
    func menuAction(tag: Int) {
        self.foodListTag = tag
        getFoodList(tag: tag)
    }
}



extension HomeFrameVC: LocationDelegate, AreaDelegate {
    func keyboardDetect(isOpne: Bool) {
        if isOpne {
            
            UIView.animate(withDuration: 0.1) {
                self.bottomAreaConstraint.constant = 150
                self.view.layoutIfNeeded()
            }
        }else{
            UIView.animate(withDuration: 0.1) {
                self.bottomAreaConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    func locationClicked() {
        showAreaView()
    }
    
    func showAreaView(){
        areaView.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
            self.areaConstraint.constant = 400
            self.view.layoutIfNeeded()
        }) { (success) in
            print("completed")
        }
    }
    
    func hideAreaView(){
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
            self.areaConstraint.constant = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.areaView.isHidden = true
        }
    }
    
    func dismissAreaDelegate() {
        hideAreaView()
    }
    
    func passArea(area: AreaClass) {
        DefaultManager.saveAreaDefault(value: area)
        getLocation()
        hideAreaView()
        
        menuList.removeAll()
        foodList.removeAll()
        offerList.removeAll()
        
        self.mCollectionView.reloadData()
        
        //remove carts
        /*if CoreDaTaHandler.cleanData() {
            
            print("print data cleared")
        }else{
            print("print data not cleared")
        }*/
        
        foodListTag = 0
        
        NotificationCenter.default.post(name: .didAreaChanged, object: nil)
        NotificationCenter.default.post(name: .didCartChanged, object: nil)
        
        UserDefaults.standard.removeObject(forKey: Config.menuDefault)
        
        getMenu()
        
        
        self.checkOpen()
    }
    
    func checkOpen(){
        print("reasturant status \(Utilits.checkIsOpen())")
        if Utilits.checkIsOpen() {
            branchIsOpen()
        }else{
            branchIsClose()
        }
    }
    
    func branchIsOpen(){
        UIView.animate(withDuration: 0.25) {
            self.isOpenNSConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func branchIsClose(){
        UIView.animate(withDuration: 0.25) {
            self.isOpenNSConstraint.constant = 40
            self.view.layoutIfNeeded()
        }
    }
}
