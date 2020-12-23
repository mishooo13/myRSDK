//
//  Connectivity.swift
//  Prego
//
//  Created by owner on 10/29/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
