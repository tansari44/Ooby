//
//  HomeViewController.swift
//  Ooby
//
//  Created by Tanzil Ansari on 5/10/17.
//  Copyright © 2017 tansari. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var locationsTableView: UITableView!
    var locations = [String]()
    var locationIndex = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationsList()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.locationsTableView.reloadData()
        
    }
    
    func locationsList() {
        
        let query = PFUser.query()
        
        if let username = PFUser.current()?.username {
            
            query?.whereKey("username", equalTo: username)
            
            // iterates through Relation table to find Location relations
            query?.findObjectsInBackground(block: { (objects, error) in
                
                if let users = objects{
                    
                    for object in users{
                        
                        if let user = object as? PFUser{
                            
                            let location = user.relation(forKey:"Locations").query()
                            
                            location.findObjectsInBackground(block: { (objs, error) in
                                
                                if let locs = objs{
                                    
                                    for ob in locs{
                                        
                                        self.locations.append(ob["name"] as! String)
                                        print(ob["name"] as! String)

                                    }
                                    
                                }
                                
                                self.locationsTableView.reloadData()
                                
                            })
                            
                            
                        }
                        
                    }
                    
                }
                
                self.locationsTableView.reloadData()
                
            })
            
        }
        
        
    }
    
    // log out of application
    @IBAction func logout(_ sender: Any) {
        
        PFUser.logOut()
        dismiss(animated: true, completion: nil)
        
    }
    
    



    // MARK  - Locations Table

    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return locations.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "locationCell")
        cell.textLabel?.text = locations[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            let name = locations[indexPath.row]
            print(name)
            let query = PFQuery.init(className: "Location")
            query.whereKey("name", equalTo: name)
            
            // finds Location in Relation and removes them
            query.findObjectsInBackground(block: { (objects, error) in
                
                if let users = objects {
                    
                    for object in users {
                        
                        let currentUser = PFUser.current()
                        let relation = currentUser?.relation(forKey: "Locations")
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
            
            locations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
    }
    
    //MARK - Segues
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        locationIndex = indexPath.row
        performSegue(withIdentifier: "locationInfoSegue", sender: locations[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "locationInfoSegue"{
            
            let controller = segue.destination as! DetailsViewController
            controller.navigationItem.title = "Information"
            
            let name = locations[locationIndex]
            print(name)
            let query = PFQuery.init(className: "Location")
            query.whereKey("name", equalTo: name)
            
            query.findObjectsInBackground(block: { (objects, error) in
                
                if let users = objects {
                    
                    for object in users {
                        
                        let location = object
                        controller.locationNameLabel.text = location["name"] as? String
                        
                    }
                    
                }
                
            })
            
            
        }else if segue.identifier == "addLocationSegue"{
            
            let controller = segue.destination as! AddLocationViewController
            controller.navigationItem.title = "Add Location"
            
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

