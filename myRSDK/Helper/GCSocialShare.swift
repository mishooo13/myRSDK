//
//  GCSocialShare.swift
//  Prego
//
//  Created by owner on 10/21/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

class GCSocialShare: NSObject {
    
    // MARK:- Variables And Constants Declaration
    
    static let shared = GCSocialShare()
    
    /// This method will show UIActivityViewController to share text, image or urls.
    ///
    /// - Parameters:
    ///   - sender: UIViewController
    ///   - sView: UIView object for sourceView
    ///   - sharingText: Text which you want to share.
    ///   - sharingImage: Image which you want to share.
    ///   - sharingURL: URL which you want to share.
    ///   - sharingURL1: Second URL which you want to share.
    ///   - completion: After share will give ActivityType, status or error.
    func socialShare(sender: UIViewController, sView: UIView, sharingText: String?, sharingImage: UIImage?, sharingURL: URL?, sharingURL1: URL? = nil) {
        var sharingItems = [Any]()
        
        if let text = sharingText {
            sharingItems.append(text)
        }
        if let image = sharingImage {
            sharingItems.append(image)
        }
        if let url = sharingURL {
            sharingItems.append(url)
        }
        if let url1 = sharingURL1 {
            sharingItems.append(url1)
        }
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { (activityType, isSuccess, arrAny, error) in
            print("share results  \(isSuccess)   \(String(describing: error))")
            //completion?(activityType, isSuccess, arrAny, error)
        }
        if let avc = activityViewController.popoverPresentationController {
            avc.sourceView = sView
        }
        sender.present(activityViewController, animated: true, completion: nil)
    }
    
}
