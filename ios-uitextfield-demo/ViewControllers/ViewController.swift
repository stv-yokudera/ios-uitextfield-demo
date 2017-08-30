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
    
    private func loadLastLoginUserInfo() {
        let ud = UserDefaults.standard
        
        // UserDefaultsにUserIdとPasswordが両方保存されていたらTextFieldに表示する
        if let lastUserId = ud.string(forKey: Constants.ud_login_userId),
            let lastPassword = ud.string(forKey: Constants.ud_login_password) {
            
            userIdField.text = lastUserId.partiallyReplace()
            passwordField.text = lastPassword
        }
    }
    
    // MARK: actions
    
    @IBAction func didTapReset(_ sender: UIButton) {
        let ud = UserDefaults.standard
        ud.removeObject(forKey: Constants.ud_login_userId)
        ud.removeObject(forKey: Constants.ud_login_password)
        userIdField.text = ""
        passwordField.text = ""
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
        case TextFieldType.userId.hashValue:
            userIdField.text = ""
            return true
            
        case TextFieldType.password.hashValue:
            passwordField.text = ""
            return true
            
        default:
            return false
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField,
                                reason: UITextFieldDidEndEditingReason) {
        
        let ud = UserDefaults.standard
        
        switch textField.tag {
        case TextFieldType.userId.hashValue:
            ud.set(textField.text, forKey: Constants.ud_login_userId)
            userIdField.text = textField.text?.partiallyReplace()
            passwordField.becomeFirstResponder()
            
        case TextFieldType.password.hashValue:
            ud.set(textField.text, forKey: Constants.ud_login_password)
            passwordField.text = textField.text?.partiallyReplace()
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
