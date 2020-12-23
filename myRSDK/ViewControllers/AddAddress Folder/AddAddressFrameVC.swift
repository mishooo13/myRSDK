//
//  AddAddressFrameVC.swift
//  myRSDK
//
//  Created by Other Logic on 9/13/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit
import DropDown

class AddAddressFrameVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var areaField: UITextField!
    @IBOutlet weak var streetField: UITextField!
    @IBOutlet weak var buildingField: UITextField!
    @IBOutlet weak var floorField: UITextField!
    @IBOutlet weak var apartmentField: UITextField!
    @IBOutlet weak var additionalField: UITextField!
    @IBOutlet weak var addressName: UITextField!
    @IBOutlet weak var dropDownBtn: UIButton!
    
    var country: String = ""
    var city: String = ""
    var area: String = ""
    var street: String = ""
    var building: String = ""
    var mFloor: String = ""
    var apartment: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var additional: String = ""
    var addName: String = ""
    
    let dropDown = DropDown()
    var areaList: [String] = []
    var areaObjectList: [AreaClass] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        fillData()
        setUI()
        getAreas()
    }
    
    public init() {
        super.init(nibName: "AddAddressFrameVC", bundle: Bundle(for: AddAddressFrameVC.self))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillData(){
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUI(){
        hideStatusBarLine()
        Utilits.cornerLeftRight(view: scrollView)
        
        Utilits.textFieldStyle(textField: addressName)
        Utilits.textFieldStyle(textField: areaField)
        Utilits.textFieldStyle(textField: streetField)
        Utilits.textFieldStyle(textField: buildingField)
        Utilits.textFieldStyle(textField: floorField)
        Utilits.textFieldStyle(textField: apartmentField)
        Utilits.textFieldStyle(textField: additionalField)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        addAddress()
    }
    
    func getAreas(){
        
        LoginAPI.areasAPI(view: self.view) { (error, success, model) in
            if error != nil || !success{
                return
            }
            guard let data = model?.data else {
                return
            }
            guard let list = data.areas else {
                return
            }
            list.forEach({ (item) in
                if self.APPLanguage() == Config.English {
                    if let title = item.areaNameEn {
                        self.areaList.append(title)
                    }
                }else{
                    if let title = item.areaNameAr {
                        self.areaList.append(title)
                    }
                }
                
            })
            self.areaObjectList = list
            self.setDropDown(on: self.dropDownBtn, list: self.areaList)
        }
    }
    
    func setDropDown(on View: UIView ,list: [String]){
        Utilits.configureDropDown(dropDown: dropDown, dropDownWidth: dropDownBtn.frame.width)
        dropDown.anchorView = View
        dropDown.dataSource = list
        dropDown.selectionAction = { (index: Int, item: String) in
            self.areaField.text = list[index]
            if !self.areaObjectList.isEmpty {
                DefaultManager.saveAreaDefault(value: self.areaObjectList[index])
            }
        }
        if let selectedItem = DefaultManager.getAreaDefault() {
            for (index, item) in areaObjectList.enumerated() {
                if APPLanguage() == Config.English {
                    if let itemID = item.id, let selectedItemId = selectedItem.id, let title = selectedItem.areaNameEn {
                        print("nnnn \(itemID)  \(selectedItemId)")
                        if itemID == selectedItemId {
                            self.dropDown.selectRow(index)
                            self.areaField.text = title
                        }
                    }
                }else{
                    if let itemID = item.id, let selectedItemId = selectedItem.id, let title = selectedItem.areaNameAr {
                        print("nnnn \(itemID)  \(selectedItemId)")
                        if itemID == selectedItemId {
                            self.dropDown.selectRow(index)
                            self.areaField.text = title
                        }
                    }
                }
                
                
            }
        }
        
    }
    
    @IBAction func dorpDownAction(_ sender: Any) {
        dropDown.show()
    }
    
    func addAddress(){
        
        if !Connectivity.isConnectedToInternet {
            AlertManager.showWrongAlertWithMessage(on: self, message: "internet_failed".getLocalizedValue())
            return
        }
        
        guard let token = DefaultManager.getUserToken() else {
            return
        }
        /*guard let city = cityField.text else {
         return
         }*/
        guard let areaDefault = DefaultManager.getAreaDefault() else {
            return
        }
        guard let area = areaDefault.id else {
            return
        }
        guard let street = streetField.text else {
            return
        }
        guard let building = buildingField.text else {
            return
        }
        guard let mFloor = floorField.text else {
            return
        }
        guard let apartment = apartmentField.text else {
            return
        }
        if street.isEmpty || street.isEmpty || building.isEmpty || mFloor.isEmpty || apartment.isEmpty{
            AlertManager.showWrongAlertWithMessage(on: self, message: "fields_required".getLocalizedValue())
            return
        }
        
        if let additional = additionalField.text {
            self.additional = additional
        }
        
        if let addName = addressName.text {
            self.addName = addName
        }
        //print("\(token)        \(area)        \(street)         \(building)        \(mFloor)       \(apartment)        \(additional)            \(addName)")
        showLoadingView(on: scrollView)
        ProfileAPI.addAddress(token: token, name: addName, city: "", area: "\(area)", street: street, building: building, mFloor: mFloor, apartment: apartment, lat: "\(latitude)", lang: "\(longitude)", aadditional: additional, view: self.view) { (error, success) in
            self.hideLoadingView()
            if error != nil || !success {
                AlertManager.showWrongAlert(on: self)
                return
            }
            self.showToast(message: "address_success".getLocalizedValue(), controller: self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                //self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
            })
            
            print("Added successfully")
        }
    }

}
