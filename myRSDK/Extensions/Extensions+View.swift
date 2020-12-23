//
//  Extensions+View.swift
//  Prego
//
//  Created by owner on 8/20/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit


@IBDesignable
class CustomGradient: UIView {
    
    @IBInspectable var FirstColor : UIColor = UIColor.clear {
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var SecondColor : UIColor = UIColor.clear {
        didSet{
            updateView()
        }
    }
    
    override class var layerClass : AnyClass {
        get{
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        let Layer = self.layer as! CAGradientLayer
        Layer.colors = [FirstColor.cgColor , SecondColor.cgColor]
    }
    
}


@IBDesignable
class CustomButton: UIView {
    
    @IBInspectable var FirstColor : UIColor = UIColor.clear {
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var SecondColor : UIColor = UIColor.clear {
        didSet{
            updateView()
        }
    }
    
    override class var layerClass : AnyClass {
        get{
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        let Layer = self.layer as! CAGradientLayer
        Layer.colors = [FirstColor.cgColor , SecondColor.cgColor]
    }
    
}

extension UIView{
    
    @IBInspectable var CornerRaduis : CGFloat {
        get{ return self.layer.cornerRadius}
        set{ self.layer.cornerRadius = newValue}
    }
    
    @IBInspectable var shadowOffsetWidth : CGFloat {
        get{ return self.layer.shadowOffset.width}
        set{ self.layer.shadowOffset.width = newValue}
    }
    
    @IBInspectable var shadowOffsetHeight : CGFloat {
        get{ return self.layer.shadowOffset.height}
        set{ self.layer.shadowOffset.height = newValue}
    }
    
    @IBInspectable var shadowOpacity : CGFloat {
        get{ return CGFloat(self.layer.shadowOpacity)}
        set{ self.layer.shadowOpacity = Float(newValue)}
    }
    
    @IBInspectable var shadowColor : UIColor {
        get{ return UIColor( cgColor : self.layer.shadowColor!)}
        set{ self.layer.shadowColor = newValue.cgColor}
    }
    
    @IBInspectable var BorderWidth : CGFloat {
        get{ return self.layer.borderWidth}
        set{ self.layer.borderWidth = newValue}
    }
    
    @IBInspectable var BorderColor : UIColor {
        get{ return UIColor( cgColor : self.layer.borderColor!)}
        set{ self.layer.borderColor = newValue.withAlphaComponent(0.3).cgColor}
    }
    
}



extension UIColor{
    
    func getCustomBlueColor() -> UIColor{
        
        return UIColor(red:0.043, green:0.576 ,blue:0.588 , alpha:1.00)
        
    }
}


extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat, personalInfoView: UIView) {
        
        let border = CALayer()
        
        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .bottom:
            //            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: personalInfoView.frame.width, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        addSublayer(border)
    }
}



extension UIView {
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        self.layer.add(animation, forKey: nil)
    }
}


@IBDesignable
class LabelFont: UILabel {
    
    @IBInspectable var FontSize : CGFloat = 18 {
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var isBold : Bool = false {
        didSet{
            updateView()
        }
    }
    
    func updateView() {
        if DefaultManager.getLanguageDefault() == Config.Arablic {
            if isBold {
                self.font = AppFontManager.fontType(type: .droidKufi, size: FontSize, weight: .bold)
            }else{
                self.font = AppFontManager.fontType(type: .droidKufi, size: FontSize)
            }
        }
    }
}

@IBDesignable
class ButtonFont: UIButton {
    
    @IBInspectable var FontSize : CGFloat = 18 {
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var isBold : Bool = false {
        didSet{
            updateView()
        }
    }
    
    func updateView() {
        if DefaultManager.getLanguageDefault() == Config.Arablic {
            if isBold {
                self.titleLabel?.font = AppFontManager.fontType(type: .droidKufi, size: FontSize, weight: .bold)
            }else{
                self.titleLabel?.font = AppFontManager.fontType(type: .droidKufi, size: FontSize)
            }
        }
    }
}
