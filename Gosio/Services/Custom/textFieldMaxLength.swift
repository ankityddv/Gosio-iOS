//
//  textFieldMaxLength.swift
//  Gosio
//
//  Created by ANKIT YADAV on 03/03/21.
//

import UIKit

private var __maxLengths = [UITextField: Int]()

extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
               return 150 
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.prefix(maxLength).decomposedStringWithCanonicalMapping
    }
}
