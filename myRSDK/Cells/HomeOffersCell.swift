//
//  HomeOffersCell.swift
//  MyRes
//
//  Created by Other Logic on 11/21/19.
//  Copyright © 2019 Other Logic. All rights reserved.
//

import UIKit

class HomeOffersCell: UICollectionViewCell {
    
    var offersNIB = "HomeOffersCell"
    var mCollection: UICollectionView?
    
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var mImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    //var offerList: [Offer] = []
    
    var homeVC: HomeFrameVC?
    
    var offerList: [Offer] = [] {
        didSet {
            mCollection?.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUp() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        mCollection = UICollectionView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), collectionViewLayout: layout)
        mCollection?.delegate = self
        mCollection?.dataSource = self
        mCollection?.backgroundColor = AppColorsManager.grayColor
        mCollection?.showsHorizontalScrollIndicator = false
        let OffersNibCell = UINib(nibName: offersNIB, bundle: frameworkBundle)
        mCollection?.register(OffersNibCell, forCellWithReuseIdentifier: offersNIB)
        
        if APPLanguage() == Config.Arablic {
            mCollection?.semanticContentAttribute = .forceRightToLeft
            mCollection?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
        
        addSubview(mCollection!)
        backgroundColor = .clear
    }
    
    func seImage(url: String) {
        ImagesManager.setImage(url: url, image: mImageView)
        //mImageView.image = UIImage(named: url)
    }
    
    func setPrice(info: [Info]) {
        if info.count == 1 {
            if let price = Utilits.getPriceFromInfo(info: info) {
                priceLabel.isHidden = false
                priceLabel.text = "\(Utilits.splitPrice(price: price)) \("pound".getLocalizedValue())"
            }else{
                priceLabel.isHidden = true
            }
        }else{
            if let price = Utilits.getPriceFromInfo(info: info) {
                priceLabel.isHidden = false
                priceLabel.text = "\("price_start".getLocalizedValue()) \(Utilits.splitPrice(price: price)) \("pound".getLocalizedValue())"
            }else{
                priceLabel.isHidden = true
            }
        }
        
        /*if !info.isEmpty {
            if let price = info[0].priceAr {
                if info.count == 1 {
                    priceLabel.text = "\(price) \(NSLocalizedString("pound", comment: ""))"
                }else{
                    priceLabel.text = "\(NSLocalizedString("price_start", comment: "")) \(price) \(NSLocalizedString("pound", comment: ""))"
                }
            }
        }*/
    }

}


extension HomeOffersCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return offerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:HomeOffersCell = collectionView.dequeueReusableCell(withReuseIdentifier: offersNIB , for: indexPath) as! HomeOffersCell
        cell.shadowAndBorderForCell(cell: cell, radius: 8)
        
        if APPLanguage() == Config.Arablic {
            cell.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
        
        let item = offerList[indexPath.row]
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
        
        var width = frame.width * 0.85
        if offerList.count == 1 {
            //width = frame.width - 2
            width = frame.width * 0.90
        }
        print("height  \(frame.height)")
        return CGSize(width: width, height: frame.height - 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let offer = offerList[indexPath.row].offer {
            if offer == 1 {
                toOrderOffer(indexPath: indexPath)
            }else{
                toOrderItem(indexPath: indexPath)
            }
        }
    }
    
    func toOrderOffer(indexPath: IndexPath){
        guard let itemID = offerList[indexPath.row].id else {
            return
        }
        
        let newVC = OrderOfferFrameVC()
        newVC.modalPresentationStyle = .fullScreen
        newVC.itemID = "\(itemID)"
        homeVC?.present(newVC, animated: true, completion: nil)
    }
    
    func toOrderItem(indexPath: IndexPath){
        guard let itemID = offerList[indexPath.row].id else {
            return
        }
        
        
        let newVC = DetailsFrameVC()
        newVC.modalPresentationStyle = .fullScreen
        newVC.itemID = "\(itemID)"
        homeVC?.present(newVC, animated: true, completion: nil)
    }
}
