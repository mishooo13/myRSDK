//
//  Extensions+Notiification.swift
//  Prego
//
//  Created by owner on 9/28/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let didSideBar =  Notification.Name("didSideBar")
    static let didBag = Notification.Name("didBag")
    static let didPaymentSuccess =  Notification.Name("didPaymentSuccess")
    static let didPaymentFailed =  Notification.Name("didPaymentFailed")
    static let didCategory =  Notification.Name("didCategory")
    static let didAreaChanged =  Notification.Name("didAreaChanged")
    static let didCartChanged =  Notification.Name("didCartChanged")
}
