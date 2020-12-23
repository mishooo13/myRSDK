//
//  CheckOutFrameVC.swift
//  myRSDK
//
//  Created by Other Logic on 9/29/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit

enum DeliverMehod: String {
    case Delivery = "1"
    case PickUP = "2"
}

enum OrderTime: String {
    case now = "1"
}

struct CheckoutModel {
    var type: String = ""
    var row: Int = 1
}

class CheckOutFrameVC: UIViewController {
    
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var subSuccessView: UIView!
    
    @IBOutlet weak var successImage: UIImageView!
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var trackBtn: UIButton!
    @IBOutlet weak var orderAgainBtn: UIButton!
    
    
    let checkoutItemNib = "ChcekoutItemCell"
    let checkoutAddressNIB = "CheckoutAddressCell"
    let checkoutCouponNIB = "CheckoutCouponCell"
    let checkoutOrderNIB = "CheckoutOrderCell"
    let checkoutPaymentNIB = "CheckoutPaymentCell"
    let checkoutTimingNIB = "CheckoutTimingCell"
    let specialNib = "CheckoutSpecialCell"
    
    var list: [Cart] = []
    var totalPriceValue: Double = 0
    
    var sections: [CheckoutModel] = []
    var itemType: String = "item"
    var addressType: String = "addrress"
    var couponType: String = "coupon"
    var orderType: String = "order"
    var timingType: String = "timing"
    let specialType: String = "special"
    var paymentType: String = "payment"
    
    var checkPaymenyExist: String = ""
    
    var specialRequest: String = ""
    var isPickup: Bool = false
    var isAddress: Bool = false
    var PAYMENT_TYPE: String = ""
    var DELIVERY_TYPE: String = ""
    
    var isRemoveCoupon: Bool = false
    
    var branch: Branch?
    var address: Address?
    var branchList: [Branch] = []
    var addressList: [Address] = []
    var areaList: [AreaClass] = []
    
    var latitude: String = ""
    var longitude: String = ""
    var addressID: String = ""
    var areaID: String = ""
    var branchId: String = ""
    var coupon: String = ""
    var specialRequestTxt: String = ""
    var timingValue: String = ""
    
    var carTypeValue: String = ""
    var carColorValue: String = ""
    
    var totalPrice: Double = 0
    var totalAmount: Double = 0
    var discountValue: Double = 0
    
    var orderFalied: Bool = false
    
    var vatPercentage: Double = 0
    
    let datePickerContainer = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBranchOrAddress()
        setUI()
        checkSetting()
        setNIBs()
        getAreas()
        //getCart()
        print("mmmmmmm \(carTypeValue)   \(carColorValue)")
    }
    
    public init() {
        super.init(nibName: "CheckOutFrameVC", bundle: Bundle(for: CheckOutFrameVC.self))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkSetting(){
        MenuAPI.SettingsAPI(view: self.view) { (error, success, model) in
            if error != nil || !success{
                AlertManager.showDissmissVC(on: self)
                return
            }
            
            guard let vat = model?.tax else {
                AlertManager.showDissmissVC(on: self)
                return
            }
            
            if let checkPayment = model?.cardPayment {
                self.checkPaymenyExist = checkPayment
            }
            
            self.vatPercentage = Double(vat)!
            self.getCart()
            self.mTableView.reloadData()
        }
    }
    
    func getAreas(){
        showLoadingView(on: self.view)
        LoginAPI.areasAPI(view: self.view) { (error, success, model) in
            self.hideLoadingView()
            if error != nil || !success{
                return
            }
            guard let data = model?.data else {
                return
            }
            guard let list = data.areas else {
                return
            }
            self.areaList = list
            self.mTableView.reloadData()
        }
    }
    
    //Get json of cart items
    func createJsonObjectFromCart() -> NSMutableDictionary{
        var infoId: String = ""
        var extraIDs: String = ""
        var optionsIDs: String = ""
        var quantity: String = ""
        
        let para:NSMutableDictionary = NSMutableDictionary()
        let prodArray:NSMutableArray = NSMutableArray()
        
        //para.setValue("1", forKey: "payment")
        //para.setValue("2", forKey: "branch")
        
        list.forEach { (cart) in
            let prod: NSMutableDictionary = NSMutableDictionary()
            
            if let id = cart.info_id {
                infoId = id
            }
            if let extras = cart.extra_ids {
                extraIDs = extras
            }
            if let options = cart.options_ids {
                optionsIDs = options
            }
            quantity = "\(cart.quantity)"
            
            prod.setValue(infoId, forKey: "id")
            prod.setValue(convertStringToArray(value: extraIDs), forKey: "extras")
            if cart.offer {
                prod.setValue(convertStringToArray(value: ""), forKey: "options")
                prod.setValue(convertStringToArray(value: optionsIDs), forKey: "choices")
            }else{
                prod.setValue(convertStringToArray(value: optionsIDs), forKey: "options")
                prod.setValue(convertStringToArray(value: ""), forKey: "choices")
            }
            prod.setValue(quantity, forKey: "count")
            prod.setValue(cart.special_request ?? "", forKey: "special")
            
            prodArray.add(prod)
        }
        para.setObject(prodArray, forKey: "items" as NSCopying)
        return para
    }
    
    func convertStringToArray(value: String) -> [String]{
        if value.isEmpty {
            return []
        }
        return value.components(separatedBy: ",")
    }
    
    //Check if pickup or delivery
    func setupBranchOrAddress(){
        if isPickup {
            DELIVERY_TYPE = DeliverMehod.PickUP.rawValue
            if branch != nil {
                branchList.append(branch!)
            }
        }
        
        if isAddress {
            DELIVERY_TYPE = DeliverMehod.Delivery.rawValue
            if address != nil {
                addressList.append(address!)
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUI(){
        hideStatusBarLine()
        Utilits.cornerLeftRight(view: mView)
        Utilits.cornerLeftRight(view: subSuccessView)
        
        hideKeyboardWhenTappedAround()
        
        mTableView.separatorStyle = .none
        mTableView.rowHeight = UITableView.automaticDimension
        mTableView.estimatedRowHeight = 250
    }
    
    func setNIBs(){
        mTableView?.register(UINib(nibName: checkoutItemNib, bundle: frameworkBundle), forCellReuseIdentifier: checkoutItemNib)
        mTableView?.register(UINib(nibName: checkoutAddressNIB, bundle: frameworkBundle), forCellReuseIdentifier: checkoutAddressNIB)
        mTableView?.register(UINib(nibName: checkoutCouponNIB, bundle: frameworkBundle), forCellReuseIdentifier: checkoutCouponNIB)
        mTableView?.register(UINib(nibName: checkoutOrderNIB, bundle: frameworkBundle), forCellReuseIdentifier: checkoutOrderNIB)
        mTableView?.register(UINib(nibName: checkoutTimingNIB, bundle: frameworkBundle), forCellReuseIdentifier: checkoutTimingNIB)
        mTableView?.register(UINib(nibName: checkoutPaymentNIB, bundle: frameworkBundle), forCellReuseIdentifier: checkoutPaymentNIB)
        mTableView?.register(UINib(nibName: specialNib, bundle: frameworkBundle), forCellReuseIdentifier: specialNib)
    }
    
    func getCart(){
        totalPriceValue = 0
        if let carts = CoreDaTaHandler.getCarts() {
            self.list = carts
            mTableView.reloadData()
        }
        list.forEach { (item) in
            totalPriceValue += Double(item.quantity) * item.total_price
        }
        // items sections
        sections.append(CheckoutModel(type: itemType, row: list.count))
        
        //address or pickup section
        if isPickup {
            sections.append(CheckoutModel(type: addressType, row: branchList.count))
        }
        if isAddress {
            sections.append(CheckoutModel(type: addressType, row: addressList.count))
        }
        
        //Timing section
        sections.append(CheckoutModel(type: timingType, row: 1))
        
        //coupon section
        sections.append(CheckoutModel(type: couponType, row: 1))
        
        //Payment section
        sections.append(CheckoutModel(type: paymentType, row: 1))
        
        //Special section
        sections.append(CheckoutModel(type: specialType, row: 1))
        
        //order section
        sections.append(CheckoutModel(type: orderType, row: 1))
        
        
        //totalPriceLabel.text = "\(totalPriceValue)"
        self.totalPrice = totalPriceValue
        calculateAmoutPrice(price: totalPriceValue)
    }
    
    func calculateAmoutPrice(price: Double) {
        
        if vatPercentage == 0 {
            calculateAsNoVAT(price: price)
        }else{
            calculateAsHasVAT(price: price)
        }
        
    }
    
    func calculateAsNoVAT(price: Double){
        var deliveryFee: Double = 0.0
        
        if isPickup {
            //deliveryFeeLabel.isHidden = true
            //deliveryTitleLabel.isHidden = true
        }else if isAddress {
            
            guard let fee = Utilits.getDeliveryFees() else {
                return
            }
            deliveryFee = Double(fee)!
            //deliveryFeeLabel.text = fee
        }
        
        let amountAfterDelivery = price + deliveryFee
        let amount: Double = amountAfterDelivery
        self.totalAmount = amount
    }
    
    func calculateAsHasVAT(price: Double){
        var deliveryFee: Double = 0.0
        var taxFee: Double = 0.0
        
        if isPickup {
            //deliveryFeeLabel.isHidden = true
            //deliveryTitleLabel.isHidden = true
        }else if isAddress {
            
            guard let fee = Utilits.getDeliveryFees() else {
                return
            }
            deliveryFee = Double(fee)!
            //deliveryFeeLabel.text = fee
        }
        
        let amountAfterDelivery = price + deliveryFee
        taxFee = Double((amountAfterDelivery * vatPercentage) / 100)
        let amount: Double = amountAfterDelivery + taxFee
        self.totalAmount = amount
        //AmountPriceLabel.text = "\(amount)"
    }
    
    @IBAction func placeOrderAction(_ sender: Any) {
        print("ammmmmount \(totalAmount)")
    }
    
    func placeOrder(grandTotal: Double){
        
        guard DefaultManager.getUserToken() != nil else {
            NavigationManager.toLoginDismiss(self)
            return
        }
        
        guard DefaultManager.getUserPhone() != nil else {
            NavigationManager.toProfile(self, isPhone: true)
            return
        }
        
        if list.isEmpty {
            AlertManager.showWrongAlert(on: self)
            return
        }
        
        if timingValue.isEmpty {
            showToast(message: "order_time".getLocalizedValue(), controller: self)
            return
        }
        
        if PAYMENT_TYPE.isEmpty {
            showToast(message: "payment_choose".getLocalizedValue(), controller: self)
            return
        }
        if isAddress {
            if let latitude = address?.lat {
                self.latitude = latitude
            }
            if let longitude = address?.lng {
                self.longitude = longitude
            }
            if let area = address?.area {
                if let areaID = area.id {
                    self.areaID = "\(areaID)"
                }
            }
            if let addressID = address?.id {
                self.addressID = "\(addressID)"
            }
        }
        
        if isPickup {
            if let branchID = branch?.id {
                self.branchId = "\(branchID)"
            }
        }
        
        if isAddress {
            if areaID.isEmpty || addressID.isEmpty {
                AlertManager.showWrongAlert(on: self)
                return
            }else{
                doOrder(grandTotal: grandTotal)
            }
        }else if isPickup {
            if branchId.isEmpty {
                AlertManager.showWrongAlert(on: self)
                return
            }else{
                doOrder(grandTotal: grandTotal)
            }
        }
    }
    
    func doOrder(grandTotal: Double){
        if !Connectivity.isConnectedToInternet {
            AlertManager.showWrongAlertWithMessage(on: self, message: "internet_failed".getLocalizedValue())
            return
        }
        guard let token = DefaultManager.getUserToken() else {
            NavigationManager.toLoginDismiss(self)
            return
        }
        
        var deviceID: String = ""
        if PAYMENT_TYPE == PaymentMehod.VISA.rawValue {
            guard let id = PaymentManager.getDeviceID() else{
                return
            }
            deviceID = id
        }
        
        if timingValue == OrderTime.now.rawValue {
            timingValue = ""
        }
        
        print("deviccee id \(deviceID) area  \(areaID)  branch  \(branchId)   \(timingValue)")
        showLoadingView(on: mView)
        MenuAPI.checkout(apiToken: token, items: createJsonObjectFromCart(), payment: PAYMENT_TYPE, deliveryType: DELIVERY_TYPE, lat: latitude, lng: longitude, address: addressID, area: areaID, mBranch: branchId, coupon: coupon, notes: specialRequestTxt, mTime: timingValue, deviceID: deviceID, carType: carTypeValue, carColor: carColorValue, view: self.view) { (error, success, message, model) in
            self.hideLoadingView()
            if message != nil {
                AlertManager.showWrongAlertWithMessage(on: self, message: message!)
                return
            }
            if error != nil || !success {
                AlertManager.showWrongAlert(on: self)
                return
            }
            guard let data = model?.data else {
                return
            }
            self.successOrder(data: data, grandTotal: grandTotal)
        }
    }
    
    func successOrder(data: CheckoutData, grandTotal: Double){
        print("heeeey success")
        switch PAYMENT_TYPE {
        case PaymentMehod.VISA.rawValue:
            guard let id = data.orderID else {
                return
            }
            guard let token = data.SDKToken else {
                return
            }
            pay(id: id, SDKToken: token, grandTotal: grandTotal)
            break
        case PaymentMehod.Cash.rawValue:
            showOrderSuccessScreen()
            break
        default:
            break
        }
    }
    
    func showOrderSuccessScreen(){
        if CoreDaTaHandler.cleanData() {
            if orderAgainBtn.isHidden {
                print("a7aaaaac")
                returnPaySuccess()
            }
            self.successView.isHidden = false
        }
    }
    
    func pay(id: Int, SDKToken: String, grandTotal: Double){
        
    }
    
    func getNumber(grandTotal: Double) -> Int{
        //let number = totalAmount.rounded(toPlaces: 2) * 100
        let number = grandTotal.rounded(toPlaces: 2) * 100
        return Int(number)
    }
    
    func paySuccess(id: Int, SDKToken: String){
        print("payment success")
        guard let apiToken = DefaultManager.getUserToken() else {
            return
        }
        showLoadingView(on: self.view)
        MenuAPI.checkPayment(apiToken: apiToken, orderID: "\(id)", SDKToken: SDKToken, view: self.view) { (error, success) in
            self.hideLoadingView()
            if error != nil || !success {
                AlertManager.showWrongAlertWithMessage(on: self, message: "payment_failed".getLocalizedValue())
                return
            }
            self.showOrderSuccessScreen()
        }
    }
    
    func payFailed(id: Int, SDKToken: String){
        print("payment failed")
        
        cancelOrder(id: id, SDKToken: SDKToken)
        
        successImage.image = UIImage(named: "wrong-check.png")
        successLabel.text = "wrong_message".getLocalizedValue()
        trackBtn.setTitle("try_again".getLocalizedValue(), for: .normal)
        orderAgainBtn.isHidden = true
        orderFalied = true
        successView.isHidden = false
    }
    
    func returnPaySuccess(){
        print("order success")
        
        
        successImage.image = UIImage(named: "thank-image.png")
        successLabel.text = "order_success_view".getLocalizedValue()
        trackBtn.setTitle("track_order".getLocalizedValue(), for: .normal)
        orderAgainBtn.isHidden = false
        orderFalied = false
        //successView.isHidden = false
    }
    
    func cancelOrder(id: Int, SDKToken: String){
        guard let apiToken = DefaultManager.getUserToken() else {
            return
        }
        showLoadingView(on: self.view)
        MenuAPI.cancelOrder(apiToken: apiToken, orderID: "\(id)", SDKToken: SDKToken, view: self.view) { (error, success) in
            self.hideLoadingView()
            if error != nil || !success {
                return
            }
        }
    }
    
    //Success View display after success order
    @IBAction func trackOrderAction(_ sender: Any) {
        if orderFalied {
            successView.isHidden = true
            orderFalied = false
        }else{
            NavigationManager.toTrackOrder(self)
        }
    }
    
    @IBAction func orderAginAction(_ sender: Any) {
        NavigationManager.toHome(self)
    }
    
    //Calucluate Total price without offer items
    func priceWithNoOffers() -> Double{
        var price: Double = 0
        list.forEach { (item) in
            if !item.coupon_offer {
                price += Double(item.quantity) * item.total_price
            }
        }
        return price
    }
    
}



extension CheckOutFrameVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section]
        
        switch item.type {
            
        case itemType:
            let cell: ChcekoutItemCell = mTableView.dequeueReusableCell(withIdentifier: checkoutItemNib, for: indexPath) as! ChcekoutItemCell
            cell.selectionStyle = .none
            
            cell.tag = indexPath.row
            if APPLanguage() == Config.Arablic {
                cell.itemQuantity.text = "x \(list[indexPath.row].quantity) "
            }else{
                cell.itemQuantity.text = "\(list[indexPath.row].quantity) x "
            }
            
            if let title = list[indexPath.row].title {
                cell.itemName.text = title
            }
            if let desc = list[indexPath.row].desc {
                cell.detailsLabel.text = desc
            }
            cell.calculatePrice(quantity: Int(list[indexPath.row].quantity), totalPrice: list[indexPath.row].total_price)
            
            return cell
            
            
        case addressType:
            let cell: CheckoutAddressCell = mTableView.dequeueReusableCell(withIdentifier: checkoutAddressNIB, for: indexPath) as! CheckoutAddressCell
            cell.selectionStyle = .none
            if isPickup {
                if APPLanguage() == Config.English {
                    if let title = branchList[indexPath.row].nameEn {
                        cell.typeLabel.text = title
                    }
                    
                    if let address = branchList[indexPath.row].addressEn {
                        cell.addressLabel.text = address
                    }
                }else{
                    if let title = branchList[indexPath.row].nameAr {
                        cell.typeLabel.text = title
                    }
                    
                    if let address = branchList[indexPath.row].addressAr {
                        cell.addressLabel.text = address
                    }
                }
            }
            if isAddress {
                var address: String = ""
                
                if let area = addressList[indexPath.row].area {
                    if APPLanguage() == Config.English {
                        if let areaName = area.areaNameEn {
                            cell.typeLabel.text = areaName
                        }
                    }else{
                        if let areaName = area.areaNameAr {
                            cell.typeLabel.text = areaName
                        }
                    }
                }
                if let building = addressList[indexPath.row].building {
                    address += building
                }
                if let street = addressList[indexPath.row].street {
                    address += ", \(street)"
                }
                if let floor = addressList[indexPath.row].floor {
                    address += " ,\("floor".getLocalizedValue()) \(floor)"
                }
                cell.addressLabel.text = address
            }
            return cell
            
        case timingType:
            let cell: CheckoutTimingCell = mTableView.dequeueReusableCell(withIdentifier: checkoutTimingNIB, for: indexPath) as! CheckoutTimingCell
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
            
        case couponType:
            let cell: CheckoutCouponCell = mTableView.dequeueReusableCell(withIdentifier: checkoutCouponNIB, for: indexPath) as! CheckoutCouponCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.address = address
            cell.branch = branch
            cell.isAddress = isAddress
            cell.isPickup = isPickup
            //cell.totalPriceValue = totalPrice //totalPriceValue
            cell.totalPriceValue = priceWithNoOffers()
            cell.vc = self
            cell.carts = self.list
            cell.paymenyType = PAYMENT_TYPE
            if isRemoveCoupon {
                cell.removeCoupon()
                self.isRemoveCoupon = false
            }
            return cell
            
        case paymentType:
            let cell: CheckoutPaymentCell = mTableView.dequeueReusableCell(withIdentifier: checkoutPaymentNIB, for: indexPath) as! CheckoutPaymentCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.checkIFPaymentExist(checkPaymenyExist: self.checkPaymenyExist)
            return cell
            
        case orderType:
            let cell: CheckoutOrderCell = mTableView.dequeueReusableCell(withIdentifier: checkoutOrderNIB, for: indexPath) as! CheckoutOrderCell
            cell.selectionStyle = .none
            cell.address = address
            cell.branch = branch
            cell.isAddress = isAddress
            cell.isPickup = isPickup
            cell.vc = self
            cell.areaList = areaList
            cell.setDefaultArea()
            cell.calculatePrice(isPickup: isPickup, isAddress: isAddress, totalPriceValue: totalPriceValue, totalAmount: totalAmount, discountValue: discountValue, vatPercentage: vatPercentage)
            cell.delegate = self
            return cell
            
        case specialType:
            let cell: CheckoutSpecialCell = mTableView.dequeueReusableCell(withIdentifier: specialNib, for: indexPath) as! CheckoutSpecialCell
            cell.selectionStyle = .none
            cell.resizeCollectionView()
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.main.scale
            cell.delegate = self
            return cell
            
        default:
            let cell: CheckoutCouponCell = mTableView.dequeueReusableCell(withIdentifier: checkoutCouponNIB, for: indexPath) as! CheckoutCouponCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension CheckOutFrameVC: CouponDelegate {
    func showCouponLoadingView() {
        showLoadingView(on: self.view)
    }
    
    func hideCouponLoadingView() {
        hideLoadingView()
    }
    
    func removeCoupon() {
        discountValue = 0
        mTableView.reloadData()
    }
    
    func passCoupon(coupon: String, discountValue: Double) {
        self.coupon = coupon
        self.discountValue = discountValue
        //let totalPriceAfterDiscount = totalPrice - discountValue
        //totalPriceValue = totalPriceAfterDiscount
        mTableView.reloadData()
    }
    
    
}


extension CheckOutFrameVC: OrderDelegate {
    func makeOrder(grandTotal: Double) {
        placeOrder(grandTotal: grandTotal)
        //print("ammmmmount \(grandTotal)    \(totalAmount)   \(totalPriceValue)   \(discountValue)")
    }
    
}


extension CheckOutFrameVC: PaymentDelegate {
    func passPayment(method: String) {
        PAYMENT_TYPE = method
        
        if !coupon.isEmpty {
            isRemoveCoupon = true
        }
        mTableView.reloadData()
        //removeCoupon()
    }
}


extension CheckOutFrameVC: CheckoutSpecialDelegate {
    func passSpecialText(text: String) {
        self.specialRequestTxt = text
    }
}


extension CheckOutFrameVC: TimingDelegate {
    
    func laterPressed(laterTextField: UITextField) {
        
        print("later")
        
        let picker : UIDatePicker = UIDatePicker()
        
        datePickerContainer.backgroundColor = AppColorsManager.greenColor
        datePickerContainer.frame = CGRect(x:0, y:self.view.bounds.size.height - 330, width: self.view.frame.width, height:330)
        
        
        picker.datePickerMode = .dateAndTime
        picker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: .valueChanged)
        //let pickerSize : CGSize = picker.sizeThatFits(CGSize.zero)
        picker.frame = CGRect(x:0, y: 40, width: datePickerContainer.frame.width, height:datePickerContainer.frame.height)
        picker.backgroundColor = AppColorsManager.grayColor
        datePickerContainer.addSubview(picker)
        
        let doneButton = UIButton()
        doneButton.setTitle("done".getLocalizedValue(), for: .normal)
        doneButton.contentMode = .center
        doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.addTarget(self, action: #selector(dismissPicker), for: .touchUpInside)
        doneButton.frame = CGRect(x:4, y: 4, width: 100, height: 35)
        datePickerContainer.addSubview(doneButton)
        
        self.view.addSubview(datePickerContainer)
        
    }
    
    @objc func dismissPicker(sender: UIButton) {
        print("disssmsmsms")
        UIView.animate(withDuration: 0.4) {
            self.datePickerContainer.removeFromSuperview()
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func dueDateChanged(sender:UIDatePicker){
        let formatter = DateFormatter()
        //formatter.dateFormat = "dd/MM/yyyy"
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        timingValue = formatter.string(from: sender.date)
        //showToast(message: "date \(formatter.string(from: sender.date))", controller: self)
    }
    
    
    func nowPressed() {
        timingValue = OrderTime.now.rawValue
        print("noooooooow")
    }
}
