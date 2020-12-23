//
//  TrackOrderFrameVC.swift
//  myRSDK
//
//  Created by Other Logic on 9/29/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit

enum OrderStatus: String {
    case Pending = "Pending"
    case Processing = "Processing"
    case InWay = "In-way"
    case Delivered = "Delivered"
    case Canceled = "Canceled"
    case Rejected = "Rejected"
}

class TrackOrderFrameVC: UIViewController {

    @IBOutlet weak var placedView: UIView!
    @IBOutlet weak var confirmedView: UIView!
    @IBOutlet weak var procesedView: UIView!
    @IBOutlet weak var readyView: UIView!
    @IBOutlet weak var enjoyView: UIView!
    
    @IBOutlet weak var placedImage: UIImageView!
    @IBOutlet weak var confirmedImage: UIImageView!
    @IBOutlet weak var procesedImage: UIImageView!
    @IBOutlet weak var readyImage: UIImageView!
    @IBOutlet weak var enjoyImage: UIImageView!
    
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var mView: UIView!
    
    var orderID: String = ""
    var isBackToHome: Bool = true
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        loadData()
        
    }
    
    public init() {
           super.init(nibName: "TrackOrderFrameVC", bundle: Bundle(for: TrackOrderFrameVC.self))
       }
       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopTimer()
    }
    
    func startTimer() {
        
        timer =  Timer.scheduledTimer(timeInterval: 2.0 * 60, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }
    
    func stopTimer(){
        timer?.invalidate()
    }
    
    
    @objc func scrollAutomatically(_ timer1: Timer) {
        loadData()
    }
    
    @IBAction func backAction(_ sender: Any) {
        if isBackToHome {
            NavigationManager.toHome(self)
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    func setUI(){
        placedView.layer.cornerRadius = placedView.frame.width / 2
        confirmedView.layer.cornerRadius = confirmedView.frame.width / 2
        procesedView.layer.cornerRadius = procesedView.frame.width / 2
        readyView.layer.cornerRadius = readyView.frame.width / 2
        enjoyView.layer.cornerRadius = enjoyView.frame.width / 2
        
        Utilits.cornerLeftRight(view: scrollView)
    }
    
    func loadData(){
        if orderID.isEmpty {
            return
        }
        guard let token = DefaultManager.getUserToken() else {
            return
        }
        showLoadingView(on: scrollView)
        ProfileAPI.historyDetails(token: token, orderID: orderID, view: self.view) { (error, success, model) in
            self.hideLoadingView()
            if error != nil || !success {
                return
            }
            guard let data = model?.data else {
                return
            }
            guard let list = data.order else {
                return
            }
            if list.isEmpty {
                return
            }
            self.checkOrder(order: list[0])
            //self.order = list[0]
        }
    }
    
    func checkOrder(order: Order){
        guard let status = order.status else {
            return
        }
        switch status {
        case OrderStatus.Pending.rawValue:
            //orderPending()
            startTimer()
            break
        case OrderStatus.Processing.rawValue:
            stopTimer()
            orderProcessing()
            break
        case OrderStatus.InWay.rawValue:
            stopTimer()
            orderReady()
            break
        case OrderStatus.Delivered.rawValue:
            stopTimer()
            orderEnjoy()
            break
        default:
            orderPending()
        }
    }
    
    func orderPending(){
        placedImage.image = placedImage.image?.withRenderingMode(.alwaysTemplate)
        placedImage.tintColor = AppColorsManager.orangeColor
    }
    
    func orderProcessing(){
        confirmedImage.image = confirmedImage.image?.withRenderingMode(.alwaysTemplate)
        confirmedImage.tintColor = AppColorsManager.orangeColor
        
        procesedImage.image = procesedImage.image?.withRenderingMode(.alwaysTemplate)
        procesedImage.tintColor = AppColorsManager.orangeColor
    }
    
    func orderReady(){
        confirmedImage.image = confirmedImage.image?.withRenderingMode(.alwaysTemplate)
        confirmedImage.tintColor = AppColorsManager.orangeColor
        
        procesedImage.image = procesedImage.image?.withRenderingMode(.alwaysTemplate)
        procesedImage.tintColor = AppColorsManager.orangeColor
        
        readyImage.image = readyImage.image?.withRenderingMode(.alwaysTemplate)
        readyImage.tintColor = AppColorsManager.orangeColor
    }

    func orderEnjoy(){
        confirmedImage.image = confirmedImage.image?.withRenderingMode(.alwaysTemplate)
        confirmedImage.tintColor = AppColorsManager.orangeColor
        
        procesedImage.image = procesedImage.image?.withRenderingMode(.alwaysTemplate)
        procesedImage.tintColor = AppColorsManager.orangeColor
        
        readyImage.image = readyImage.image?.withRenderingMode(.alwaysTemplate)
        readyImage.tintColor = AppColorsManager.orangeColor
        
        enjoyImage.image = enjoyImage.image?.withRenderingMode(.alwaysTemplate)
        enjoyImage.tintColor = AppColorsManager.orangeColor
    }

}
