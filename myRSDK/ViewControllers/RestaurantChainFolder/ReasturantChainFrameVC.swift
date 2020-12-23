//
//  ReasturantChainFrameVC.swift
//  myRSDK
//
//  Created by Other Logic on 9/10/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit
import DropDown

class ReasturantChainFrameVC: UIViewController {

    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var areaView: UIView!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var areaButton: UIButton!
    @IBOutlet weak var downImage: UIImageView!
    
    @IBOutlet weak var chainTableView: UITableView!
    
    var areaObjectList: [AreaClass] = []
    var areaList: [String] = []
    
    var chainList: [Chain] = []
    
    let dropDown = DropDown()
    
    let chainNIB = "ReasturantChainCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        registerTableView()
        setLocationLabelTitle()
        setDropDownListData()
        
        checkAreaCart()
        getReasturants()
    }
    
    public init() {
        super.init(nibName: "ReasturantChainFrameVC", bundle: Bundle(for: ReasturantChainFrameVC.self))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLocationLabelTitle(){
        if let selectedItem = DefaultManager.getAreaDefault() {
            if APPLanguage() == Config.English {
                
                guard let title = selectedItem.areaNameEn else {
                    return
                }
                self.areaLabel.text = title
            }else{
                
                guard let title = selectedItem.areaNameAr else {
                    return
                }
                self.areaLabel.text = title
            }
        }
    }
    
    @IBAction func dorpDownAction(_ sender: Any) {
        dropDown.show()
    }
    
    func setDropDownListData(){
        self.setDropDown(on: self.subView, list: self.areaList)
    }
    
    func setDropDown(on View: UIView ,list: [String]){
        Utilits.configureDropDown(dropDown: dropDown, dropDownWidth: subView.frame.width)
        dropDown.anchorView = View
        dropDown.dataSource = list
        dropDown.selectionAction = { (index: Int, item: String) in
            self.areaLabel.text = list[index]
            if !self.areaObjectList.isEmpty {
                DefaultManager.saveAreaDefault(value: self.areaObjectList[index])
                self.checkAreaCart()
                self.getReasturants()
            }
        }
        
        guard let selectedItem = DefaultManager.getAreaDefault() else {
            return
        }
        for (index, item) in areaObjectList.enumerated() {
            if APPLanguage() == Config.English {
                guard let itemID = item.id, let selectedItemId = selectedItem.id, let title = selectedItem.areaNameEn else {
                    return
                }
                if itemID == selectedItemId {
                    self.dropDown.selectRow(index)
                    self.areaLabel.text = title
                }
            }else{
                guard let itemID = item.id, let selectedItemId = selectedItem.id, let title = selectedItem.areaNameAr else {
                    return
                }
                if itemID == selectedItemId {
                    self.dropDown.selectRow(index)
                    self.areaLabel.text = title
                }
            }
        }
    }
    
    func registerTableView(){
        chainTableView.separatorStyle = .none
        chainTableView.register(UINib(nibName: chainNIB, bundle: frameworkBundle), forCellReuseIdentifier: chainNIB)
    }
    
    //Resturants
    func getReasturants(){
        self.chainList.removeAll()
        self.chainTableView.reloadData()
        guard let areaID = Utilits.getSelectedAreaID() else {
            return
        }
        showLoadingView(on: self.view)
        MenuAPI.reasturantChain(areaID: areaID, view: self.view) { (error, success, model) in
            self.hideLoadingView()
            if error != nil || !success {
                return
            }
            guard let data = model?.data, let list = data.restaurants else {
                return
            }
            print("sssize \(self.chainList.count)")
            self.chainList = list
            self.chainTableView.reloadData()
        }
    }
    
    func checkAreaCart(){
        guard let carts = CoreDaTaHandler.getCarts() else{
            return
        }
        if carts.isEmpty {
            return
        }
        carts.forEach { (cart) in
            if let cartAreaId = cart.area_id, let areaID = Utilits.getSelectedAreaID() {
                print("arrreas ids \(cartAreaId)  \(areaID)")
                if cartAreaId != areaID {
                    removeCart()
                }
            }
        }
    }
    
    func removeCart(){
        if CoreDaTaHandler.cleanData() {
            AlertManager.showWrongAlertWithMessage(on: self, message: "cart_change".getLocalizedValue())
            print("print data cleared")
        }
    }
    
    func checkReasturantCart(){
        guard let carts = CoreDaTaHandler.getCarts() else{
            toHomeAndSaveReasturant()
            return
        }
        if carts.isEmpty {
            toHomeAndSaveReasturant()
            return
        }
        carts.forEach { (cart) in
            if let resAreaId = cart.res_id, let resID = Utilits.getSelectedReasturantID() {
                print("resssss ids \(resAreaId)  \(resID)")
                if resAreaId != resID {
                    removeCartWithResponse()
                }else{
                    toHomeAndSaveReasturant()
                }
            }
        }
    }
    
    func removeCartWithResponse(){
        if CoreDaTaHandler.cleanData() {
            AlertManager.oneActionWithResponse(on: self, message: "cart_change".getLocalizedValue()) { (success) in
                if success{
                    self.toHomeAndSaveReasturant()
                }
            }
            print("print data cleared")
        }
    }
    
    func toHomeAndSaveReasturant(){
        NavigationManager.toHome(self)
    }

}


extension ReasturantChainFrameVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chainList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ReasturantChainCell = chainTableView.dequeueReusableCell(withIdentifier: chainNIB, for: indexPath) as! ReasturantChainCell
        
        cell.selectionStyle = .none
        
        if APPLanguage() == Config.English {
            if let name = chainList[indexPath.row].nameEn {
                cell.titleLabel.text = name
            }
        }else{
            if let name = chainList[indexPath.row].nameAr {
                cell.titleLabel.text = name
            }
        }
        
        if let mUrl = chainList[indexPath.row].images {
            cell.seImage(url: mUrl)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DefaultManager.saveReasrturantDefault(value: chainList[indexPath.row])
        checkReasturantCart()
    }
}
