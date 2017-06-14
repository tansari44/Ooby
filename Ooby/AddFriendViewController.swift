//
//  AddFriendViewController.swift
//  Ooby
//
//  Created by Tanzil Ansari on 5/24/17.
//  Copyright © 2017 tansari. All rights reserved.
//

import UIKit
import Parse

class AddFriendViewController: UIViewController {

    
    @IBOutlet weak var userTextField: UITextField!
    
    
    @IBAction func addFriend(_ sender: Any) {
        
        if userTextField.text == "" {
            
            createAlert(title: "Error", message: "Please enter a username or email")
            
            
        }else{
            
            let query = PFUser.query()
            query?.whereKey("username", equalTo: userTextField.text!)
            
            query?.findObjectsInBackground(block: { (objects, error) in
                
                if let users = objects {
                    
                    for object in users {
                        
                        let currentUser = PFUser.current()
                        let relation = currentUser?.relation(forKey: "Friends")
                        relation?.add(object)
                        
                        currentUser?.saveInBackground(block: { (success, error) in
                            
                            if success {
                                
                                print("Object Saved")
                                self.createAlert(title: "Added Friend", message: "")
                                
                            }else{
                                
                                if let error = error{
                                    
                                    print(error)
                                    
                                }else{
                                    
                                    print("Error")
                                    
                                }
                                
                            }
                            
                        })
                        
                        
                        
                    }
                    
                }
                
            })
            
            
        }
        
    }
    
    
    
    func createAlert(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: false, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
