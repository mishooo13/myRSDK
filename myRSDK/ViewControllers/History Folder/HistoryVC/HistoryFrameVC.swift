//
//  HistoryFrameVC.swift
//  myRSDK
//
//  Created by Other Logic on 9/10/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit

class HistoryFrameVC: UIViewController {

    @IBOutlet weak var mTableView: UITableView!
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleConstraint: NSLayoutConstraint!
    
    let historyNib = "HistoryCell"
    var list: [History] = []
    
    var isRateViewShowed: Bool = false
    var tag: Int = 0
    var isHideTitle: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !Connectivity.isConnectedToInternet {
            //showInternetFailed(view: self.mView)
            return
        }
        
        setUI()
        setNIBs()
        getHistory()
    }
    
    public init() {
        super.init(nibName: "HistoryFrameVC", bundle: Bundle(for: HistoryFrameVC.self))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUI(){
        
        mTableView.separatorStyle = .none
        mTableView.rowHeight = UITableView.automaticDimension
        mTableView.estimatedRowHeight = 250
        
        if isHideTitle {
            titleConstraint.constant = 0
            titleView.isHidden = true
        }
    }
    
    func setNIBs(){
        mTableView?.register(UINib(nibName: historyNib, bundle: frameworkBundle), forCellReuseIdentifier: historyNib)
    }
    
    func getHistory(){
        guard let token = DefaultManager.getUserToken() else {
            return
        }
        showLoadingView(on: self.view)
        ProfileAPI.history(token: token, view: self.view) { (error, success, model) in
            self.hideLoadingView()
            if error != nil || !success {
                return
            }
            guard let data = model?.data else {
                return
            }
            guard let list = data.details else {
                return
            }
            self.list = list
            self.mTableView.reloadData()
        }
    }

}


extension HistoryFrameVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HistoryCell = mTableView.dequeueReusableCell(withIdentifier: historyNib, for: indexPath) as! HistoryCell
        
        cell.selectionStyle = .none
        cell.delegate = self
        cell.tag = indexPath.row
        
        if let status = list[indexPath.row].status {
            cell.statusLabel.text = status
            
            if status == OrderStatus.Pending.rawValue || status == OrderStatus.Processing.rawValue
                || status == OrderStatus.InWay.rawValue {
                cell.trackBtn.isHidden = false
            }else{
                cell.trackBtn.isHidden = true
            }
        }
        
        if let orderNumber = list[indexPath.row].orderID {
            cell.orderLabel.text = "\("order_number".getLocalizedValue()) \(orderNumber)"
        }
        if let orderDate = list[indexPath.row].createdAt {
            cell.dateLabel.text = orderDate
        }
        
        if let total = list[indexPath.row].total {
            
            cell.totalLabel.text = "\(Utilits.splitPrice(price: total)) \("pound".getLocalizedValue())"
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension HistoryFrameVC: HistoryDelegate {
    
    func trackDelegate(tage: Int) {
        guard let orderID = list[tage].orderID else {
            return
        }
        
        let newVC = TrackOrderFrameVC()
        newVC.modalPresentationStyle = .fullScreen
        newVC.orderID = orderID
        newVC.isBackToHome = false
        present(newVC, animated: true, completion: nil)
    }
    
    func rateDelegate(tage: Int) {
        if isRateViewShowed {
            hideRateView()
        }else{
            self.tag = tage
            showRateView()
        }
    }
    
    func detailsDelegate(tage: Int) {
        guard let orderID = list[tage].orderID else {
            return
        }
        
        let newVC = HistoryDetailsFrameVC()
        newVC.modalPresentationStyle = .fullScreen
        newVC.orderID = orderID
        present(newVC, animated: true, completion: nil)
    }
    
    func showRateView(){
        
    }
    
    func hideRateView(){
        
    }
    
    
}

