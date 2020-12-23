//
//  HistoryCell.swift
//  Prego
//
//  Created by owner on 10/7/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

protocol HistoryDelegate {
    func rateDelegate(tage: Int) -> Void
    func detailsDelegate(tage: Int) -> Void
    func trackDelegate(tage: Int) -> Void
}

class HistoryCell: UITableViewCell {
    
    var delegate: HistoryDelegate?

    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var rateBtn: UIButton!
    @IBOutlet weak var detailsBtn: UIButton!
    @IBOutlet weak var trackBtn: UIButton!
    
    @IBAction func rateAction(_ sender: Any) {
        delegate?.rateDelegate(tage: tag)
    }
    
    @IBAction func detailsAction(_ sender: Any) {
        delegate?.detailsDelegate(tage: tag)
    }
    
    @IBAction func trackAction(_ sender: Any) {
        delegate?.trackDelegate(tage: tag)
    }
    
    override func awakeFromNib() {
        detailsBtn.layer.borderWidth = 1
        trackBtn.layer.borderWidth = 1
        
        detailsBtn.layer.borderColor = AppColorsManager.greenColor?.cgColor
        trackBtn.layer.borderColor = AppColorsManager.greenColor?.cgColor
    }
}
