//
//  OrderOfferFrameVC.swift
//  myRSDK
//
//  Created by Other Logic on 9/29/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit

struct OfferSectionModel {
    var type: String = ""
    var row: Int = 0
    var isCollapsible: Bool = false
    var isCollapsed: Bool = false
    var name: String = ""
}

class OrderOfferFrameVC: UIViewController {
    
    @IBOutlet weak var mTableView: UITableView!
    
    var itemImageNib                = "ItemImageCell"
    let itemSizeNib                 = "ItemSizeCell"
    let itemExtraNib                = "ItemExtraCell"
    let itemOptionNib               = "ItemOptionCell"
    let quantityNib                 = "QuantityCell"
    let addCartNib                  = "AddCartCell"
    let specialNib                  = "ItemSpecialCell"
    let homeReusableViewID          = "TableSectionHeader"
    
    var infoImage: String           = ""
    var itemID: String              = ""
    var specialRequestTxt: String   = ""
    var isFavorite: Bool            = false
    
    var item: ItemModel?
    var sections: [OfferSectionModel] = []
    var extraList: [ItemExtra] = []
    var optionList: [String: [ChoicesInfo]] = [:]
    
    let imageType: String = "Image"
    let extraType: String = "extra".getLocalizedValue()
    let specialType: String = "special"
    let quantityType: String = "quantity"
    let addCartType: String = "addCart"
    
    var extraIds: String = ""
    var infoId: String = ""
    var optionIds: String = ""
    
    var extraPrice: Double = 0
    var optionPrice: [String: Double] = [:]
    var quantity: Int = 1
    var totalPrice: Double = 0
    var offerPrice: Double = 0
    var totalPriceOfOrder: Double = 0
    
    var optionSelected: [String: Int] = [:]
    var optionSelectedAsString: [String: String] = [:]
    var optionSelectedAsIds: [String: Int] = [:]
    var extraSelected: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setNIBs()
        getItem()
    }
    
    public init() {
        super.init(nibName: "OrderOfferFrameVC", bundle: Bundle(for: OrderOfferFrameVC.self))
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
        hideKeyboardWhenTappedAround()
        
        let footerView = UIView()
        footerView.backgroundColor = .white
        footerView.alpha = 0.3
        mTableView.tableFooterView = footerView
        
        mTableView.contentInset.top = -UIApplication.shared.statusBarFrame.height
        mTableView.separatorStyle = .none
        mTableView.rowHeight = UITableView.automaticDimension
        mTableView.estimatedRowHeight = 250
    }
    
    func setNIBs(){
        mTableView?.register(UINib(nibName: itemImageNib, bundle: frameworkBundle), forCellReuseIdentifier: itemImageNib)
        mTableView?.register(UINib(nibName: itemExtraNib, bundle: frameworkBundle), forCellReuseIdentifier: itemExtraNib)
        mTableView?.register(UINib(nibName: itemOptionNib, bundle: frameworkBundle), forCellReuseIdentifier: itemOptionNib)
        mTableView?.register(UINib(nibName: quantityNib, bundle: frameworkBundle), forCellReuseIdentifier: quantityNib)
        mTableView?.register(UINib(nibName: specialNib, bundle: frameworkBundle), forCellReuseIdentifier: specialNib)
        mTableView?.register(UINib(nibName: addCartNib, bundle: frameworkBundle), forCellReuseIdentifier: addCartNib)
        mTableView.register(UINib(nibName: homeReusableViewID, bundle: frameworkBundle), forHeaderFooterViewReuseIdentifier: homeReusableViewID)
    }
    
    func getItem(){
        guard let priceList = DefaultManager.getAreaPriceListDefault() else {
            return
        }
        showLoadingView(on: self.view)
        MenuAPI.item(itemID: itemID, priceList: priceList, view: self.view) { (error, success, model) in
            self.hideLoadingView()
            if error != nil || !success {
                return
            }
            
            //Set first price
            self.item = model!
            if let info = self.item?.info {
                if !info.isEmpty {
                    if let price = info[0].priceEn {
                        self.totalPrice = Double(price)!
                        self.offerPrice = Double(price)!
                    }
                }
            }
            
            if let fav = self.item?.favorite {
                self.isFavorite = fav
            }
            
            //Image
            if let mImage = self.item?.image {
                self.infoImage = mImage
            }
            
            // For image and data
            self.sections.append(OfferSectionModel(type: self.imageType, row: 1, isCollapsible: false, isCollapsed: false, name: self.imageType))
            
            
            //For options
            var i: Int = 0
            if let relatedList = self.item?.related {
                relatedList.forEach({ (item) in
                    i += 1
                    let title = "\("option_choose".getLocalizedValue()) \(i)"
                    guard let choices = item.choices else {
                        return
                    }
                    self.optionList[title] = choices
                    self.sections.append(OfferSectionModel(type: title, row: choices.count, isCollapsible: true, isCollapsed: false, name: title))
                })
            }
            
            //For item extra
            if let extras = model?.itemExtras {
                if !extras.isEmpty {
                    guard let data = extras[0].data else {
                        return
                    }
                    self.extraList = data
                    self.sections.append(OfferSectionModel(type: self.extraType, row: data.count, isCollapsible: true, isCollapsed: false, name: self.extraType))
                }
            }
            
            // For Special Request
            self.sections.append(OfferSectionModel(type: self.specialType, row: 1, isCollapsible: false, isCollapsed: false, name: self.specialType))
            
            // For Quantity
            self.sections.append(OfferSectionModel(type: self.quantityType, row: 1, isCollapsible: false, isCollapsed: false, name: self.quantityType))
            
            // For Add cart Button
            self.sections.append(OfferSectionModel(type: self.addCartType, row: 1, isCollapsible: false, isCollapsed: false, name: self.addCartType))
            
            
            self.mTableView?.reloadData()
        }
    }
}


extension OrderOfferFrameVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return sections[section].row
        
        let item = sections[section]
        if item.isCollapsible && item.isCollapsed {
            return 0
        }
        return item.row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section]
        print("section is \(item.type) \(indexPath.section)")
        switch item.type {
        case imageType:
            
            let cell: ItemImageCell = mTableView.dequeueReusableCell(withIdentifier: itemImageNib, for: indexPath) as! ItemImageCell
            cell.selectionStyle = .none
            cell.favImage.isHidden = true
            cell.delegate = self
            if self.item != nil {
                cell.setItemInfo(item: self.item!, mImage: self.infoImage, isFavorite: isFavorite)
            }
            return cell
        case extraType:
            let cell: ItemExtraCell = mTableView.dequeueReusableCell(withIdentifier: itemExtraNib, for: indexPath) as! ItemExtraCell
            cell.selectionStyle = .none
            if APPLanguage() == Config.English {
                if let name = extraList[indexPath.row].nameEn {
                    cell.extraLabel.text = name
                }
            }else{
                if let name = extraList[indexPath.row].nameAr {
                    cell.extraLabel.text = name
                }
            }
            
            if let price = extraList[indexPath.row].priceEn {
                if price != "0" {
                    cell.setPrice(price: price)
                }else{
                    cell.priceLabel.text = ""
                }
            }
            if extraSelected.contains(indexPath.row) {
                if let image = UIImage(named: "check-full", in: frameworkBundle, with: .none){
                    cell.mImage.image = image
                }
            }else{
                if let image = UIImage(named: "check-empty", in: frameworkBundle, with: .none){
                    cell.mImage.image = image
                }
            }
            return cell
            
        case specialType:
            let cell: ItemSpecialCell = mTableView.dequeueReusableCell(withIdentifier: specialNib, for: indexPath) as! ItemSpecialCell
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
            
        case quantityType:
            let cell: QuantityCell = mTableView.dequeueReusableCell(withIdentifier: quantityNib, for: indexPath) as! QuantityCell
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
            
        case addCartType:
            let cell: AddCartCell = mTableView.dequeueReusableCell(withIdentifier: addCartNib, for: indexPath) as! AddCartCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.setPrice(totalPrice: totalPrice)
            return cell
        default:
            let list: [ChoicesInfo] = self.optionList[item.type]!
            let cell: ItemOptionCell = mTableView.dequeueReusableCell(withIdentifier: itemOptionNib, for: indexPath) as! ItemOptionCell
            cell.selectionStyle = .none
            if let itemName = list[indexPath.row].itemName {
                if APPLanguage() == Config.English {
                    if let title = itemName.nameEn {
                        cell.optionLabel.text = title
                    }
                }else{
                    if let title = itemName.nameAr {
                        cell.optionLabel.text = title
                    }
                }
            }
            /*if let price = list[indexPath.row].priceEn {
             if price != "0" {
             cell.priceLabel.text = "\(price) L.E."
             }else{
             cell.priceLabel.text = ""
             }
             }*/
            if !optionSelected.isEmpty {
                if optionSelected[item.type] == indexPath.row {
                    if let image = UIImage(named: "radio-full", in: frameworkBundle, with: .none){
                        cell.mImage.image = image
                    }
                }else{
                    if let image = UIImage(named: "radio-empty", in: frameworkBundle, with: .none){
                        cell.mImage.image = image
                    }
                }
            }else{
                if let image = UIImage(named: "radio-empty", in: frameworkBundle, with: .none){
                    cell.mImage.image = image
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = self.mTableView.dequeueReusableHeaderFooterView(withIdentifier: homeReusableViewID)
        let header = cell as! TableSectionHeader
        header.titleLabel?.text = sections[section].name
        header.section = section
        header.delegate = self
        header.setCollapsed(collapsed: sections[section].isCollapsed)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = AppColorsManager.grayColor
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let item = sections[section]
        switch item.type {
        case imageType:
            return 0
        case quantityType:
            return 0
        case specialType:
            return 0
        case addCartType:
            return 0
        default:
            return 65
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let item = sections[section]
        switch item.type {
        case imageType:
            return 0
        case quantityType:
            return 25
        case specialType:
            return 20
        default:
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch sections[indexPath.section].type {
            
        case extraType:
            extraSection(tableView, indexPath: indexPath)
            break
        case quantityType:
            //Quantity selected
            break
        case specialType:
            //Quantity selected
            break
        default:
            reloadOptionSections(indexPath: indexPath)
            break
        }
    }
    
    func reloadOptionSections(indexPath: IndexPath){
        
        let item = sections[indexPath.section]
        if item.isCollapsible {
            
            let collapsed = !item.isCollapsed
            sections[indexPath.section].isCollapsed = collapsed
            
            let list: [ChoicesInfo] = self.optionList[item.type]!
            if let itemName = list[indexPath.row].itemName, let id = list[indexPath.row].id {
                if APPLanguage() == Config.English {
                    guard let title = itemName.nameEn else {
                        return
                    }
                    optionSelected[item.type] = indexPath.row
                    optionSelectedAsString[item.type] = title
                    optionSelectedAsIds[item.type] = id
                    sections[indexPath.section].name = "\(item.type) ( \(title) )"
                }else{
                    guard let title = itemName.nameAr else {
                        return
                    }
                    optionSelected[item.type] = indexPath.row
                    optionSelectedAsString[item.type] = title
                    optionSelectedAsIds[item.type] = id
                    sections[indexPath.section].name = "\(item.type) ( \(title) )"
                }
                
            }
            
            if let price = list[indexPath.row].priceEn {
                optionPrice[item.type] = Double(price)!
            }
            
            for (index, type) in optionPrice.enumerated() {
                print("price of option \(index)   \(type)")
            }
            updatePrice(section: indexPath.section)
        }
    }
    
    
    func extraSection(_ tableView: UITableView, indexPath: IndexPath){
        let cell:ItemExtraCell = tableView.cellForRow(at: indexPath) as! ItemExtraCell
        
        if let price = extraList[indexPath.row].priceEn {
            if let index = extraSelected.firstIndex(of: indexPath.row) {
                extraSelected.remove(at: index)
                extraPrice = extraPrice - Double(price)!
                if let image = UIImage(named: "check-empty", in: frameworkBundle, with: .none){
                    cell.mImage.image = image
                }
            }else{
                extraSelected.append(indexPath.row)
                extraPrice = extraPrice + Double(price)!
                if let image = UIImage(named: "check-full", in: frameworkBundle, with: .none){
                    cell.mImage.image = image
                }
            }
            updatePrice()
            print("Price of extra \(extraPrice)")
        }
    }
    
    func updatePrice(section: Int){
        totalPrice = offerPrice + extraPrice
        /*for (_, price) in optionPrice {
         totalPrice += price
         totalPriceOfOrder += price
         }*/
        totalPrice = Double(quantity) * totalPrice
        for (index, item) in sections.enumerated() {
            if item.type == addCartType {
                self.mTableView.beginUpdates()
                self.mTableView.reloadSections([index, section], with: .none)
                self.mTableView.endUpdates()
            }
        }
    }
    
    func updatePrice(){
        totalPrice = offerPrice + extraPrice
        /*for (_, price) in optionPrice {
         totalPrice += price
         totalPriceOfOrder += price
         }*/
        totalPrice = Double(quantity) * totalPrice
        for (index, item) in sections.enumerated() {
            if item.type == addCartType {
                self.mTableView.beginUpdates()
                self.mTableView.reloadSections([index], with: .none)
                self.mTableView.endUpdates()
            }
        }
    }
    
}



extension OrderOfferFrameVC: HeaderViewDelegate {
    func toggleSection(header: TableSectionHeader, section: Int) {
        let item = sections[section]
        if item.isCollapsible {
            
            let collapsed = !item.isCollapsed
            sections[section].isCollapsed = collapsed
            
            self.mTableView.beginUpdates()
            self.mTableView.reloadSections([section], with: .fade)
            self.mTableView.endUpdates()
            
        }
    }
}

extension OrderOfferFrameVC: ItemImageDelegate {
    
    func favoriteAction() {
        
        guard let token = DefaultManager.getUserToken() else {
            NavigationManager.toLoginDismiss(self)
            return
        }
        
        MenuAPI.favorite(isFav: isFavorite, itemID: itemID, api_token: token, view: self.view) { (error, success) in
            if error != nil || !success{
                AlertManager.showWrongAlert(on: self)
                return
            }
            self.isFavorite = !self.isFavorite
            self.mTableView.reloadSections(IndexSet(integer: 0), with: .none)
            print("succcessssssss")
        }
    }
    
    func dismissItem() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func shareAction() {
        guard let title = item?.nameEn else {
            return
        }
        
        GCSocialShare.shared.socialShare(sender: self, sView: self.view, sharingText: "\(title)\n", sharingImage: ImagesManager.downloadImage(url: self.infoImage), sharingURL: URL(string: PREGO_WEBISTE))
    }
}

extension OrderOfferFrameVC: QuantityDelegate {
    func quantityFun(quantity: Int) {
        self.quantity = quantity
        updatePrice()
        print("Quantity is \(quantity)")
    }
    
    func errorMessage(message: String) {
        AlertManager.showWrongAlertWithMessage(on: self, message: message)
    }
}

extension OrderOfferFrameVC: SpecialDelegate {
    func passSpecialText(text: String) {
        self.specialRequestTxt = text
    }
}

extension OrderOfferFrameVC: AddCartDelegate {
    func cartClicked() {
        
        var image: String = ""
        
        if item == nil {
            AlertManager.showWrongAlert(on: self)
            return
        }
        
        guard let itemInfo = item?.info else {
            AlertManager.showWrongAlert(on: self)
            return
        }
        if itemInfo.isEmpty {
            return
        }
        
        guard let itemID = itemInfo[0].id else {
            return
        }
        
        if let mImage = item?.image {
            image = mImage
        }
        
        var title: String = ""
        if APPLanguage() == Config.English {
            guard let mTitle = item?.nameEn else {
                AlertManager.showWrongAlert(on: self)
                return
            }
            title = mTitle
        }else{
            guard let mTitle = item?.nameAr else {
                AlertManager.showWrongAlert(on: self)
                return
            }
            title = mTitle
        }
        
        
        if totalPrice == 0 {
            AlertManager.showWrongAlertWithMessage(on: self, message: "price_error".getLocalizedValue())
            return
        }
        
        if optionList.count != optionSelected.count {
            AlertManager.showFillDataWithMessage(on: self, message: "option_required".getLocalizedValue())
            return
        }
        
        var detailsOfOrder: String = ""
        if !optionList.isEmpty {
            optionSelectedAsString.forEach { (key, value) in
                detailsOfOrder += "\(value), "
            }
        }
        
        if !extraSelected.isEmpty {
            for index in extraSelected {
                if let title = extraList[index].nameEn {
                    detailsOfOrder += ", \(title)"
                }
            }
        }
        let singlePrice: Double = totalPrice / Double(quantity)
        
        getInfoID()
        getOptionsIds()
        getExtrsIDs()
        
        var isCouponOffer: Bool = false
        if let offer = item?.offer {
            if offer == "1" {
                isCouponOffer = true
            }else{
                isCouponOffer = false
            }
        }
        
        print("idds extra \(extraIds)")
        print("idds info \(infoId)")
        print("idds options \(optionIds)")
        print("idds itemID  \(itemID)")
        print("idds image  \(image)")
        print("idds title \(title)")
        print("idds specialRequestTxt  \(specialRequestTxt)")
        print("idds detailsOfOrder  \(detailsOfOrder)")
        print("idds quantity  \(quantity)")
        print("idds singlePrice  \(singlePrice)")
        print("idds isCouponOffer  \(isCouponOffer)")
        print("idds time  \(Utilits.currentDateTime())")
        
        if CoreDaTaHandler.saveCart(itemID: "\(itemID)", image: image, title: title, specialRequest: specialRequestTxt, desc: detailsOfOrder, quantity: Int32(quantity), totalPrice: singlePrice, infoId: infoId, optionsIds: optionIds, extraIds: extraIds, offer: true, couponOffer: isCouponOffer , mDate: Utilits.currentDateTime()) {
            print("Saved")
            showToast(message: "order_success".getLocalizedValue(), controller: self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func getOptionsIds(){
        
        optionIds = ""
        if !optionSelectedAsIds.isEmpty {
            optionSelectedAsIds.forEach { (key, value) in
                if optionSelectedAsIds.count == 1 {
                    optionIds += "\(value)"
                }else{
                    optionIds += "\(value),"
                }
            }
            if optionSelectedAsIds.count > 1 {
                optionIds.removeLast()
            }
        }
    }
    
    func getInfoID(){
        infoId = ""
        if let info = item?.info {
            if !info.isEmpty {
                if let id = info[0].id {
                    self.infoId = "\(id)"
                }
            }
        }
    }
    
    func getExtrsIDs(){
        extraIds = ""
        if !extraSelected.isEmpty {
            extraSelected.forEach { (index) in
                if let id = extraList[index].id {
                    if extraSelected.count == 1 {
                        extraIds += "\(id)"
                    }else{
                        extraIds += "\(id),"
                    }
                }
            }
            
            if extraSelected.count > 1 {
                extraIds.removeLast()
            }
        }
    }
}
