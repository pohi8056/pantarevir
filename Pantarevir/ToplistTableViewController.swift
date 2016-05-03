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

    var users = [UserInfo]()
    var names = [String]()
    var amounts = [String]()
    var profilePictures = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadUsers()
    }
    
    func loadUsers() {
        //let ref = DataService.service.userRef
        
        DataService.service.userRef.observeEventType(.Value, withBlock: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots {
                    
                    let name = "\(snap.value.objectForKey("name") as! String) \(snap.value.objectForKey("surname") as! String)"
                    let amount = snap.value.objectForKey("total") as! String
                    
                    //För att fixa FB-profilbilderna
                    /*let facebookID = snap.value.objectForKey("fbID") as! String
                    let loginService = snapshot.value.objectForKey("provider") as! String
                    
                    if loginService == "facebook" {
                    
                    }*/
                    
                    self.users.insert(UserInfo(name: name, amount: amount), atIndex: 0)
                }
            }
            
            self.users.sortInPlace({ $0.amount > $1.amount })
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
        //let profilePicture = profilePictures[indexPath.row]

        cell.positionLabel.text = "\(indexPath.row + 1)."
        cell.nameLabel.text = user.name
        cell.amountLabel.text = "\(user.amount) kr"
        //cell.profilePicture.image = profilePicture.image
        
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 48.0
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.contentView.backgroundColor = UIColor.clearColor()
        
        let view : UIView = UIView(frame: CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height))
        
        view.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0, 0, 0, 0])
        view.layer.opacity = 50
        view.layer.masksToBounds = false
        
        cell.contentView.addSubview(view)
        cell.contentView.sendSubviewToBack(view)
        
        //tableView.tableFooterView = UIView(frame: .zero)
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
