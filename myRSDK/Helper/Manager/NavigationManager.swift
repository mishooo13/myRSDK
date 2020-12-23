//
//  NavigationManager.swift
//  Prego
//
//  Created by owner on 8/19/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

public class NavigationManager {
    
    static func toSplash(_ vc: UIViewController){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let desVC = mainStoryboard.instantiateViewController(withIdentifier: "SplashVC") as? SplashVC {
            vc.present(desVC, animated: true)
        }
    }

    static func toHome(_ vc: UIViewController){
        let newVC = HomeContainerFrameVC()
        newVC.modalPresentationStyle = .fullScreen
        vc.present(newVC, animated: true, completion: nil)
    }
    
    static func toDetectLocation(_ vc: UIViewController){
        let newVC = DetectLocationFrameworkVC()
        newVC.modalPresentationStyle = .fullScreen
        vc.present(newVC, animated: true, completion: nil)
    }
    
    static func toReasturantChain(_ vc: UIViewController){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let desVC = mainStoryboard.instantiateViewController(withIdentifier: "ReasturantChainVC") as? ReasturantChainFrameVC {
            vc.modalPresentationStyle = .fullScreen
            vc.present(desVC, animated: true)
        }
    }
    
    static func toLoginDismiss(_ vc: UIViewController){
        
        let newVC = LoginFrameVC()
        newVC.modalPresentationStyle = .fullScreen
        newVC.isDismiss = true
        vc.present(newVC, animated: true, completion: nil)
    }
    
    static func toChainVC(_ vc: UIViewController, areaObjectList: [AreaClass], areaList: [String]){
        
        let newVC = ReasturantChainFrameVC()
        newVC.modalPresentationStyle = .fullScreen
        newVC.areaList = areaList
        newVC.areaObjectList = areaObjectList
        vc.present(newVC, animated: true, completion: nil)
        
    }
    
    static func toSignUp(_ vc: UIViewController){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let desVC = mainStoryboard.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC {
            vc.present(desVC, animated: true)
        }
    }
    
    static func toOffers(_ vc: UIViewController){
        
        let newVC = OffersFrameVC()
        newVC.modalPresentationStyle = .fullScreen
        vc.present(newVC, animated: true, completion: nil)
    }
    
    static func toFavorites(_ vc: UIViewController){
       
        let newVC = FavoritesFrameVC()
        newVC.modalPresentationStyle = .fullScreen
        vc.present(newVC, animated: true, completion: nil)
    }
    
    static func toCart(_ vc: UIViewController){
        let newVC = CartFrameVC()
        newVC.modalPresentationStyle = .fullScreen
        vc.present(newVC, animated: true, completion: nil)
    }
    
    static func toAddAddress(_ vc: UIViewController){
        
        let newVC = AddAddressFrameVC()
        newVC.modalPresentationStyle = .fullScreen
        vc.present(newVC, animated: true, completion: nil)
    }
    
    static func toProfile(_ vc: UIViewController){
        
        let newVC = ProfileFrameVC()
        newVC.modalPresentationStyle = .fullScreen
        vc.present(newVC, animated: true, completion: nil)
    }
    
    static func toLogin(_ vc: UIViewController){
        let newVC = LoginFrameVC()
        newVC.modalPresentationStyle = .fullScreen
        vc.present(newVC, animated: true, completion: nil)
    }
    
    
    static func toTrackOrder(_ vc: UIViewController){
        let newVC = TrackOrderFrameVC()
        newVC.modalPresentationStyle = .fullScreen
        vc.present(newVC, animated: true, completion: nil)
    }
    
    static func toHome(_ vc: UIViewController, tab: Int){
        /*let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let desVC = mainStoryboard.instantiateViewController(withIdentifier: "HomeTabBarVC") as? HomeTabBarVC {
            desVC.selectedTab = tab
            vc.present(desVC, animated: true)
        }*/
    }
    
    static func toProfile(_ vc: UIViewController, isPhone: Bool){
        let newVC = ProfileFrameVC()
        newVC.modalPresentationStyle = .fullScreen
        vc.present(newVC, animated: true, completion: nil)
    }
    
    static func toOrders(_ vc: UIViewController){
        let newVC = HistoryFrameVC()
        newVC.modalPresentationStyle = .fullScreen
        newVC.isHideTitle = false
        vc.present(newVC, animated: true, completion: nil)
    }
    
    static func toAbout(_ vc: UIViewController){
        
        let newVC = AboutFrameVC()
        newVC.modalPresentationStyle = .fullScreen
        vc.present(newVC, animated: true, completion: nil)
    }
    
    static func toContactusVC(_ vc: UIViewController){
       
        let newVC = ContactusFrameVC()
        newVC.modalPresentationStyle = .fullScreen
        vc.present(newVC, animated: true, completion: nil)
    }
    
}
