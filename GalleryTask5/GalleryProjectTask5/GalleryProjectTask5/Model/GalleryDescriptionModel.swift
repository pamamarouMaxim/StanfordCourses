//
//  GalleryModel.swift
//  GalleryProjectTask5
//
//  Created by Maxim Panamarou on 10/15/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import Foundation

class GalleryDescriptionModel {
    var galleryHalls : [[HallDescription]] {
        return [shownHalls, recentlyDeletedHalls]
    }
    var shownHalls = [HallDescription]()
    var recentlyDeletedHalls = [HallDescription]()
}
