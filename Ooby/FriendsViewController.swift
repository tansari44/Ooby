//
//  SecondViewController.swift
//  Ooby
//
//  Created by Tanzil Ansari on 5/10/17.
//  Copyright © 2017 tansari. All rights reserved.
//

import UIKit
import Parse

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var friendsListTableView: UITableView!
    
    var usernames = [String]()
    var userIDs = [String]()
    var friends = [String]()
    var friendIndex = 0


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsList()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.friendsListTableView.reloadData()
        
    }
    
    // method to retrieve friends list
    func friendsList() {
        
        let query = PFUser.query()
        
        if let username = PFUser.current()?.username {
            
            query?.whereKey("username", equalTo: username)
            
            // iterates through Relation table to find Friend relations
            query?.findObjectsInBackground(block: { (objects, error) in
                
                if let users = objects{
                    
                    for object in users{
                        
                        if let user = object as? PFUser{
                            
                            let friend = user.relation(forKey:"Friends").query()
                            
                            friend.findObjectsInBackground(block: { (objs, error) in
                                
                                if let usrs = objs{
                                    
                                    for ob in usrs{
                                        
                                        if let usr = ob as? PFUser{
                                            
                                            self.friends.append(usr.username!)
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                                self.friendsListTableView.reloadData()
                                
                            })
                            
                            
                        }
                        
                    }
                    
                }
                
                self.friendsListTableView.reloadData()
                
            })
            
        }
        
        
    }
 
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friends.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "locationCell")
        cell.textLabel?.text = friends[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // method to delete a friend from Friends List
        if editingStyle == .delete{
            
            let username = friends[indexPath.row]
            print(username)
            let query = PFUser.query()
            query?.whereKey("username", equalTo: username)
            
            // finds friend in Relation and removes them
            query?.findObjectsInBackground(block: { (objects, error) in
                
                if let users = objects {
                    
                    for object in users {
                        
                        let currentUser = PFUser.current()
                        let relation = currentUser?.relation(forKey: "Friends")
                        relation?.remove(object)
                        print("Success")
                        
                        currentUser?.saveInBackground(block: { (success, error) in
                            
                            if success {
                                
                                print("Object Saved")
                                
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
            
            self.friends.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        
        return "Remove"
        
    }
    
    
    //MARK - Segues
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        friendIndex = indexPath.row
        performSegue(withIdentifier: "friendInfoSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "friendInfoSegue"{
            
            let controller = segue.destination as! FriendInfoViewController
            controller.navigationItem.title = "Information"
            
            let username = friends[friendIndex]
            print(username)
            let query = PFUser.query()
            query?.whereKey("username", equalTo: username)
            
            query?.findObjectsInBackground(block: { (objects, error) in

                if let users = objects {
                    
                    for object in users {
                        
                        let currentUser = object as? PFUser
                        controller.usernameLabel.text = currentUser?.username
                        
                    }
                    
                }
                
            })
            
            
        }else if segue.identifier == "addFriendSegue"{
         
            let controller = segue.destination as! AddFriendViewController
            controller.navigationItem.title = "Add Friend"
            
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
