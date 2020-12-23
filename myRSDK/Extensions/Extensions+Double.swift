//
//  Extensions+Double.swift
//  Prego
//
//  Created by Other Logic on 11/11/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit


extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
