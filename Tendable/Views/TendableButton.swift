//
//  TendableButton.swift
//  Tendable
//
//  Created by Akshay Somkuwar on 7/21/24.
//

import UIKit

// MARK: - TendableButton, is the app default button
class TendableButton: UIView {
    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.buttonBackgroundColor
        view.layer.cornerRadius = 7
        view.layer.borderWidth = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = Colors.whiteColor
        label.text = "Submit"
        return label
    }()
    
    var button: CustomButton = {
        let button = CustomButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()
    
    var defaultButtonBackgroundColor: UIColor? = UIColor.clear {
        didSet {
            self.backgroundView.backgroundColor = defaultButtonBackgroundColor
        }
    }
    
    var isEnabled: Bool = true {
        didSet {
            button.isEnabled = isEnabled
        }
    }
    
    var isButtonEnabled: Bool? = true {
        didSet {
            if let isButtonEnabled = isButtonEnabled, isButtonEnabled {
                self.backgroundView.backgroundColor = defaultButtonBackgroundColor
            } else {
                self.backgroundView.backgroundColor = UIColor.init("A09FA3")
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(backgroundView)
        addSubview(label)
        addSubview(button)
        
        backgroundView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(0)
            make.right.equalTo(self.snp.right).offset(0)
            make.top.equalTo(self.snp.top).offset(0)
            make.bottom.equalTo(self.snp.bottom).offset(0)
            make.height.equalTo(45)
        }
        
        label.snp.makeConstraints { (make) in
            make.left.equalTo(backgroundView.snp.left).offset(10)
            make.right.equalTo(backgroundView.snp.right).offset(-10)
            make.centerX.centerY.equalTo(backgroundView).offset(0)
        }
        
        button.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(backgroundView)
        }
    }
    
    func setup(title: String, textColor: UIColor = Colors.buttonTextColor, backgroundColor: UIColor = Colors.buttonBackgroundColor, borderColor: UIColor? = Colors.lightSeperatorColor) {
        self.label.text = title
        self.label.textColor = textColor
        self.defaultButtonBackgroundColor = backgroundColor
        if let borderColor = borderColor {
            self.backgroundView.layer.borderWidth = 1
            self.backgroundView.layer.borderColor = borderColor.cgColor
        }
    }
}

class MCQButton: TendableButton {
    var isMCQButtonSelected: Bool = false {
        didSet {
            if isMCQButtonSelected {
                self.backgroundView.backgroundColor = Colors.buttonBackgroundColor
                self.label.textColor = Colors.whiteColor
            } else {
                self.backgroundView.backgroundColor = Colors.whiteColor
                self.label.textColor = Colors.buttonBackgroundColor
            }
        }
    }
    
    func setup(title: String, textColor: UIColor = Colors.buttonTextColor, backgroundColor: UIColor = Colors.buttonBackgroundColor, borderColor: UIColor? = Colors.lightSeperatorColor, isMCQButtonSelected: Bool, tag: Int?) {
        super.setup(title: title, textColor: textColor, backgroundColor: backgroundColor, borderColor: borderColor)
        self.label.textAlignment = .left
        self.isMCQButtonSelected = isMCQButtonSelected
        self.button.tag = tag ?? 0
    }
}


// MARK: - Reusable Button
final class CustomButton: UIButton {
    static let checkbox = CustomButton()
    typealias isPressed = (CustomButton) -> ()
    var pressed: isPressed? {
        didSet {
            if pressed != nil {
                addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
            } else {
                removeTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(CustomButton.buttonClicked(_:)), for: .touchUpInside)
    }
    
    @objc func buttonClicked(_ sender: UIButton) {
        if let handler = pressed, isEnabled {
            // button pressed
            handler(self)
        } else {
            // button is nil
        }
    }
}
