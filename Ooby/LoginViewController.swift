//
//  LoginViewController.swift
//  Ooby
//
//  Created by Tanzil Ansari on 5/16/17.
//  Copyright © 2017 tansari. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!

    var activityIndicator = UIActivityIndicatorView()
    
    func createAlert(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func login(_ sender: Any) {
        
        //login
        if emailTextField.text == "" || passwordTextField.text == "" {
            
            createAlert(title: "Error In Form", message: "Please enter an email or password")
            
        }else{
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                if error != nil{
                    
                    var displayErrorMessage = "Please try again later."
                    
                    let error = error as NSError?
                    
                    if let errorMessage = error?.userInfo["error"] as? String {
                        
                        displayErrorMessage = errorMessage
                        
                    }
                    
                    self.createAlert(title: "Login Error", message: displayErrorMessage)
                    
                }else{
                    
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                    
                }
                
            
                
            })
            
        }
        
        
    }
    
    @IBAction func signup(_ sender: Any) {
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            
            createAlert(title: "Error In Form", message: "Please enter an email or password")
            
        }else{
            //Sign up
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            let user = PFUser()
            user.username = emailTextField.text
            user.email = emailTextField.text
            user.password = passwordTextField.text
            
            user.signUpInBackground(block: { (success, error) in
                
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                if error != nil{
                    
                    var displayErrorMessage = "Please try again later."
                    
                    let error = error as NSError?
                    
                    if let errorMessage = error?.userInfo["error"] as? String {
                        
                        displayErrorMessage = errorMessage
                        
                    }
                    
                    self.createAlert(title: "Login Error", message: displayErrorMessage)
                    
                }else{
                    
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                    
                }
                
            })
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if PFUser.current() != nil {
            
            performSegue(withIdentifier: "loginSegue", sender: self)
            
        }
        
        self.navigationController?.navigationBar.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
