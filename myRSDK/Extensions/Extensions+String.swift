//
//  Extensions+String.swift
//  myRSDK
//
//  Created by Other Logic on 9/28/20.
//  Copyright © 2020 Other Logic. All rights reserved.
//

import Foundation



extension String{
    func getLocalizedValue() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: frameworkBundle!, value: "", comment: self)
    }

}
