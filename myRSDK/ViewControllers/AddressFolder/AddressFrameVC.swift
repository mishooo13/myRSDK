//
//  AddressFrameVC.swift
//  myRSDK
//
//  Created by Other Logic on 9/13/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit

protocol AddressesDelegate {
    func dismissAddressDelegate() -> Void
    func passAddress(address: Address) -> Void
}

class AddressFrameVC: UIViewController {

    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var mTableView: UITableView!
    
    let addresshNib = "AddressCell"
    let addAddresshNib = "AddAddressCell"
    var delegate: AddressesDelegate?
    var list: [Address] = []
    
    var passAddressController : ((_ address: Address)->())?
    var dismissAddressDelegateController : (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !Connectivity.isConnectedToInternet {
            showInternetFailed(view: self.mView)
            return
        }
        
        setUI()
        setNIBs()
    }
    
    public init() {
        super.init(nibName: "AddressFrameVC", bundle: Bundle(for: AddressFrameVC.self))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAddresses()
    }
    
    @IBAction func addAddressAction(_ sender: Any) {
        guard DefaultManager.getUserToken() != nil else {
            NavigationManager.toLoginDismiss(self)
            return
        }
        NavigationManager.toAddAddress(self)
    }
    
    func setUI(){
        Utilits.cornerLeftRight(view: mView)
        
        mTableView.separatorStyle = .none
        mTableView.rowHeight = UITableView.automaticDimension
        mTableView.estimatedRowHeight = 250
    }
    
    func setNIBs(){
        mTableView?.register(UINib(nibName: addresshNib, bundle: frameworkBundle), forCellReuseIdentifier: addresshNib)
        mTableView?.register(UINib(nibName: addAddresshNib, bundle: frameworkBundle), forCellReuseIdentifier: addAddresshNib)
    }
    
    func getAddresses(){
        
        guard let token = DefaultManager.getUserToken() else {
            return
        }
        showLoadingView(on: mView)
        ProfileAPI.getAddresses(token: token, view: self.view) { (error, success, model) in
            self.hideLoadingView()
            if error != nil || !success {
                AlertManager.showWrongAlert(on: self)
                return
            }
            guard let data = model?.data else {
                AlertManager.showWrongAlert(on: self)
                return
            }
            guard let list = data.address else {
                AlertManager.showWrongAlert(on: self)
                return
            }
            self.list = list
            self.mTableView.reloadData()
        }
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismissAddressDelegateController?()
        //delegate?.dismissAddressDelegate()
    }
    

}


extension AddressFrameVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return list.count
        }else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: AddressCell = mTableView.dequeueReusableCell(withIdentifier: addresshNib, for: indexPath) as! AddressCell
            cell.selectionStyle = .none
            cell.delegate = self
            if let id = list[indexPath.row].id {
                cell.tag = id
            }
            var address: String = ""
            
            if let area = list[indexPath.row].area {
                if APPLanguage() == Config.English {
                    if let areaName = area.areaNameEn {
                        cell.titleLabel.text = areaName
                    }
                }else{
                    if let areaName = area.areaNameAr {
                        cell.titleLabel.text = areaName
                    }
                }
            }
            if let building = list[indexPath.row].building {
                address += building
            }
            if let street = list[indexPath.row].street {
                address += ", \(street)"
            }
            if let floor = list[indexPath.row].floor {
                address += " ,\("floor".getLocalizedValue()) \(floor)"
            }
            cell.detailsLabel.text = address
            return cell
        }else{
            let cell: AddAddressCell = mTableView.dequeueReusableCell(withIdentifier: addAddresshNib, for: indexPath) as! AddAddressCell
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.passAddressController?(list[indexPath.row])
        //delegate?.passAddress(address: list[indexPath.row])
    }
}

extension AddressFrameVC : AddAddressDelegate{
    func addressAction() {
        guard DefaultManager.getUserToken() != nil else {
            NavigationManager.toLoginDismiss(self)
            return
        }
        NavigationManager.toAddAddress(self)
    }
}


extension AddressFrameVC : RemoveAddressDelegate{
    func removed() {
        getAddresses()
    }
}

