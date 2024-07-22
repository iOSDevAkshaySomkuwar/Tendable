//
//  BaseViewController.swift
//  Tendable
//
//  Created by Akshay Somkuwar on 7/21/24.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    // MARK: - Properties
    
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup() {
        setupNavigationBar()
        view.backgroundColor = UIColor.white
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.tintColor = Colors.navigationBarTextColor
        self.navigationController?.navigationBar.isTranslucent = false

        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = Colors.navigationBarBackgroundColor
            appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.navigationBarTextColor]
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.navigationBarTextColor]

            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            self.navigationController?.navigationBar.compactAppearance = appearance

        } else {
            self.navigationController?.navigationBar.barTintColor = Colors.navigationBarBackgroundColor
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.navigationBarTextColor]
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.navigationBarTextColor]
        }
    }
    
    // MARK: - Helpers
    func showAlert(title: String?, subTitle: String? = nil, message: String? = nil, actionTitle: String = "Okay", completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction.init(title: actionTitle, style: .default) { _ in
            completion?()
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    func welcomeUser() {
        if let window = self.sceneDelegate?.window {
            let navigationController = UINavigationController(rootViewController: HomeViewController())
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }
}
