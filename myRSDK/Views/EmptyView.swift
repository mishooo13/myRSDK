//
//  EmptyView.swift
//  Prego
//
//  Created by owner on 10/28/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

class EmptyView: UIView {

    @IBOutlet public var view: UIView!
    @IBOutlet weak var emptyImage: UIImageView!
    @IBOutlet weak var emptyLabel: UILabel!
    
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//        setUpNib()
//    }
//    
//    required public init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setUpNib()
//    }
//    
//    internal func setUpNib() {
//        view = loadNib()
//        view.frame = bounds
//        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        addSubview(view)
//    }
//
//    internal func loadNib() -> UIView {
//        //let bundle = Bundle(for: type(of: self))
//        let nib = UINib(nibName: String(describing: EmptyView.self), bundle: frameworkBundle)
//        guard let summaryHeaderView = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
//            return UIView()
//        }
//        return summaryHeaderView
//    }
    
}
