//
//  SignUpVC.swift
//  Pharmacy
//
//  Created by Lê Anh Tuấn on 8/20/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRePassword: UITextField!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let nav = self.navigationController {
            nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
            nav.navigationBar.shadowImage = UIImage()
            nav.navigationBar.isTranslucent = true
            nav.view.backgroundColor = .clear
            nav.navigationBar.tintColor = UIColor.white
            nav.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
            
            if nav.isNavigationBarHidden {
                nav.setNavigationBarHidden(false, animated: true)
            } else {
                nav.setNavigationBarHidden(true, animated: true)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // - MARK: SIGN UP ACTION
    @IBAction func btnSignUpClicked(_ sender: Any) {
        
        if !txtEmail.hasText {
            self.showAlert(message: "Email can not empty", title: "Field is required", buttons: nil)
            return
        } else if !txtPassword.hasText {
            self.showAlert(message: "Password can not empty", title: "Field is required", buttons: nil)
            return
        } else if txtPassword.text! != txtRePassword.text! {
            self.showAlert(message: "Retype password not match", title: "Field is required", buttons: nil)
            return
        } else if !Utilities.validateEmail(candidate: txtEmail.text!) {
            self.showAlert(message: "Email invalid format", title: "Field is required", buttons: nil)
            return
        } else if !txtFullName.hasText {
            self.showAlert(message: "Full name can not empty", title: "Field is required", buttons: nil)
            return
        } else if !txtAddress.hasText {
            self.showAlert(message: "Address can not empty", title: "Field is required", buttons: nil)
            return
        } else if !txtPhoneNumber.hasText {
            self.showAlert(message: "Phone number can not empty", title: "Field is required", buttons: nil)
            return
        }
        
        guard let email = txtEmail.text, let password = txtPassword.text, let fullName = txtFullName.text, let address = txtAddress.text, let phoneNumber = txtPhoneNumber.text else {
            showAlert(message: "Fields can not empty", title: "Required!", buttons: nil)
            return
        }
        
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.showLoadingDialog(toVC: self)
        
        let userObject = UserObject(email: email, password: password, fullName: fullName, address: address, phoneNumber: phoneNumber)
        
        SignIn_UpService.shared.signUp(user: userObject) { (user, error) in
            activityIndicatorView.stopAnimating()
            
            if let error = error {
                self.showAlert(message: "Sign Up failed with error: \(error)", title: "Sign Up Failed", buttons: nil)
                return
            }
            
            if let user = user {
                self.appDelegate.signIn_Up(user: user)
            } else {
                print("Invalid User")
            }
        }
    }
    
    @IBAction func btnCancelClicked(_ sender: Any) {
        appDelegate.showSignInView()
    }
    
}
