//
//  PickupModelFrameVC.swift
//  myRSDK
//
//  Created by Other Logic on 9/28/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit
import DropDown

enum CarThruType: String {
    case carType = "1"
    case carColor = "2"
}

enum PickupModelType: String {
    case normal = "1"
    case car = "2"
}

protocol PickupModelDelegate {
    func dismissPickupVC()
    func pickupCarData(modelType: String, type: String, color: String)
    
}



class PickupModelFrameVC: UIViewController {

    @IBOutlet weak var pickupBtn: UIButton!
    @IBOutlet weak var carThruBtn: UIButton!
    @IBOutlet weak var pickupImage: UIImageView!
    @IBOutlet weak var carThruImage: UIImageView!
    @IBOutlet weak var timingStack: UIStackView!
    @IBOutlet weak var pickupView: UIView!
    
    @IBOutlet weak var carThruFieldsView: UIView!
    @IBOutlet weak var carThruFieldsHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var carTypeField: UITextField!
    @IBOutlet weak var carColorField: UITextField!
    @IBOutlet weak var carTypeBtn: UIButton!
    @IBOutlet weak var carColorBtn: UIButton!
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var dismissBtn: UIButton!
    
    
    let dropDown = DropDown()
    var delegate: PickupModelDelegate?
    
    let carTypeList: [String] = ["Audi", "BMW", "Chevrolet", "Chrysler", "Citroen", "Dodge", "Ferrari", "Fiat", "Ford", "Geely", "Honda", "Hyundai", "Infiniti", "Jaguar", "Jeep", "Kia", "Land Rover", "Lexus", "Mazda", "Mercedes-Benz", "Mini", "Mitsubishi", "Nissan", "Peugeot", "Porsche", "Ram", "Renault", "Rolls Royce", "Subaru", "Suzuki", "Toyota", "Volkswagen", "Volvo"]
    
    let colorList: [String] = ["Black", "Blue", "Green", "Brown", "Silver", "Red", "Yellow", "White"]
    
    var pickupType: String = ""
    var typeValue: String = ""
    var colorValue: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    public init() {
        super.init(nibName: "PickupModelFrameVC", bundle: Bundle(for: PickupModelFrameVC.self))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func pickupAction(_ sender: Any) {
        pickupType = PickupModelType.normal.rawValue
        UIView.animate(withDuration: 0.3) {
            self.pickupImage.image = UIImage(named: "radio-full", in: frameworkBundle, compatibleWith: .none)
            self.carThruImage.image = UIImage(named: "radio-empty", in: frameworkBundle, compatibleWith: .none)
            self.carThruFieldsHeightConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func carThruAction(_ sender: Any) {
        pickupType = PickupModelType.car.rawValue
        UIView.animate(withDuration: 0.3) {
            self.pickupImage.image = UIImage(named: "radio-empty", in: frameworkBundle, compatibleWith: .none)
            self.carThruImage.image = UIImage(named: "radio-full", in: frameworkBundle, compatibleWith: .none)
            self.carThruFieldsHeightConstraint.constant = 120
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func carTypeAction(_ sender: Any) {
        setDropDown(on: self.carTypeBtn, list: carTypeList, type: CarThruType.carType.rawValue)
        
        print("auuuuua")
        
        dropDown.show()
    }
    
    @IBAction func carColorAction(_ sender: Any) {
        setDropDown(on: self.carColorBtn, list: colorList, type: CarThruType.carColor.rawValue)
        
        dropDown.show()
    }
    
    func setDropDown(on View: UIView ,list: [String], type: String){
        Utilits.configureDropDown(dropDown: dropDown, dropDownWidth: View.frame.width)
        dropDown.anchorView = View
        dropDown.dataSource = list
        dropDown.selectionAction = { (index: Int, item: String) in
            if type == CarThruType.carType.rawValue {
                self.typeValue = list[index]
                self.carTypeField.text = list[index]
            }else if type == CarThruType.carColor.rawValue {
                self.colorValue = list[index]
                self.carColorField.text = list[index]
            }
        }
        
    }
    
    @IBAction func submitAction(_ sender: Any) {
        if pickupType.isEmpty {
            showToast(message: "Please choose pickup type", controller: self)
            return
        }
        if pickupType == PickupModelType.normal.rawValue { //Normal one
            delegate?.pickupCarData(modelType: pickupType, type: "", color: "")
        }else if pickupType == PickupModelType.car.rawValue { //Car Thru
            if typeValue.isEmpty {
                showToast(message: "Please choose Car Type", controller: self)
                return
            }
            if colorValue.isEmpty {
                showToast(message: "Please choose Car Color", controller: self)
                return
            }
            delegate?.pickupCarData(modelType: pickupType, type: typeValue, color: colorValue)
        }
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        delegate?.dismissPickupVC()
    }

}
