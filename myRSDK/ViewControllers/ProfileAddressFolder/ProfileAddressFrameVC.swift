//
//  ProfileAddressFrameVC.swift
//  myRSDK
//
//  Created by Other Logic on 9/13/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit

class ProfileAddressFrameVC: UIViewController {

    @IBOutlet weak var mTableView: UITableView!
    
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationImage: UIImageView!
    
    let addresshNib = "AddressCell"
    let addAddressNib = "AddAddressCell"
    var list: [Address] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setNIBs()
        handleImageAction()
    }
    
    public init() {
        super.init(nibName: "ProfileAddressFrameVC", bundle: Bundle(for: ProfileAddressFrameVC.self))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAddresses()
    }
    
    func handleImageAction(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        locationImage.isUserInteractionEnabled = true
        locationImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        toAddAddress()
    }
    
    @IBAction func addAddressAction(_ sender: Any) {
        toAddAddress()
    }
    
    func toAddAddress(){
        guard DefaultManager.getUserToken() != nil else {
            NavigationManager.toLoginDismiss(self)
            return
        }
        NavigationManager.toAddAddress(self)
    }
    
    func setUI(){
        
        mTableView.separatorStyle = .none
        mTableView.rowHeight = UITableView.automaticDimension
        mTableView.estimatedRowHeight = 250
    }
    
    func setNIBs(){
        mTableView?.register(UINib(nibName: addresshNib, bundle: frameworkBundle), forCellReuseIdentifier: addresshNib)
        mTableView?.register(UINib(nibName: addAddressNib, bundle: frameworkBundle), forCellReuseIdentifier: addAddressNib)
    }
    
    func getAddresses(){
        
        guard let token = DefaultManager.getUserToken() else {
            return
        }
        showLoadingView(on: self.view)
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
            if list.isEmpty {
                self.locationView.isHidden = false
                return
            }else{
                self.locationView.isHidden = true
            }
            self.list = list
            self.mTableView.reloadData()
        }
    }

}



extension ProfileAddressFrameVC: UITableViewDataSource, UITableViewDelegate {
    
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
            let cell: AddAddressCell = mTableView.dequeueReusableCell(withIdentifier: addAddressNib, for: indexPath) as! AddAddressCell
            cell.delegate = self
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = list[indexPath.row].id else {
            return
        }
        print("\(id)")
    }
}


extension ProfileAddressFrameVC : AddAddressDelegate{
    func addressAction() {
        guard DefaultManager.getUserToken() != nil else {
            NavigationManager.toLoginDismiss(self)
            return
        }
        NavigationManager.toAddAddress(self)
    }
}


extension ProfileAddressFrameVC : RemoveAddressDelegate{
    func removed() {
        getAddresses()
    }
}
