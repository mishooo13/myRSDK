//
//  Guide.swift
//  Prego
//
//  Created by owner on 8/22/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import Foundation


struct Guide {
    var image: String?
    var title: String?
    var details: String?
    
    init(image: String, title: String, details: String) {
        self.image = image
        self.title = title
        self.details = details
    }
}
