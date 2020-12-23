//
//  OffersFrameVC.swift
//  myRSDK
//
//  Created by Other Logic on 9/10/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit

class OffersFrameVC: UIViewController {

    @IBOutlet weak var mCollection: UICollectionView!
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var bagView: UIView!
    
    let nibCellName: String = "HomeFoodsCell"
    var list: [Offer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !Connectivity.isConnectedToInternet {
            showInternetFailed(view: self.mView)
            return
        }
        
        registerCollectionView()
        getMenu()
    }
    
    public init() {
        super.init(nibName: "OffersFrameVC", bundle: Bundle(for: OffersFrameVC.self))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        setupBagView(bagView: bagView)
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func registerCollectionView(){
        
        mCollection.register(UINib(nibName: nibCellName, bundle: frameworkBundle), forCellWithReuseIdentifier: nibCellName)
    }
    
    func getMenu(){
        
        guard let areaID = Utilits.getSelectedAreaID() else {
            return
        }
        showLoadingView(on: self.view)
        MenuAPI.menus(areaID: areaID, view: self.view) { (error, success, list) in
            self.hideLoadingView()
            if error != nil || !success {
                return
            }
            guard let mList = list else {
                return
            }
            if mList.isEmpty {
                return
            }
            guard let menuID = mList[0].id else {
                return
            }
            self.loadOffers(menuID: "\(menuID)")
        }
    }
    
    func loadOffers(menuID: String){
       
        self.list.removeAll()
        
        guard let priceList = DefaultManager.getAreaPriceListDefault() else {
            return
        }
        
        showLoadingView(on: mView)
        MenuAPI.offers(menuID: menuID, priceList: priceList, view: self.view) { (error, success, model) in
            self.hideLoadingView()
            if error != nil || !success {
                if let image = UIImage(named: "empty-offer.png", in: frameworkBundle, with: .none){
                    self.showEmptyView(on: self.mView, title: "empty_offers".getLocalizedValue(), mImage: image)
                }
                
                return
            }
            guard let data = model?.data else {
                if let image = UIImage(named: "empty-offer.png", in: frameworkBundle, with: .none){
                    self.showEmptyView(on: self.mView, title: "empty_offers".getLocalizedValue(), mImage: image)
                }
                return
            }
            guard let list = data.offers else {
                if let image = UIImage(named: "empty-offer.png", in: frameworkBundle, with: .none){
                    self.showEmptyView(on: self.mView, title: "empty_offers".getLocalizedValue(), mImage: image)
                }
                return
            }
            if list.isEmpty {
                if let image = UIImage(named: "empty-offer.png", in: frameworkBundle, with: .none){
                    self.showEmptyView(on: self.mView, title: "empty_offers".getLocalizedValue(), mImage: image)
                }
                return
            }
            list.forEach({ (offer) in
                guard let info = offer.info else {
                    return
                }
                if !info.isEmpty {
                    self.list.append(offer)
                }
            })
            //self.list = list
            self.mCollection.reloadData()
        }
    }

}



extension OffersFrameVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:HomeFoodsCell = collectionView.dequeueReusableCell(withReuseIdentifier: nibCellName, for: indexPath) as! HomeFoodsCell
        cell.shadowAndBorderForCell(cell: cell, radius: 6)
        
        let item = list[indexPath.row]
        if APPLanguage() == Config.English {
            if let name = item.nameEn {
                cell.titleLabel.text = name
            }
            if let desc = item.descriptionEn {
                cell.detailsLabel.text = desc
            }
        }else{
            if let name = item.nameAr {
                cell.titleLabel.text = name
            }
            if let desc = item.descriptionAr {
                cell.detailsLabel.text = desc
            }
            
        }
        if let info = item.info {
            cell.setPrice(info: info)
        }
        if let image = item.image {
            cell.seImage(url: image)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.size.width - 30
        return CGSize(width: width, height: 270)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let offer = list[indexPath.row].offer {
            if offer == 1 {
                toOrderOffer(indexPath: indexPath)
            }else{
                toOrderItem(indexPath: indexPath)
            }
        }
    }
    
    func toOrderOffer(indexPath: IndexPath){
        guard let itemID = list[indexPath.row].id else {
            return
        }
        let newVC = OrderOfferFrameVC()
        newVC.modalPresentationStyle = .fullScreen
        newVC.itemID = "\(itemID)"
        present(newVC, animated: true, completion: nil)
    }
    
    func toOrderItem(indexPath: IndexPath){
        guard let itemID = list[indexPath.row].id else {
            return
        }
        let newVC = DetailsFrameVC()
        newVC.modalPresentationStyle = .fullScreen
        newVC.itemID = "\(itemID)"
        present(newVC, animated: true, completion: nil)
    }
}
