//
//  HomeMenuCell.swift
//  MyRes
//
//  Created by Other Logic on 11/21/19.
//  Copyright © 2019 Other Logic. All rights reserved.
//

import UIKit

protocol MenuDelegate {
    func menuAction(tag: Int) -> Void
}

protocol MenuInsideDelegate {
    func menuInsideAction(tag: Int) -> Void
}

class HomeMenuCell: UICollectionViewCell {
    
    let menuNIB                     = "HomeMenuCell"

    var mCollection: UICollectionView?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    var delegate: MenuDelegate?
    var delegateInside: MenuInsideDelegate?
    
    var foodListTag: Int = 0
    
    var menuList: [Menu] = [] {
        didSet {
            mCollection?.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    func moveToCell(index: Int){
        print("print moveToCell \(index)")
        let indexPath = IndexPath(item: index, section: 0)
        DispatchQueue.main.async {
            self.mCollection!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        
        print("print tag list \(foodListTag)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUp() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        
        //layout.invalidateLayout()
        
        mCollection = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70), collectionViewLayout: layout)
        mCollection?.delegate = self
        mCollection?.dataSource = self
        mCollection?.backgroundColor = AppColorsManager.grayColor
        mCollection?.showsHorizontalScrollIndicator = false
        let LocationNibCell = UINib(nibName: menuNIB, bundle: frameworkBundle)
        mCollection?.register(LocationNibCell, forCellWithReuseIdentifier: menuNIB)
        
        /*if APPLanguage() == Config.Arablic {
            //mCollection?.semanticContentAttribute = .forceRightToLeft
            mCollection?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }*/
        
        
        addSubview(mCollection!)
        backgroundColor = .clear
    }

}


extension HomeMenuCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:HomeMenuCell = collectionView.dequeueReusableCell(withReuseIdentifier: menuNIB , for: indexPath) as! HomeMenuCell
        
        /*if APPLanguage() == Config.Arablic {
            cell.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }*/
        cell.delegateInside = self
        if indexPath.row == foodListTag {
            setAsSelected(cell: cell)
        }else{
            setAsUnSelected(cell: cell)
        }
        
        if APPLanguage() == Config.English {
            if let title = menuList[indexPath.row].nameEn {
                cell.titleLabel.text = title
            }
        }else{
            if let title = menuList[indexPath.row].nameAr {
                cell.titleLabel.text = title
            }
        }
        return cell
    }
    
    func setAsSelected(cell: HomeMenuCell){
        cell.titleLabel.textColor = UIColor.white
        cell.cellView.backgroundColor = AppColorsManager.greenColor
    }
    
    func setAsUnSelected(cell: HomeMenuCell){
        cell.titleLabel.textColor = UIColor.black
        cell.cellView.backgroundColor = AppColorsManager.darkGrayColor
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        if APPLanguage() == Config.English {
            if let title = menuList[indexPath.row].nameEn {
                label.text = title
            }
        }else{
            if let title = menuList[indexPath.row].nameAr {
                label.text = title
            }
        }
        
        label.sizeToFit()
        return CGSize(width: label.frame.width + 40, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        foodListTag = indexPath.row
        delegate?.menuAction(tag: indexPath.row)
    }
}


extension HomeMenuCell : MenuInsideDelegate {
    func menuInsideAction(tag: Int) {
        delegate?.menuAction(tag: tag)
    }
}
