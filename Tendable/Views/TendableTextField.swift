//
//  TendableTextField.swift
//  Tendable
//
//  Created by Akshay Somkuwar on 7/21/24.
//

import UIKit
import SnapKit

class TendableTextField: UIView {
    let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .left
        textField.setLeftPaddingPoints(10)
        textField.backgroundColor = UIColor.white
        textField.textColor = Colors.blackColor
        textField.keyboardType = .asciiCapable
        textField.layer.cornerRadius = 7
        textField.layer.borderColor = Colors.lightSeperatorColor.cgColor
        textField.layer.borderWidth = 1
        textField.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        return textField
    }()
    
    var text: String {
        return textField.text ?? ""
    }
    
    init(placeholder: String, isSecureTextEntry: Bool = false) {
        super.init(frame: .zero)
        textField.isSecureTextEntry = isSecureTextEntry
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: Colors.grayColor.withAlphaComponent(0.3)])

        addSubview(textField)

        textField.snp.makeConstraints { (make) in
            make.left.top.equalTo(self).offset(0)
            make.right.bottom.equalTo(self).offset(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
