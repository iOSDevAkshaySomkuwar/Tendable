//
//  Constants.swift
//  Tendable
//
//  Created by Akshay Somkuwar on 7/20/24.
//

import UIKit

enum Keys: String {
    case email
    case password
    case surveyList
}

struct Constant {
    static var environment = Environment.development
    static var navBarHeight: CGFloat = 0
    static var deviceHasNotch: Bool = false
    static var buttonHeight: CGFloat = 45
    static var textFieldHeight: CGFloat = 40
    static var calculatedNavBarHeight: CGFloat {
        return Constant.navBarHeight - 30
    }
    static var userId = ""
}

struct Colors {
    static let backgroundColor       =     UIColor.init("#2E2E39")
    static let lightSeperatorColor   =     UIColor.init("#F4F4F4")
    static let buttonBackgroundColor =     UIColor.init("#3F649F")
    static let buttonTextColor       =     UIColor.init("#FFFFFF")
    static let whiteColor            =     UIColor.init("#FFFFFF")
    static let blackColor            =     UIColor.init("#212121")
    static let grayColor             =     UIColor.init("#424242")
    static let navigationBarBackgroundColor  =     UIColor.init("#3F649F")
    static let navigationBarTextColor  =     UIColor.init("#FFFFFF")
}

