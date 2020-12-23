//
//  BranchesFrameVC.swift
//  myRSDK
//
//  Created by Other Logic on 9/28/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit

protocol BranchesDelegate {
    func dismissBranchDelegate() -> Void
    func passBranch(branch: Branch) -> Void
}


class BranchesFrameVC: UIViewController {

    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var mTableView: UITableView!
    
    let branchNib = "BranchCell"
    var delegate: BranchesDelegate?
    var list: [Branch] = []
    
    var passBranchController : ((_ branch: Branch)->())?
    var dismissBranchDelegateController : (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !Connectivity.isConnectedToInternet {
            showInternetFailed(view: self.mView)
            return
        }
        
        setUI()
        setNIBs()
        getBranches()
    }
    
    public init() {
        super.init(nibName: "BranchesFrameVC", bundle: Bundle(for: BranchesFrameVC.self))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        Utilits.cornerLeftRight(view: mView)
        
        mTableView.separatorStyle = .none
        mTableView.rowHeight = UITableView.automaticDimension
        mTableView.estimatedRowHeight = 250
    }
    
    func setNIBs(){
        mTableView?.register(UINib(nibName: branchNib, bundle: frameworkBundle), forCellReuseIdentifier: branchNib)
    }
    
    func getBranches(){
        showLoadingView(on: mView)
        MenuAPI.branches(view: self.view) { (error, success, model) in
            self.hideLoadingView()
            if error != nil || !success {
                return
            }
            guard let data = model?.data else {
                return
            }
            guard let list = data.branches else {
                return
            }
            self.list = list
            self.mTableView.reloadData()
        }
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismissBranchDelegateController?()
    }

}


extension BranchesFrameVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BranchCell = mTableView.dequeueReusableCell(withIdentifier: branchNib, for: indexPath) as! BranchCell
        cell.selectionStyle = .none
        if APPLanguage() == Config.English {
            if let title = list[indexPath.row].nameEn {
                cell.titleLabel.text = title
            }
            if let address = list[indexPath.row].addressEn {
                cell.detailsLabel.text = address
            }
        }else{
            if let title = list[indexPath.row].nameAr {
                cell.titleLabel.text = title
            }
            if let address = list[indexPath.row].addressAr {
                cell.detailsLabel.text = address
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.passBranchController?(list[indexPath.row])
        //delegate?.passBranch(branch: list[indexPath.row])
    }
    
    
}

