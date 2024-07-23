//
//  LoginViewController.swift
//  Tendable
//
//  Created by Akshay Somkuwar on 7/20/24.
//

import UIKit

class LoginViewController: BaseViewController {
    
    // MARK: - Properties
    let emailTextField = TendableTextField(placeholder: "Please enter email")
    let passwordTextField = TendableTextField(placeholder: "Please enter password", isSecureTextEntry: true)
    
    private var loginButton: TendableButton = {
        let button = TendableButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setup(title: "Login")
        return button
    }()
    
    private var registerButton: TendableButton = {
        let button = TendableButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setup(title: "Register")
        return button
    }()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialSetup()
        handlers()
    }
    
    private func initialSetup() {
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.topItem?.title = "Login"
    }
    
    private func setupViews() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        
        emailTextField.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.height.equalTo(Constant.textFieldHeight)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.height.equalTo(emailTextField)
            make.left.right.equalTo(emailTextField).offset(0)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.left.right.equalTo(emailTextField).offset(0)
            make.height.equalTo(Constant.buttonHeight)
        }
        
        registerButton.snp.makeConstraints { (make) in
            make.top.equalTo(loginButton.snp.bottom).offset(10)
            make.left.right.equalTo(emailTextField).offset(0)
            make.height.equalTo(Constant.buttonHeight)
        }
    }
    
    private func handlers() {
        loginButton.button.pressed = { (sender) in
            self.isLoginButtonEnabled(false)
            if self.checkValidation() {
                self.networkCall()
            } else {
                self.isLoginButtonEnabled(true)
            }
        }
        
        registerButton.button.pressed = { (sender) in
            let vc = RegisterViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Actions
    private func isLoginButtonEnabled(_ state: Bool) {
        self.loginButton.isEnabled = state
    }
    
    func networkCall() {
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        let param: [String: Any] = [
            "email": email,
            "password": password,
        ]
        
        NetworkManager.shared.request(.login, parameters: param) { [weak self] (responseData) in
            guard let self = self, let response = responseData else { return }
            
            switch response {
            case .success(let result, _):
                PersistentStorageManager.shared.saveUser(email: email, password: password)
                self.showAlert(title: result.message) {
                    self.welcomeUser()
                }
            case .failure(let error):
                self.showAlert(title: error.message)
            }
            self.isLoginButtonEnabled(true)
            
        } error: { [weak self] (error) in
            guard let self = self else { return }
            self.isLoginButtonEnabled(true)
        }
    }
}


extension LoginViewController: UITextFieldDelegate {
    func checkValidation() -> Bool {
        self.view.endEditing(true)
        
        var isValid = true
        let textFieldText = emailTextField.textField.text ?? ""
        let passwordTextFieldText = passwordTextField.textField.text ?? ""
        if textFieldText.isEmpty {
            isValid = false
            self.showAlert(title: "Validation Error!", message: "Please enter email", actionTitle: "Okay")
        } else if passwordTextFieldText.isEmpty {
            isValid = false
            self.showAlert(title: "Validation Error!", message: "Please enter password", actionTitle: "Okay")
        }
        return isValid
    }
}
