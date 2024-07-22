//
//  CommonExtension.swift
//  Tendable
//
//  Created by Akshay Somkuwar on 7/22/24.
//

import UIKit

extension UITableViewCell {
    // The @objc is added to silence the complier errors
    @objc class var identifier: String {
        return String(describing: self)
    }
}

extension UIView {
    /// Remove all subview
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    /// Remove all subview with specific type
    func removeAllSubviews<T: UIView>(type: T.Type) {
        subviews
            .filter { $0.isMember(of: type) }
            .forEach { $0.removeFromSuperview() }
    }
}

extension Encodable {
    var dict: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return nil }
        return json
    }
}

extension Array {
    var removingDuplicates: [Element] {
        NSOrderedSet(array: self).array.compactMap({ $0 as? Element })
    }
}

extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var sceneDelegate: SceneDelegate? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = windowScene.delegate as? SceneDelegate else { return nil }
        return delegate
    }
    
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
        
        return instantiateFromNib()
    }
}
