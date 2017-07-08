//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Sujay Bhowmick on 6/23/17.
//  Copyright © 2017 Sujay Bhowmick. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var loginSpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showHideActivityIndicator(false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func authenticate(_ sender: Any) {
        print("Login")
        self.errorLabel.text = ""
        authenticate(userName.text!, password.text!)
        self.showHideActivityIndicator(true)
        self.enableDisableTextBoxAndButton(false)
    }
    
    func authenticate(_ userName: String, _ password: String) {
        OnTheMapClient.sharedInstance().authenticateWithViewController(self, userName, password) { (success, errorString) in
            performUIUpdatesOnMain {
                self.showHideActivityIndicator(false)
                if success {
                    print("success")
                    self.completeLogin()
                    
                }else {
                    print("failed")
                    if let errorString = errorString {
                        self.displayError(errorString)
                    }
                }
                self.enableDisableTextBoxAndButton(true)
            }
        }
    }
    
    private func completeLogin() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "OnTheMapTabViewController") as! UITabBarController
        present(controller, animated: true, completion: nil)
    }
    
    private func displayError(_ errorString: String){
        print(errorString)
        showAlert("Login Message", message: errorString)
    }
    
    private func showHideActivityIndicator(_ show: Bool = false){
        if show {
            self.loginSpinner.startAnimating()
        }else {
            self.loginSpinner.stopAnimating()
        }
    }
    
    private func enableDisableTextBoxAndButton(_ disable: Bool = false) {
        self.userName.isEnabled = disable
        self.password.isEnabled = disable
        self.loginButton.isEnabled = disable
    }
    
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: OnTheMapClient.Alerts.DismissAlert, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
   
}
