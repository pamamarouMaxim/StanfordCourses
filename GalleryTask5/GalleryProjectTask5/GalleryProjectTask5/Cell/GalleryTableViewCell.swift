//
//  GalleryTableViewCell.swift
//  GalleryProjectTask5
//
//  Created by Maxim Panamarou on 10/13/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class GalleryTableViewCell: UITableViewCell {

    @IBOutlet weak var galleryNameTextField: UITextField!
  
    var hallNameText :  ((String?) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        galleryNameTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension GalleryTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.isEnabled = false
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let closure = hallNameText {
            closure(textField.text)
        }
         textField.isEnabled = false
    }
}
