//
//  FavoritesFrameVC.swift
//  myRSDK
//
//  Created by Other Logic on 9/13/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import UIKit

class FavoritesFrameVC: UIViewController {

    @IBOutlet weak var mCollection: UICollectionView!
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var bagView: UIView!
    
    let nibCellName: String = "HomeFoodsCell"
    var list: [Favorite] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !Connectivity.isConnectedToInternet {
            showInternetFailed(view: self.mView)
            return
        }
        
        registerCollectionView()
        loadData()
    }
    
    public init() {
        super.init(nibName: "FavoritesFrameVC", bundle: Bundle(for: FavoritesFrameVC.self))
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
    
    func loadData(){
        
        guard let priceList = DefaultManager.getAreaPriceListDefault() else {
            return
        }
        
        guard let token = DefaultManager.getUserToken() else {
            if let image = UIImage(named: "empty-favorites.png", in: frameworkBundle, with: .none){
                self.showEmptyView(on: self.mView, title: "yyy", mImage: image)
            }
            return
        }
        showLoadingView(on: mView)
        ProfileAPI.favorites(token: token, priceList: priceList,view: self.view) { (error, success, list) in
            self.hideLoadingView()
            if error != nil || !success {
                self.mCollection.reloadData()
                if let image = UIImage(named: "empty-favorites.png", in: frameworkBundle, with: .none){
                    self.showEmptyView(on: self.mView, title: "empty_favorite".getLocalizedValue(), mImage: image)
                }
                return
            }
            if list!.isEmpty{
                if let image = UIImage(named: "empty-favorites.png", in: frameworkBundle, with: .none){
                    self.showEmptyView(on: self.mView, title: "empty_favorite".getLocalizedValue(), mImage: image)
                }
                return
            }
            self.hideEmptyDataView(view: self.mView)
            self.list = list!
            self.mCollection.reloadData()
            print("fav count \(self.list.count)")
        }
    }

}



extension FavoritesFrameVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:HomeFoodsCell = collectionView.dequeueReusableCell(withReuseIdentifier: nibCellName, for: indexPath) as! HomeFoodsCell
        cell.shadowAndBorderForCell(cell: cell, radius: 6)
        
        if let item = list[indexPath.row].itemName {
            if APPLanguage() == Config.English {
                if let name = item.nameEn {
                    cell.titleLabel.text = name
                }
                if let desc = item.desriptionEn {
                    cell.detailsLabel.text = desc
                }
            }else{
                if let name = item.nameAr {
                    cell.titleLabel.text = name
                }
                if let desc = item.desriptionAr {
                    cell.detailsLabel.text = desc
                }
            }
            if let info = item.info {
                cell.setPrice(info: info)
            }
            if let image = item.image {
                cell.seImage(url: image)
            }
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
        
        guard let itemName = list[indexPath.row].itemName, let favMenuID = itemName.menuID, let menuID = DefaultManager.getMenuID() else {
            AlertManager.showWrongAlertWithMessage(on: self, message: "wrong_menu_ID".getLocalizedValue())
            return
        }
        
        if "\(favMenuID)" != menuID {
            AlertManager.showWrongAlertWithMessage(on: self, message: "wrong_menu_ID".getLocalizedValue())
            return
        }
        print("mmmmmmmmn \(favMenuID)   \(menuID)")
        guard let itemID = list[indexPath.row].itemID else {
            return
        }
        
        let newVC = DetailsFrameVC()
        newVC.modalPresentationStyle = .fullScreen
        newVC.itemID = "\(itemID)"
        present(newVC, animated: true, completion: nil)
    }
}
