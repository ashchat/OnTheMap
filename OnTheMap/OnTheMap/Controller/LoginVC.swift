//
//  LoginVC.swift
//  OnTheMap
//
//  Created by Ashish Chatterjee on 3/18/19.
//  Copyright © 2019 Ashish Chatterjee. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    @IBOutlet weak var emailTextField: LoginVCTextField!
    @IBOutlet weak var passwordTextField: LoginVCTextField!
    @IBOutlet weak var loginButton: LoginVCButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        subscribeToKeyboardNotifications()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        loginToUdacity()
    }

    @IBAction func signupTapped(_ sender: UIButton) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        let url = UdacityClient.Endpoints.udacitySignup.url
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func loginToUdacity() {
        
        callActivityIndicator(view: self.view)
        
        if checkForInternet() {
            let login = LoginRequest(username: emailTextField.text ?? "", password: passwordTextField.text ?? "")
            UdacityClient.taskForPOSTSession(body: login) { (response, error) in
                if response != nil {
                    uniqueKey = (response?.account.key)!
                    
                    UdacityClient.taskForGETUserData(userId: uniqueKey, completion: { (response, error) in
                        if response != nil {
                            userData = response
                            
                            ParseClient.taskForGETStudentLocation(uniqueKey: uniqueKey, completion: { (response, error) in
                                if response != nil {
                                    userLocation = response?.StudentLocations.first
                                }
                                performUIUpdatesOnMain {
                                    stopActivityIndicator()
                                    self.performSegue(withIdentifier: "loginSuccessful", sender: nil)
                                    self.unsubscribeToKeyboardNotifications()
                                }
                            })
                            
                        } else {
                            stopActivityIndicator()
                            showAlert(controller: self, title: "Error", error: ErrorMessages.getUserData.stringValue, actions: [okayAlertAction])
                        }
                    })
                } else {
                    performUIUpdatesOnMain {
                        stopActivityIndicator()
                        showAlert(controller: self, title: "Invalid Credentials", error: ErrorMessages.loginError.stringValue, actions: [okayAlertAction])
                    }
                }
            }
        } else {
            performUIUpdatesOnMain {
                stopActivityIndicator()
                showAlert(controller: self, title: "No Internet Connection", error: ErrorMessages.connectionError.stringValue, actions: [okayAlertAction])
            }
        }
    }
    
}

extension LoginVC: UITextFieldDelegate {
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y -= 0.3*getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y += 0.3*getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userinfo = notification.userInfo
        let keyboardSize = userinfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
