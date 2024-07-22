//
//  Extension+Color.swift
//  Tendable
//
//  Created by Akshay Somkuwar on 7/20/24.
//

import UIKit

extension UIColor {

    convenience init(_ hexString: String) {
        var hex = hexString
        if hex.hasPrefix("#") {
            hex = String(hex.dropFirst())
        }
        
        let hexVal = Int(hex, radix: 16) ?? 0
        self.init(red:CGFloat( (hexVal & 0xFF0000) >> 16 ) / 255.0,
                  green: CGFloat( (hexVal & 0x00FF00) >> 8 ) / 255.0,
                  blue: CGFloat( (hexVal & 0x0000FF) >> 0 ) / 255.0,
                  alpha: 1.0)

    }
}
