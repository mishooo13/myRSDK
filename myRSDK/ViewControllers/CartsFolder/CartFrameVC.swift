//
//  CartFrameVC.swift
//  myRSDK
//
//  Created by Other Logic on 9/28/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit

class CartFrameVC: UIViewController {
    
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var containerDarkView: UIView!
    @IBOutlet weak var branchConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressBtn: UIButton!
    @IBOutlet weak var pickupBtn: UIButton!
    @IBOutlet weak var pickAddressValueBtn: UIButton!
    @IBOutlet weak var addItemsBtn: UIButton!
    
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var branchView: UIView!
    
    let cartNib                  = "CartCell"
    var list: [Cart] = []
    var totalPriceValue: Double = 0
    
    var branchType: String = "branch"
    var addressType: String = "address"
    var cardType: String = "card"
    
    var pickupModelSegue: String = "toPickModel"
    
    
    var isPickup: Bool = false
    var isAddress: Bool = false
    var choosePickup: Bool = false
    var chooseAddress: Bool = true
    var branch: Branch?
    var address: Address?
    
    var pickupType: String = ""
    var carTypeValue: String = ""
    var carColorValue: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !Connectivity.isConnectedToInternet {
            showInternetFailed(view: self.mView)
            return
        }
        
        setUI()
        setNIBs()
        checkSetting()
        getCart()
        
        addAddressContainer(view: addressView, containerController: AddressFrameVC())
        addBranchContainer(view: branchView, containerController: BranchesFrameVC())
        
    }
    
    func addBranchContainer(view: UIView, containerController: UIViewController){
        // add container

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])

        // add child view controller view to container

        let controller = BranchesFrameVC()
        //controller.detectDelegate = self
        controller.passBranchController = { branch in
            self.passBranch(branch: branch)
        }
        
        controller.dismissBranchDelegateController = {
            self.dismissBranchDelegate()
        }
        
        
        addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(controller.view)

        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            controller.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        controller.didMove(toParent: self)
    }
    
    func addAddressContainer(view: UIView, containerController: UIViewController){
        // add container

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])

        // add child view controller view to container

        let controller = AddressFrameVC()
        //controller.detectDelegate = self
        controller.passAddressController = { address in
            self.passAddress(address: address)
        }
        
        controller.dismissAddressDelegateController = {
            self.dismissAddressDelegate()
        }
        
        
        addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(controller.view)

        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            controller.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        controller.didMove(toParent: self)
    }
    
    public init() {
        super.init(nibName: "CartFrameVC", bundle: Bundle(for: CartFrameVC.self))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUI(){
        hideStatusBarLine()
        Utilits.cornerLeftRight(view: subView)
        Utilits.cornerLeftRight(view: mView)
        Utilits.cornerLeftRightBtn(button: addressBtn)
        Utilits.cornerLeftRightBtn(button: pickupBtn)
        
        subView.layer.shadowColor = UIColor.gray.cgColor
        subView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        subView.layer.shadowRadius = 12.0
        subView.layer.shadowOpacity = 0.7
        
        mTableView.rowHeight = UITableView.automaticDimension
        mTableView.estimatedRowHeight = 250
        mTableView.separatorStyle = .none
        mTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        addItemsBtn.layer.borderWidth = 1
        addItemsBtn.layer.borderColor = AppColorsManager.greenColor?.cgColor
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissContainerView))
        tap.cancelsTouchesInView = false
        containerDarkView.addGestureRecognizer(tap)
    }
    
    @IBAction func addressAction(_ sender: Any) {
        setChoosedType(type: addressType)
    }
    
    @IBAction func pickupAction(_ sender: Any) {
        setChoosedType(type: branchType)
    }
    
    func setChoosedType(type: String){
        
        UIView.animate(withDuration: 0.3) {
            switch type {
            case self.addressType:
                self.chooseAddress = true
                self.choosePickup = false
                
                self.isAddress = false
                self.isPickup = false
                
                self.addressBtn.backgroundColor = AppColorsManager.greenColor
                self.addressBtn.setTitleColor(.white, for: .normal)
                
                self.pickupBtn.backgroundColor = UIColor.lightGray
                self.pickupBtn.setTitleColor(.black, for: .normal)
                
                self.pickAddressValueBtn.setTitle("choose_address".getLocalizedValue(), for: .normal)
                break
            case self.branchType:
                self.chooseAddress = false
                self.choosePickup = true
                
                self.isAddress = false
                self.isPickup = false
                
                self.addressBtn.backgroundColor = UIColor.lightGray
                self.addressBtn.setTitleColor(.black, for: .normal)
                
                self.pickupBtn.backgroundColor = AppColorsManager.greenColor
                self.pickupBtn.setTitleColor(.white, for: .normal)
                
                self.pickAddressValueBtn.setTitle("choose_branch".getLocalizedValue(), for: .normal)
                break
                
            default:
                break
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func addressOrPickupValueAction(_ sender: Any) {
        if chooseAddress {
            
            showContainerView(type: addressType)
        }
        
        if choosePickup {
            showContainerView(type: branchType)
        }
    }
    
    @IBAction func addItemsAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func checkSetting(){
        showLoadingView(on: self.view)
        MenuAPI.SettingsAPI(view: self.view) { (error, success, model) in
            self.hideLoadingView()
            if error != nil || !success{
                return
            }
            
            guard let checkIfPickup = model?.pickUp else {
                return
            }
            print("setting pickup is \(checkIfPickup)")
            if checkIfPickup == "1" {
                self.pickupBtn.isHidden = false
            }else{
                self.pickupBtn.isHidden = true
            }
        }
    }
    
    
    func showContainerView(type: String){
        containerDarkView.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
            switch type {
            case self.addressType:
                self.addressConstraint.constant = 300
                break
            case self.branchType:
                self.branchConstraint.constant = 300
                break
            default:
                break
            }
            self.view.layoutIfNeeded()
        }) { (success) in }
    }
    
    @objc func dismissContainerView() {
        containerDarkView.isHidden = true
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
            if self.branchConstraint.constant != 0 {
                self.branchConstraint.constant = 0
            }
            if self.addressConstraint.constant != 0 {
                self.addressConstraint.constant = 0
            }
            self.view.layoutIfNeeded()
        }) { (success) in
            print("completed")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBranch" {
            let embedVC = segue.destination as! BranchesFrameVC
            embedVC.delegate = self
        }else if segue.identifier == "toAdress" {
            let embedVC = segue.destination as! AddressFrameVC
            embedVC.delegate = self
        }else if segue.identifier == pickupModelSegue {
            let embedVC = segue.destination as! PickupModelFrameVC
            embedVC.delegate = self
        }
    }
    
    func setNIBs(){
        mTableView?.register(UINib(nibName: cartNib, bundle: frameworkBundle), forCellReuseIdentifier: cartNib)
    }
    
    func getCart(){
        totalPriceValue = 0
        if let carts = CoreDaTaHandler.getCarts() {
            self.list = carts
            mTableView.reloadData()
        }
        if self.list.isEmpty {
            if let image = UIImage(named: "empty-cart.png", in: frameworkBundle, with: .none){
                self.showEmptyView(on: self.mView, title: "empty_cart".getLocalizedValue(), mImage: image)
            }
        }else{
            list.forEach { (item) in
                //totalPriceValue += Double(item.quantity) * item.total_price
                totalPriceValue += Double(item.quantity) * (item.price_item + item.price_option + item.price_extra)
            }
            totalPrice.text = "\(Utilits.splitPrice(price: totalPriceValue)) \("pound".getLocalizedValue())"
        }
    }
    
    
    @IBAction func cashAction(_ sender: Any) {
        processingAction()
    }
    
    func processingAction(){
        if !isPickup && !isAddress{
            showToast(message: "address_pickup".getLocalizedValue(), controller: self)
            return
        }
        
        if isPickup && pickupType.isEmpty {
            showToast(message: "Please Choose pickup type", controller: self)
            return
        }
        
        let desVC = CheckOutFrameVC()
        desVC.modalPresentationStyle = .fullScreen
        if isPickup{
            desVC.isPickup = isPickup
            desVC.branch = branch
            desVC.carTypeValue = carTypeValue
            desVC.carColorValue = carColorValue
        }else if isAddress {
            desVC.isAddress = isAddress
            desVC.address = address
        }
        present(desVC, animated: true, completion: nil)
    }
    
    
    //////////// change price of menu //////////
    func getSelectedAreaID() -> String? {
        var mAreaId: String = ""
        if isAddress {
            guard let addressArea = address?.area else {
                return nil
            }
            guard let id = addressArea.id else {
                return nil
            }
            mAreaId = "\(id)"
        }else if isPickup {
            guard let branchArea = branch?.area else {
                return nil
            }
            guard let id = branchArea.id else {
                return nil
            }
            mAreaId = "\(id)"
        }
        return mAreaId
    }
    
    
    func getReasturants(){
        guard let areaID = getSelectedAreaID() else {
            return
        }
        showLoadingView(on: self.view)
        MenuAPI.reasturantChain(areaID: areaID, view: self.view) { (error, success, model) in
            self.hideLoadingView()
            if error != nil || !success {
                self.removeCart()
                return
            }
            guard let data = model?.data, let list = data.restaurants else {
                self.removeCart()
                return
            }
            self.checkIfResturantFound(chains: list)
            print("sssize \(list.count)")
            
        }
    }
    
    func checkIfResturantFound(chains: [Chain]){
        
        var isFound: Bool = false
        
        guard let selectedResID = Utilits.getSelectedReasturantID() else{
            self.removeCart()
            return
        }
        chains.forEach { (chain) in
            if let chainid = chain.id {
                if "\(chainid)" == selectedResID {
                    DefaultManager.saveReasrturantDefault(value: chain)
                    isFound = true
                }
            }
        }
        
        if isFound {
            checkIfReasturantOpen()
        }else{
            //Reasturant not found
            alertWithMessage(message: "resturant_not_found".getLocalizedValue())
        }
    }
    
    func checkIfReasturantOpen(){
        if Utilits.checkIsOpen() {
            getMenu()
        }else{
            //Reasturant closed
            alertWithMessage(message: "reasturant_close".getLocalizedValue())
        }
    }
    
    func getMenu(){
        
        var allItems: [Item] = []
        
        guard let selectedAreaID = getSelectedAreaID() else {
            return
        }
        
        showLoadingView(on: self.view)
        MenuAPI.menus(areaID: selectedAreaID, view: self.view) { (error, success, list) in
            self.hideLoadingView()
            if error != nil || !success {
                self.removeCart()
                return
            }
            guard let mList = list else {
                self.removeCart()
                return
            }
            if mList.isEmpty {
                self.removeCart()
                return
            }
            guard let sections = mList[0].sections else {
                return
            }
            sections.forEach { (section) in
                guard let sectionItems = section.items else {
                    return
                }
                sectionItems.forEach { (item) in
                    allItems.append(item)
                }
            }
            self.checkAreaOfCartItems(itemList: allItems)
            print("all items count is \(allItems.count)")
        }
    }
    
    func checkAreaOfCartItems(itemList: [Item]){
        if list.isEmpty || itemList.isEmpty {
            return
        }
        
        guard let selectedAreaID = getSelectedAreaID() else {
            return
        }
        
        list.forEach { (cart) in
            guard let cartAreaID = cart.area_id else {
                return
            }
            print("bbbbbbbbbbxxx \(selectedAreaID)   \(cartAreaID)")
            if selectedAreaID != cartAreaID {
                print("bbbbbbbbbb \(selectedAreaID)   \(cartAreaID)")
                updateItemWithNewPrice(cart: cart, itemList: itemList, selectedAreaID: selectedAreaID)
            }
        }
    }
    
    func updateItemWithNewPrice(cart: Cart, itemList: [Item], selectedAreaID: String){
        itemList.forEach { (item) in
            guard let itemInfo = item.info else {
                return
            }
            if itemInfo.isEmpty {
                return
            }
            
            itemInfo.forEach { (mInfo) in
                guard let itemId = mInfo.id else {
                    return
                }
                guard let cartItemID = cart.info_id, let cartDate = cart.mDate else {
                    return
                }
                
                print("bbbbbbbbbbvvv \(cartItemID)   \(itemId)")
                
                if cartItemID == "\(itemId)" {
                    
                    //getOptionPrice(cart: cart, item: item)
                    guard let sizePrice = getSizePrice(cart: cart, item: item) else{
                        if let mDate = cart.mDate {
                            if CoreDaTaHandler.deleteObject(id: mDate) {
                                print("haaave no price")
                            }
                        }
                        return
                    }
                    
                    if CoreDaTaHandler.updateCartPrice(mDate: cartDate, itemPrice: Int32(sizePrice), optionPrice: 0, extraPrice: 0, areaID: selectedAreaID, cart: cart){
                        alertWithMessage(message: "cart_change_area".getLocalizedValue())
                        getCart()
                    }
                }
            }
        }
    }
    
    func removeCart(){
        /*if CoreDaTaHandler.cleanData() {
         alertWithMessage(message: NSLocalizedString("cart_change_area", comment: ""))
         getCart()
         }*/
        
        isPickup = false
        isAddress = false
        
        self.branch = nil
        self.address = nil
    }
    
    func alertWithMessage(message: String){
        AlertManager.showWrongAlertWithMessage(on: self, message: message)
    }
    
    func getSizePrice(cart: Cart, item: Item) -> Double?{
        
        var sizePrice: Double = 0
        
        guard let info = item.info else{
            return nil
        }
        if info.isEmpty {
            return nil
        }
        guard let cartInfoId = cart.info_id else {
            return nil
        }
        
        info.forEach { (mInfo) in
            guard let itemInfo = mInfo.id else {
                return
            }
            print("nnnbnbnbnnb \(cartInfoId)    \(itemInfo)")
            if cartInfoId == "\(itemInfo)" {
                
                guard let infoPrice = Utilits.getPriceFromInfo(info: mInfo) else {
                    return
                }
                
                print("bbbbbbbbbbrr \(infoPrice)")
                sizePrice = Double(infoPrice)
            }
        }
        
        return sizePrice
    }
    
    func getOptionPrice(cart: Cart, item: Item){
        guard let cartOptionIDs = cart.options_ids else {
            return
        }
        if cartOptionIDs.isEmpty {
            return
        }
        let cartOptionIDsAsArray = cartOptionIDs.components(separatedBy: ",")
        
        if cartOptionIDsAsArray.isEmpty {
            return
        }
        
        cartOptionIDsAsArray.forEach { (option) in
            print("oooooooop \(option)")
        }
        
    }
}


extension CartFrameVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CartCell = mTableView.dequeueReusableCell(withIdentifier: cartNib, for: indexPath) as! CartCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.tag = indexPath.row
        if let title = list[indexPath.row].title {
            cell.itemName.text = title
        }
        if let desc = list[indexPath.row].desc {
            cell.detailsLabel.text = desc
        }
        if let mImage = list[indexPath.row].image {
            ImagesManager.setImage(url: mImage, image: cell.itemImage)
        }
        
        cell.quantityLabel.text = "\(list[indexPath.row].quantity)"
        //cell.calculatePrice(quantity: Int(list[indexPath.row].quantity), totalPrice: list[indexPath.row].total_price)
        cell.calculatePrice(item: list[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension CartFrameVC: CartDelegate {
    func plusQuantity(tag: Int) {
        if let mDate = list[tag].mDate{
            let quantity = list[tag].quantity + 1
            if CoreDaTaHandler.updateCart(mDate: mDate, quantity: quantity, cart: list[tag]) {
                getCart()
            }
        }
    }
    
    func minusQuantity(tag: Int) {
        if let mDate = list[tag].mDate{
            if list[tag].quantity == 1 {
                AlertManager.showFillDataWithMessage(on: self, message: "quatity_error".getLocalizedValue())
            }else{
                let quantity = list[tag].quantity - 1
                
                if CoreDaTaHandler.updateCart(mDate: mDate, quantity: quantity, cart: list[tag]) {
                    getCart()
                }
            }
        }
    }
    
    func deleteItem(tag: Int) {
        if let mDate = list[tag].mDate {
            if CoreDaTaHandler.deleteObject(id: mDate) {
                getCart()
            }else{
                AlertManager.showWrongAlert(on: self)
            }
        }
    }
    
    
}


extension CartFrameVC: BranchesDelegate {
    
    func passBranch(branch: Branch) {
        dismissContainerView()
        isPickup = true
        isAddress = false
        if APPLanguage() == Config.English {
            if let title = branch.nameEn {
                pickAddressValueBtn.setTitle(title, for: .normal)
            }
        }else{
            if let title = branch.nameAr {
                pickAddressValueBtn.setTitle(title, for: .normal)
            }
        }
        
        self.branch = branch
        
        
        let newVC = PickupModelFrameVC()
        newVC.modalPresentationStyle = .overCurrentContext
        newVC.delegate = self
        present(newVC, animated: true, completion: nil)
    }
    func dismissBranchDelegate() {
        dismissContainerView()
    }
}

extension CartFrameVC: AddressesDelegate {
    func passAddress(address: Address) {
        dismissContainerView()
        isPickup = false
        isAddress = true
        if APPLanguage() == Config.English {
            if let title = address.area?.areaNameEn {
                pickAddressValueBtn.setTitle(title, for: .normal)
            }
        }else{
            if let title = address.area?.areaNameAr {
                pickAddressValueBtn.setTitle(title, for: .normal)
            }
        }
        self.address = address
        
        //self.getMenu()
        self.getReasturants()
    }
    
    func dismissAddressDelegate() {
        dismissContainerView()
    }
}


extension CartFrameVC: PickupModelDelegate {
    func pickupCarData(modelType: String, type: String, color: String) {
        print("vvvvvvvv  \(modelType)    \(type)    \(color)")
        pickupType = modelType
        carTypeValue = type
        carColorValue = color
        dismiss(animated: false, completion: nil)
        
        //processingAction() //To CheckoutPage
        //getMenu()
        getReasturants()
    }
    
    func dismissPickupVC() {
        pickupType = ""
        carTypeValue = ""
        carColorValue = ""
        dismiss(animated: false, completion: nil)
    }
    
}
