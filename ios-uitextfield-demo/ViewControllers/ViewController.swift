//
//  ViewController.swift
//  ios-uitextfield-demo
//
//  Created by OkuderaYuki on 2017/08/30.
//  Copyright © 2017年 Okudera Yuki. All rights reserved.
//

import UIKit

private enum TextFieldType {
    case userId, password
}

final class ViewController: UIViewController {

    @IBOutlet weak var userIdField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    fileprivate var inputUserId = ""
    fileprivate var inputPassword = ""
    
    // MARK: - view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadLastLoginUserInfo()
    }
    
    // MARK: - private methods
    private func setup() {
        userIdField.tag = TextFieldType.userId.hashValue
        passwordField.tag = TextFieldType.password.hashValue
        passwordField.isSecureTextEntry = true
    }
    
    private func saveLoginUserInfo() {
        
        if userIdField.isFirstResponder, let userId = userIdField.text {
            inputUserId = userId
        }
        
        if passwordField.isFirstResponder, let password = passwordField.text {
            inputPassword = password
        }
        
        userIdField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        let ud = UserDefaults.standard
        ud.set(inputUserId, forKey: Constants.ud_login_userId)
        ud.set(inputPassword, forKey: Constants.ud_login_password)
    }
    
    private func loadLastLoginUserInfo() {
        let ud = UserDefaults.standard
        
        // UserDefaultsにUserIdとPasswordが両方保存されていたらTextFieldに表示する
        if let lastUserId = ud.string(forKey: Constants.ud_login_userId),
            let lastPassword = ud.string(forKey: Constants.ud_login_password) {
            
            userIdField.text = lastUserId.partiallyReplace()
            passwordField.text = lastPassword
            inputUserId = lastUserId
            inputPassword = lastPassword
            return
        }
        userIdField.text = ""
        passwordField.text = ""
        inputUserId = ""
        inputPassword = ""
    }
    
    // MARK: actions
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        saveLoginUserInfo()
        
        // debug用output
        let ud = UserDefaults.standard
        if let userId = ud.string(forKey: Constants.ud_login_userId),
            let password = ud.string(forKey: Constants.ud_login_password) {
            
            let message = "ユーザID:\(userId)\nパスワード:\(password)"
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
        case TextFieldType.userId.hashValue:
            userIdField.text = inputUserId
            return true
            
        case TextFieldType.password.hashValue:
            passwordField.text = inputPassword
            passwordField.isSecureTextEntry = false
            return true
            
        default:
            return false
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField,
                                reason: UITextFieldDidEndEditingReason) {
        
        switch textField.tag {
        case TextFieldType.userId.hashValue:
            guard let userId = userIdField.text else { return }
            inputUserId = userId
            userIdField.text = userId.partiallyReplace()
            passwordField.becomeFirstResponder()
            
        case TextFieldType.password.hashValue:
            guard let password = passwordField.text else { return }
            inputPassword = password
            passwordField.text = password
            passwordField.isSecureTextEntry = true
            passwordField.resignFirstResponder()
            
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
        case TextFieldType.userId.hashValue:
            passwordField.becomeFirstResponder()
            return true
            
        case TextFieldType.password.hashValue:
            passwordField.resignFirstResponder()
            return true
            
        default:
            return false
        }
    }
}
