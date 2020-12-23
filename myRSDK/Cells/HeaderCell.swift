//
//  HeaderCell.swift
//  Prego
//
//  Created by owner on 9/18/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit


class HeaderCell: UITableViewCell {
    
    //weak var delegate: HeaderViewDelegate?

    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var arrowLabel: UIImageView?
    var section: Int = 0
    //var item: SectionModel?
    
    func setCollapsed(collapsed: Bool) {
        //print("heeeey")
        arrowLabel?.rotate(collapsed ? 0.0 : .pi)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
    }
    
    @objc private func didTapHeader() {
        //print("header tapped \(section)")
        //delegate?.toggleSection(header: self, section: section, model: item!)
    }
}
