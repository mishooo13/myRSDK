//
//  TableSectionHeader.swift
//  Prego
//
//  Created by owner on 9/18/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: class {
    func toggleSection(header: TableSectionHeader, section: Int)
}

class TableSectionHeader: UITableViewHeaderFooterView {

    weak var delegate: HeaderViewDelegate?
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var mView: UIView?
    @IBOutlet weak var arrowLabel: UIImageView?
    var section: Int = 0
    //var item: SectionModel?
    
    
    func setCollapsed(collapsed: Bool) {
        print("heeeey")
        arrowLabel?.rotate(collapsed ? 0.0 : .pi)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
        mView?.shadowAndBorderForTableViewCell(cell: mView!, cornerRadious: 8)
    }
    
    @objc private func didTapHeader() {
        print("header tapped \(section)")
        delegate?.toggleSection(header: self, section: section)
    }

}


extension UILabel{
    
    func addImage(imageName: String){
        let attachment:NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)
        
        let attachmentString:NSAttributedString = NSAttributedString(attachment: attachment)
        let myString:NSMutableAttributedString = NSMutableAttributedString(string: self.text!)
        myString.append(attachmentString)
        
        self.attributedText = myString
    }
}
