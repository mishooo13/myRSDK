//
//  HistoryDetailsFrameVC.swift
//  myRSDK
//
//  Created by Other Logic on 9/29/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit

class HistoryDetailsFrameVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIView!
    
    @IBOutlet weak var itemsView: UIView!
    @IBOutlet weak var deliveryView: UIView!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var totalView: UIView!
    
    @IBOutlet weak var itemsLabel: UILabel!
    @IBOutlet weak var pickupOrDelveryLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var deliveryFeeLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var couponLabel: UILabel!
    
    @IBOutlet weak var deliveryTitleLabel: UILabel!
    @IBOutlet weak var discountTitleLabel: UILabel!
    
    @IBOutlet weak var subTotalView: UIView!
    @IBOutlet weak var deliveryFeeView: UIView!
    @IBOutlet weak var TaxView: UIView!
    @IBOutlet weak var grandTotalView: UIView!
    @IBOutlet weak var couponView: UIView!
    
    @IBOutlet weak var rateConstraint: NSLayoutConstraint!
    @IBOutlet weak var fairView: UIView!
    @IBOutlet weak var goodView: UIView!
    @IBOutlet weak var veryGoodView: UIView!
    @IBOutlet weak var execllentView: UIView!
    
    var orderID: String = ""
    var order: Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        loadData()
    }
    
    public init() {
        super.init(nibName: "HistoryDetailsFrameVC", bundle: Bundle(for: HistoryDetailsFrameVC.self))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !Connectivity.isConnectedToInternet {
            AlertManager.showNetworkFailed(on: self)
            return
        }
    }
    
    func setUI(){
        
        Utilits.cornerLeftRight(view: scrollView)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reorderAction(_ sender: Any) {
        makeReOrder()
    }
    
    func makeReOrder(){
        if order == nil {
            return
        }
        
        guard let items = order?.items else{
            return
        }
        
        items.forEach { (item) in
            
            var itemName: String = ""
            var specialRequest: String = ""
            var detailsOfOrder: String = ""
            
            guard let info = item.info else {
                return
            }
            if info.isEmpty {
                return
            }
            
            guard let infoID = info[0].id else {
                return
            }
            
            guard let itemImage = info[0].image else {
                return
            }
            
            if APPLanguage() == Config.English {
                guard let desc = info[0].sizeEn else {
                    return
                }
                detailsOfOrder = desc
            }else {
                guard let desc = info[0].sizeAr else {
                    return
                }
                detailsOfOrder = desc
            }
            
            guard let itemNameObj = item.name else {
                return
            }
            
            if APPLanguage() == Config.English {
                guard let name = itemNameObj.name else {
                    return
                }
                itemName = name
            }else{
                guard let name = itemNameObj.nameAr else {
                    return
                }
                itemName = name
            }
            
            if itemName.isEmpty {
                return
            }
            
            if let special = item.special {
                specialRequest = special
            }
            
            guard let quantity = item.count else {
                return
            }
            
            guard let price = item.subTotal else {
                return
            }
            
            let optionIDs = getOptionsIds(item: item)
            let extraIDS = getExtrasIds(item: item)
            
            guard let priceAsDouble = Double(price) else {
                return
            }
            
            var isCouponOffer: Bool = false
            if let offer = itemNameObj.offer {
                if offer == 1 {
                    isCouponOffer = true
                }else{
                    isCouponOffer = false
                }
            }
            
            
            
            guard let areaID = Utilits.getSelectedAreaID(), let resID = Utilits.getSelectedReasturantID() else {
                return
            }
            
            print("cart data \(infoID)   \(itemImage)   \(itemName)   \(detailsOfOrder)   \(quantity)    \(priceAsDouble)    \(infoID)    \(optionIDs)    \(extraIDS)  \(isCouponOffer)")
            
            /*if CoreDaTaHandler.saveCart(itemID: "\(infoID)", image: itemImage, title: itemName, specialRequest: specialRequest, desc: detailsOfOrder, quantity: Int32(quantity), totalPrice: priceAsDouble, infoId: "\(infoID)", optionsIds: optionIDs, extraIds: extraIDS, offer: false, couponOffer: isCouponOffer , mDate: Utilits.currentDateTime()) {
             print("Saved")
             AlertManager.reoderSuccess(on: self)
             }*/
            
            if CoreDaTaHandler.saveCart(areaID: areaID, resID: resID, itemID: "\(infoID)", image: itemImage, title: itemName, specialRequest: specialRequest, desc: detailsOfOrder, quantity: Int32(quantity), itemPrice: priceAsDouble, optionPrice: 0, extraPrice: 0, totalPrice: priceAsDouble, infoId: "\(infoID)", optionsIds: optionIDs, extraIds: extraIDS, offer: false, couponOffer: isCouponOffer, mDate: Utilits.currentDateTime()){
                
                AlertManager.reoderSuccess(on: self)
            }
        }
    }
    
    func getOptionsIds(item: HistoryItem) -> String{
        
        guard let options = item.options else {
            return ""
        }
        
        if options.isEmpty {
            return ""
        }
        var optionsID: String = ""
        options.forEach { (option) in
            guard let id = option.id else {
                return
            }
            if options.count == 1 {
                optionsID += "\(id)"
            }else{
                optionsID += "\(id),"
            }
        }
        
        if options.count > 1 {
            optionsID.removeLast()
        }
        return optionsID
    }
    
    func getOptionPrice(item: HistoryItem) -> Double{
        guard let optionPrice = item.totalOptionsPrice else {
            return 0
        }
        guard let optionPriceAsDouble = Double(optionPrice) else {
            return 0
        }
        return optionPriceAsDouble
    }
    
    func getExtrasIds(item: HistoryItem) -> String{
        
        guard let extras = item.extras else {
            return ""
        }
        
        if extras.isEmpty {
            return ""
        }
        
        var optionsID: String = ""
        extras.forEach { (option) in
            guard let id = option.id else {
                return
            }
            if extras.count == 1 {
                optionsID += "\(id)"
            }else{
                optionsID += "\(id),"
            }
            
        }
        
        if extras.count > 1 {
            optionsID.removeLast()
        }
        return optionsID
    }
    
    func getExtrasPrice(item: HistoryItem) -> Double{
        guard let extraPrice = item.totalExtrasPrice else {
            return 0
        }
        guard let extraPriceAsDouble = Double(extraPrice) else {
            return 0
        }
        return extraPriceAsDouble
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
            self.order = list[0]
            self.fillUIData()
        }
    }
    
    func fillUIData(){
        calculateCoupon()
        setPayment()
        setIfAddressOrPickup()
        setTitle()
        calculatePrices()
    }
    
    func setTitle(){
        guard let items = order?.items else {
            return
        }
        
        var mTitle: String = ""
        items.forEach { (item) in
            if APPLanguage() == Config.Arablic {
                guard let title = item.name else {
                    return
                }
                if let name = title.nameAr {
                    mTitle += "\(name) ,"
                }
            }else{
                guard let title = item.name else {
                    return
                }
                if let name = title.name {
                    mTitle += "\(name) ,"
                }
            }
        }
        
        
        if !mTitle.isEmpty{
            mTitle.removeLast()
        }
        self.itemsLabel.text = mTitle
    }
    
    func calculatePrices(){
        
        //Calculate subtotal
        guard let items = order?.items else {
            return
        }
        var subTotal: Double = 0
        items.forEach { (item) in
            guard let price = item.subTotal else {
                return
            }
            guard let count = item.count else {
                return
            }
            let mPrice = Double(price)! * Double(count)
            subTotal += mPrice
        }
        
        //Calculate Tax
        let amountAfterDelivery = subTotal + getDeliveryFee()
        let taxFee = Double((amountAfterDelivery * 14) / 100)
        discountLabel.text = "\(Utilits.splitPrice(price: taxFee)) \("pound".getLocalizedValue())"
        
        if subTotal != 0 {
            subTotalLabel.text = "\(Utilits.splitPrice(price: subTotal)) \("pound".getLocalizedValue())"
        }
        
        //Calculate total
        if let total = order?.total {
            
            
            totalLabel.text = "\(Utilits.splitPrice(price: total)) \("pound".getLocalizedValue())"
        }
    }
    
    func setIfAddressOrPickup(){
        guard let delveryType = order?.deliveryType else {
            return
        }
        
        switch "\(delveryType)" {
        case DeliverMehod.Delivery.rawValue:
            guard let address = order?.address else {
                return
            }
            if address.isEmpty {
                return
            }
            var addressTitle: String = ""
            guard let area = address[0].area else {
                return
            }
            if let street = address[0].street {
                addressTitle = street
            }
            
            if APPLanguage() == Config.English {
                if let userArea = area.areaNameEn {
                    addressTitle += ", \(userArea)"
                }
            }else{
                if let userArea = area.areaNameAr {
                    addressTitle += ", \(userArea)"
                }
            }
            
            self.deliveryLabel.text = addressTitle
            
            
            deliveryFeeLabel.text = "\(Utilits.splitPrice(price: getDeliveryFee())) \("pound".getLocalizedValue())"
            
            break
        case DeliverMehod.PickUP.rawValue:
            self.deliveryFeeView.isHidden = true
            //self.deliveryTitleLabel.isHidden = true
            self.pickupOrDelveryLabel.text = "pickup".getLocalizedValue()
            guard let branch = order?.branch else {
                return
            }
            if branch.isEmpty {
                return
            }
            if APPLanguage() == Config.English {
                if let address = branch[0].addressEn {
                    self.deliveryLabel.text = address
                }
            }else{
                if let address = branch[0].addressAr {
                    self.deliveryLabel.text = address
                }
            }
            
            break
            
        default:
            break
        }
    }
    
    func getDeliveryFee() -> Double {
        /*guard let address = order?.address else {
         return 0
         }
         if address.isEmpty {
         return 0
         }
         guard let area = address[0].area else {
         return 0
         }
         
         if let delvFee = area.deliveryFees {
         
         guard let fee = Double(delvFee) else {
         return 0
         }
         return fee
         }
         return 0*/
        guard let order = order else {
            return 0
        }
        guard let deliveryFees = order.deliveryFees else{
            return 0
        }
        guard let feesAsDouble = Double(deliveryFees) else {
            return 0
        }
        return feesAsDouble
    }
    
    
    func setPayment(){
        if let payment = order?.paymentMethod {
            if "\(payment)" == PaymentMehod.Cash.rawValue {
                paymentLabel.text = "cash".getLocalizedValue()
            }else if "\(payment)" == PaymentMehod.VISA.rawValue {
                paymentLabel.text = "visa".getLocalizedValue()
            }
        }
    }
    
    func calculateCoupon(){
        couponView.isHidden = true
    }
    
}

//Rate
extension HistoryDetailsFrameVC {
    @IBAction func fairAction(_ sender: Any) {
        rateOrder(rate: RatePoint.fair.rawValue)
    }
    @IBAction func goodAction(_ sender: Any) {
        rateOrder(rate: RatePoint.good.rawValue)
    }
    @IBAction func veryGoodAction(_ sender: Any) {
        rateOrder(rate: RatePoint.veryGood.rawValue)
    }
    @IBAction func execellentAction(_ sender: Any) {
        rateOrder(rate: RatePoint.execellent.rawValue)
    }
    
    func rateOrder(rate: Int){
        guard let token = DefaultManager.getUserToken() else {
            return
        }
        print("response  \(orderID)  \(rate)")
        showLoadingView(on: self.view)
        ProfileAPI.rateOrder(token: token, rate: "\(rate)", orderID: orderID, view: self.view) { (error, success) in
            self.hideLoadingView()
            if error != nil || !success {
                return
            }
            self.showToast(message: "rate_success".getLocalizedValue(), controller: self)
            self.successRate(rate: rate)
        }
    }
    
    func successRate(rate: Int){
        switch rate {
        case RatePoint.fair.rawValue:
            self.fairView.backgroundColor = UIColor.lightGray
            self.goodView.backgroundColor = UIColor.white
            self.veryGoodView.backgroundColor = UIColor.white
            self.execllentView.backgroundColor = UIColor.white
            break
        case RatePoint.good.rawValue:
            self.fairView.backgroundColor = UIColor.white
            self.goodView.backgroundColor = UIColor.lightGray
            self.veryGoodView.backgroundColor = UIColor.white
            self.execllentView.backgroundColor = UIColor.white
            break
        case RatePoint.veryGood.rawValue:
            self.fairView.backgroundColor = UIColor.white
            self.goodView.backgroundColor = UIColor.white
            self.veryGoodView.backgroundColor = UIColor.lightGray
            self.execllentView.backgroundColor = UIColor.white
            break
        case RatePoint.execellent.rawValue:
            self.fairView.backgroundColor = UIColor.white
            self.goodView.backgroundColor = UIColor.white
            self.veryGoodView.backgroundColor = UIColor.white
            self.execllentView.backgroundColor = UIColor.lightGray
            break
        default:
            break
        }
    }
}


enum RatePoint: Int {
    case fair = 1
    case good = 2
    case veryGood = 3
    case execellent = 4
}

