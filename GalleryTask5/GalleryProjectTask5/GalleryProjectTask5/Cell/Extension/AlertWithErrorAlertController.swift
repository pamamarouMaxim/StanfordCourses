//
//  AlertWithTittleAlertController.swift
//  GalleryProjectTask5
//
//  Created by Maxim Panamarou on 10/17/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class AlertWithErrorAlertController: UIAlertController {
    static func alertWithError(_ error: Error?) -> UIAlertController {
        let message = error?.localizedDescription
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
        }))
        return alert
    }
}
