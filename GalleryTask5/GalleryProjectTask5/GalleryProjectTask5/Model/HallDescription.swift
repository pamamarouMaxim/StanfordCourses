//
//  GalleryDescription.swift
//  GalleryProjectTask5
//
//  Created by Maxim Panamarou on 10/15/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation

class HallDescription {
    typealias aspectRatioForURL = (url: URL, aspectRatio: Float)
    
    var hallName: String
    var aspectRationForUrl = [aspectRatioForURL]()
    var aspectRation: Float = 0
    var fixWidth: Float = 400
    
    init(hallName: String) {
        self.hallName = hallName
    }
}
