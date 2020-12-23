//
//  DetailsFrameVC.swift
//  myRSDK
//
//  Created by Other Logic on 9/13/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit

struct SectionModel {
    var type: String = ""
    var row: Int = 0
    var isCollapsible: Bool = false
    var isCollapsed: Bool = false
    var name: String = ""
}

enum SectionType: String {
    case Image
    case Size
    case Extra
}

class DetailsFrameVC: UIViewController {

    @IBOutlet weak var mTableView: UITableView!
    
    var itemImageNib                = "ItemImageCell"
    let itemSizeNib                 = "ItemSizeCell"
    let itemExtraNib                = "ItemExtraCell"
    let itemOptionNib               = "ItemOptionCell"
    let quantityNib                 = "QuantityCell"
    let addCartNib                  = "AddCartCell"
    let specialNib                  = "ItemSpecialCell"
    let homeReusableViewID          = "TableSectionHeader"

    var item: ItemModel?
    var sections: [SectionModel] = []
    var info: [ItemInfo] = []
    var extraList: [ItemExtra] = []
    var optionList: [String: [ItemExtra]] = [:]
    
    let imageType: String = "Image"
    var sizeType: String = "size".getLocalizedValue()
    let extraType: String = "extra".getLocalizedValue()
    let specialType: String = "special"
    let quantityType: String = "quantity"
    let addCartType: String = "addCart"
    
    var infoImage: String = ""
    var itemID: String = "1"
    var specialRequestTxt: String = ""
    var isFavorite: Bool = false
    
    var reloadSections: ((_ section: Int) -> Void)?
    
    var selecedSize: Int = -1
    var optionSelected: [String: Int] = [:]
    var optionSelectedAsString: [String: String] = [:]
    var optionSelectedAsIds: [String: Int] = [:]
    var extraSelected: [Int] = []
    
    var sizePrice: Double = 0
    var extraPrice: Double = 0
    var optionPrice: [String: Double] = [:]
    var quantity: Int = 1
    var totalPrice: Double = 0
    var totalPriceOfOrder: Double = 0
    
    var extraIds: String = ""
    var infoId: String = ""
    var optionIds: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        
        setUI()
        setNIBs()
        getItem()
    }
    
    public init() {
        super.init(nibName: "DetailsFrameVC", bundle: Bundle(for: DetailsFrameVC.self))
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
    
    func setNIBs(){
        mTableView?.register(UINib(nibName: itemImageNib, bundle: frameworkBundle), forCellReuseIdentifier: itemImageNib)
        mTableView?.register(UINib(nibName: itemSizeNib, bundle: frameworkBundle), forCellReuseIdentifier: itemSizeNib)
        mTableView?.register(UINib(nibName: itemExtraNib, bundle: frameworkBundle), forCellReuseIdentifier: itemExtraNib)
        mTableView?.register(UINib(nibName: itemOptionNib, bundle: frameworkBundle), forCellReuseIdentifier: itemOptionNib)
        mTableView?.register(UINib(nibName: quantityNib, bundle: frameworkBundle), forCellReuseIdentifier: quantityNib)
        mTableView?.register(UINib(nibName: specialNib, bundle: frameworkBundle), forCellReuseIdentifier: specialNib)
        mTableView?.register(UINib(nibName: addCartNib, bundle: frameworkBundle), forCellReuseIdentifier: addCartNib)
        mTableView.register(UINib(nibName: homeReusableViewID, bundle: frameworkBundle), forHeaderFooterViewReuseIdentifier: homeReusableViewID)
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
                    /*if let price = info[0].priceEn {
                        self.totalPrice = Double(price)!
                    }*/
                    if let price = Utilits.getPriceFromInfo(info: info) {
                        print("nnnnncccc \(price)")
                        self.totalPrice = Double(price)
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
            self.sections.append(SectionModel(type: self.imageType, row: 1, isCollapsible: false, isCollapsed: false, name: self.imageType))
            
            
            //For sizes
            if let infoList = model?.info {
                self.info = infoList
                self.sections.append(SectionModel(type: self.sizeType, row: self.info.count, isCollapsible: true, isCollapsed: false, name: self.sizeType))
            }
            
            //For item extra
            if let extras = model?.itemExtras {
                if !extras.isEmpty {
                    guard let data = extras[0].data else {
                        return
                    }
                    self.extraList = data
                    self.sections.append(SectionModel(type: self.extraType, row: data.count, isCollapsible: true, isCollapsed: false, name: self.extraType))
                }
            }
            
            // For Special Request
            self.sections.append(SectionModel(type: self.specialType, row: 1, isCollapsible: false, isCollapsed: false, name: self.specialType))
            
            // For Quantity
            self.sections.append(SectionModel(type: self.quantityType, row: 1, isCollapsible: false, isCollapsed: false, name: self.quantityType))
            
            // For Add cart Button
            self.sections.append(SectionModel(type: self.addCartType, row: 1, isCollapsible: false, isCollapsed: false, name: self.addCartType))
            
            
            if self.info.count == 1 {
                self.reloadSizeSections(indexPath: IndexPath(row: 0, section: 1))
            }else{
                self.mTableView?.reloadData()
            }
        }
    }

}



extension DetailsFrameVC: UITableViewDataSource, UITableViewDelegate {
    
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
            cell.delegate = self
            if self.item != nil {
                cell.setItemInfo(item: self.item!, mImage: self.infoImage, isFavorite: isFavorite)
            }
            return cell
        case sizeType:
            let cell: ItemSizeCell = mTableView.dequeueReusableCell(withIdentifier: itemSizeNib, for: indexPath) as! ItemSizeCell
            cell.selectionStyle = .none
            if APPLanguage() == Config.English {
                if let name = info[indexPath.row].sizeEn {
                    cell.sizeLabel.text = name
                }
            }else{
                if let name = info[indexPath.row].sizeAr {
                    cell.sizeLabel.text = name
                }
            }
            
            if let price = Utilits.getPriceFromInfo(info: info) {
                if price != 0 {
                    cell.setPrice(price: "\(price)")
                }else{
                    cell.priceLabel.text = ""
                }
            }else{
                cell.priceLabel.text = ""
            }
            
            /*if let price = info[indexPath.row].priceEn {
                if price != "0" {
                    cell.setPrice(price: price)
                }else{
                    cell.priceLabel.text = ""
                }
            }*/
            if indexPath.row == selecedSize {
                if let image = UIImage(named: "radio-full", in: frameworkBundle, with: .none){
                    cell.mImage.image = image
                }
               
            }else{
                if let image = UIImage(named: "radio-empty", in: frameworkBundle, with: .none){
                    cell.mImage.image = image
                }
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
            //cell.priceLabel.text = "\(Utilits.splitPrice(price: totalPrice)) \(NSLocalizedString("pound", comment: ""))"
            return cell
        default:
            let list: [ItemExtra] = self.optionList[item.type]!
            let cell: ItemOptionCell = mTableView.dequeueReusableCell(withIdentifier: itemOptionNib, for: indexPath) as! ItemOptionCell
            cell.selectionStyle = .none
            if APPLanguage() == Config.English {
                if let title = list[indexPath.row].nameEn {
                    cell.optionLabel.text = title
                }
            }else{
                if let title = list[indexPath.row].nameAr {
                    cell.optionLabel.text = title
                }
            }
            
            if let price = list[indexPath.row].priceEn {
                if price != "0" {
                    cell.setPrice(price: price)
                }else{
                    cell.priceLabel.text = ""
                }
            }
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
            
        case sizeType:
            self.mTableView.reloadData()
            reloadSizeSections(indexPath: indexPath)
            break
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
        }
    }
    
    func reloadSizeSections(indexPath: IndexPath){
        
        //Get price of size
        if let price = Utilits.getPriceFromInfo(info: info, size: indexPath.row) {
            sizePrice = Double(price)
        }
        /*if let price = info[indexPath.row].priceEn {
            sizePrice = Double(price)!
            print("Price of size \(sizePrice)")
        }*/
        
        //Delete option price
        optionPrice.removeAll()
        
        //Reload option list
        optionSelected.removeAll()
        optionSelectedAsString.removeAll()
        optionSelectedAsIds.removeAll()
        
        self.sections.removeAll()
        self.optionList.removeAll()
        
        
        self.sections.append(SectionModel(type: self.imageType, row: 1, isCollapsible: false, isCollapsed: false, name: self.imageType))
        
        //Write size in header
        if APPLanguage() == Config.English {
            self.sizeType = "Size ( \(self.info[indexPath.row].sizeEn ?? "") ) "
        }else{
            self.sizeType = "الحجم ( \(self.info[indexPath.row].sizeAr ?? "") ) "
        }
        
        //Get image of size
        if let mImage = self.info[indexPath.row].image {
            self.infoImage = mImage
        }
        
        //Make all sizes unslected
        self.selecedSize = -1
        
        self.sections.append(SectionModel(type: self.sizeType, row: self.info.count, isCollapsible: true, isCollapsed: true, name: self.sizeType))
        
        //Set radio button full in size
        self.selecedSize = indexPath.row
        
        //Get all sizes
        if let extras = info[indexPath.row].itemExtras {
            extras.forEach { (option) in
                guard let dataList = option.data else {
                    return
                }
                if APPLanguage() == Config.English {
                    guard let title = option.categoryEn else {
                        return
                    }
                    self.optionList[title] = dataList
                    self.sections.append(SectionModel(type: title, row: dataList.count, isCollapsible: true, isCollapsed: false, name: title))
                }else{
                    guard let title = option.categoryAr else {
                        return
                    }
                    self.optionList[title] = dataList
                    self.sections.append(SectionModel(type: title, row: dataList.count, isCollapsible: true, isCollapsed: false, name: title))
                }
            }
        }
        
        if !self.extraList.isEmpty {
            self.sections.append(SectionModel(type: self.extraType, row: self.extraList.count, isCollapsible: true, isCollapsed: false, name: self.extraType))
        }
        
        // For Special Request
        self.sections.append(SectionModel(type: self.specialType, row: 1, isCollapsible: false, isCollapsed: false, name: self.specialType))
        
        // For Quantity
        self.sections.append(SectionModel(type: self.quantityType, row: 1, isCollapsible: false, isCollapsed: false, name: self.quantityType))
        
        // For Add cart Button
        self.sections.append(SectionModel(type: self.addCartType, row: 1, isCollapsible: false, isCollapsed: false, name: self.addCartType))
        
        
        updatePriceWithNoReload()
        self.mTableView.reloadData()
    }
    
    
    func reloadOptionSections(indexPath: IndexPath){
        let item = sections[indexPath.section]
        if item.isCollapsible {
            
            let collapsed = !item.isCollapsed
            sections[indexPath.section].isCollapsed = collapsed
            
            let list: [ItemExtra] = self.optionList[item.type]!
            if APPLanguage() == Config.English {
                if let title = list[indexPath.row].nameEn, let id = list[indexPath.row].id {
                    optionSelected[item.type] = indexPath.row
                    optionSelectedAsString[item.type] = title
                    optionSelectedAsIds[item.type] = id
                    sections[indexPath.section].name = "\(item.type) ( \(title) )"
                }
            }else{
                if let title = list[indexPath.row].nameAr, let id = list[indexPath.row].id {
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
            //self.mTableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
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
    
    func updatePriceWithNoReload(){
        totalPrice = sizePrice + extraPrice
        for (_, price) in optionPrice {
            totalPrice += price
            totalPriceOfOrder += price
        }
        
        totalPrice = Double(quantity) * totalPrice
    }
    
    func updatePrice(){
        totalPrice = sizePrice + extraPrice
        for (_, price) in optionPrice {
            totalPrice += price
            totalPriceOfOrder += price
        }
        totalPrice = Double(quantity) * totalPrice
        for (index, item) in sections.enumerated() {
            if item.type == addCartType {
                self.mTableView.beginUpdates()
                self.mTableView.reloadSections([index], with: .none)
                self.mTableView.endUpdates()
            }
        }
    }
    
    func updatePrice(section: Int){
        totalPrice = sizePrice + extraPrice
        for (_, price) in optionPrice {
            totalPrice += price
            totalPriceOfOrder += price
        }
        totalPrice = Double(quantity) * totalPrice
        for (index, item) in sections.enumerated() {
            if item.type == addCartType {
                self.mTableView.beginUpdates()
                self.mTableView.reloadSections([index, section], with: .none)
                self.mTableView.endUpdates()
            }
        }
    }
    
}


extension DetailsFrameVC: HeaderViewDelegate {
    func toggleSection(header: TableSectionHeader, section: Int) {
        let item = sections[section]
        if item.isCollapsible {
            
            let collapsed = !item.isCollapsed
            sections[section].isCollapsed = collapsed
            
            //self.mTableView.reloadSections(IndexSet(integer: section), with: .automatic)
            
            self.mTableView.beginUpdates()
            self.mTableView.reloadSections([section], with: .fade)
            self.mTableView.endUpdates()
            
            //header.setCollapsed(collapsed: collapsed)
        }
    }
}


extension DetailsFrameVC: QuantityDelegate {
    func quantityFun(quantity: Int) {
        self.quantity = quantity
        updatePrice()
        print("Quantity is \(quantity)")
    }
    
    func errorMessage(message: String) {
        AlertManager.showWrongAlertWithMessage(on: self, message: message)
    }
}

extension DetailsFrameVC: ItemImageDelegate {
    
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


extension DetailsFrameVC: AddCartDelegate {
    func cartClicked() {
        
        
        var image: String = ""
        
        if item == nil {
            AlertManager.showWrongAlert(on: self)
            return
        }
        
        guard let itemID = item?.id else {
            AlertManager.showWrongAlert(on: self)
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
        
        if selecedSize == -1 {
            AlertManager.showFillDataWithMessage(on: self, message: "size_requried".getLocalizedValue())
            return
        }
        
        if optionList.count != optionSelected.count {
            AlertManager.showFillDataWithMessage(on: self, message: "option_required".getLocalizedValue())
            return
        }
        
        var detailsOfOrder: String = ""
        if APPLanguage() == Config.English {
            if let sizeOfOrder = self.info[selecedSize].sizeEn {
                detailsOfOrder = sizeOfOrder
            }
        }else{
            if let sizeOfOrder = self.info[selecedSize].sizeAr {
                detailsOfOrder = sizeOfOrder
            }
        }
        
        if !optionList.isEmpty {
            optionSelectedAsString.forEach { (key, value) in
                detailsOfOrder += ", \(value)"
            }
        }
        
        if !extraSelected.isEmpty {
            for index in extraSelected {
                if APPLanguage() == Config.English {
                    if let title = extraList[index].nameEn {
                        detailsOfOrder += ", \(title)"
                    }
                }else{
                    if let title = extraList[index].nameAr {
                        detailsOfOrder += ", \(title)"
                    }
                }
            }
        }
        let singlePrice: Double = totalPrice / Double(quantity)
        
        getInfoID()
        getOptionsIds()
        getExtrsIDs()
        
        print("idds extra \(extraIds)")
        print("idds info \(infoId)")
        print("idds options \(optionIds)")
        
        var isCouponOffer: Bool = false
        if let offer = item?.offer {
            if offer == "1" {
                isCouponOffer = true
            }else{
                isCouponOffer = false
            }
        }
        
        var mOptionsPrice: Double = 0
        for (_, price) in optionPrice {
            mOptionsPrice += price
            print("mmmmmnnnnn \(price)")
        }
        
        guard let areaID = Utilits.getSelectedAreaID(), let resID = Utilits.getSelectedReasturantID() else {
            return
        }
        
        print("cart data \(itemID)   \(image)   \(title)   \(detailsOfOrder)   \(quantity)    \(singlePrice)    \(infoId)    \(optionIds)    \(extraIds)   \(isCouponOffer)")
        
        
        print("print price   \(sizePrice)    \(mOptionsPrice)    \(extraPrice)")
        
        if CoreDaTaHandler.saveCart(areaID: areaID, resID: resID, itemID: "\(itemID)", image: image, title: title, specialRequest: specialRequestTxt, desc: detailsOfOrder, quantity: Int32(quantity), itemPrice: sizePrice, optionPrice: mOptionsPrice, extraPrice: extraPrice ,totalPrice: singlePrice, infoId: infoId, optionsIds: optionIds, extraIds: extraIds, offer: false, couponOffer: isCouponOffer , mDate: Utilits.currentDateTime()) {
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
        if let infoId = info[selecedSize].id {
            self.infoId = "\(infoId)"
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

extension DetailsFrameVC: SpecialDelegate {
    func passSpecialText(text: String) {
        self.specialRequestTxt = text
    }
}

