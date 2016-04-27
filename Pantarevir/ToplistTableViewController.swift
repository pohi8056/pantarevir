//
//  ToplistTableViewController.swift
//  Pantarevir
//
//  Created by Anton Källbom on 18/04/16.
//  Copyright © 2016 PonyCorp Inc. All rights reserved.
//

import UIKit
import Firebase

class ToplistTableViewController: UITableViewController {

    var users = [String]()
    var amounts = [String]()
    var profilePictures = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadUsers()
    }
    
    /*func loadUsers() {
        let user1 = "Pontus"
        let user2 = "Anton"
        let user3 = "Lukas"
        
        let amount1 = "332"
        let amount2 = "237"
        let amount3 = "97"
        
        users += [user1, user2, user3]
        amounts += [amount1, amount2, amount3]
    }*/
    
    func loadUsers() {
        //let ref = DataService.service.userRef
        
        DataService.service.userRef.observeEventType(.Value, withBlock: { snapshot in
            
            // The snapshot is a current look at our jokes data.
            
            //print("KOLLA: \(snapshot.value)")
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    
                    // Make our jokes array for the tableView.
                    
                    
                    let name = "\(snap.value.objectForKey("name") as! String) \(snap.value.objectForKey("surname") as! String)"
                    let amount = snap.value.objectForKey("total") as! String
                    let facebookID = snap.value.objectForKey("fbID") as! String
                    let loginService = snapshot.value.objectForKey("provider") as! String
                    
                    if loginService == "facebook" {
                    
                    }
                        
                    self.users.insert(name, atIndex: 0)
                    self.amounts.insert(amount, atIndex: 0)
                    //print("USERS: \(self.users)")
                    
                }
                
            }
            
            // Be sure that the tableView updates when there is new data.
            
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ToplistTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ToplistTableViewCell
        
        let user = users[indexPath.row]
        let amount = amounts[indexPath.row]
        let profilePicture = profilePictures[indexPath.row]

        cell.positionLabel.text = "\(indexPath.row + 1)."
        cell.nameLabel.text = user
        cell.amountLabel.text = "\(amount) kr"
        cell.profilePicture.image = profilePicture.image
        
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.contentView.backgroundColor = UIColor.clearColor()
        
        let view : UIView = UIView(frame: CGRectMake(0, 10, self.view.frame.size.width, 120))
        
        view.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0, 0, 0, 0])
        view.layer.opacity = 50
        view.layer.masksToBounds = false
        
        cell.contentView.addSubview(view)
        cell.contentView.sendSubviewToBack(view)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
