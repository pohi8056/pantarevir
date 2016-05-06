//
//  StatisticsTableViewController.swift
//  Pantarevir
//
//  Created by Anton Källbom on 04/05/16.
//  Copyright © 2016 PonyCorp Inc. All rights reserved.
//

import UIKit
import Firebase

class StatisticsTableViewController: UITableViewController {

    var activities = [ActivityInfo]()
    var amount: Double = 27
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadStatistics()
    }

    //  Räkna på: 0.1574 kWh/kr samt 0.1574 kg/kr i belopp.
    func convertAmount(amount : Int) -> Double {
        return (Double(amount) * 0.1574)
    }
    
    func convertMinutes(data : Int) -> String {
        
        /*var totalMinutes = data
        
        var yearsString = ""
        var weeksString = ""
        var daysString = ""
        var hoursString = ""
        var minutesString = ""
        
        var yearUnit = ""
        var weekUnit = ""
        var dayUnit = ""
        var hourUnit = ""
        var minuteUnit = ""

        let years = data / 3679200
        let weeks = data / 10080
        let days = data / 1440*/
        let hours = data / 60
        let minutes = data % 60
        
        return "\(hours) tim, \(minutes) min"
    }
    
    func loadStatistics() {
        
        /*DataService.service.currentUserRef.observeEventType(.Value, withBlock: { snapshot in
            let totalOfCurrentUser = snapshot.value.objectForKey("total") as! String
            print("FIRST: \(totalOfCurrentUser)")
            
            self.amount = totalOfCurrentUser
        })*/

        self.activities.insert(ActivityInfo(type: "shower", amount: self.amount), atIndex: 0)
        self.activities.insert(ActivityInfo(type: "computer", amount: self.amount), atIndex: 0)
        self.activities.insert(ActivityInfo(type: "house", amount: self.amount), atIndex: 0)
        self.activities.insert(ActivityInfo(type: "dryer", amount: self.amount), atIndex: 0)
        self.activities.insert(ActivityInfo(type: "microwave", amount: self.amount), atIndex: 0)
        self.activities.insert(ActivityInfo(type: "charger", amount: self.amount), atIndex: 0)
        self.activities.insert(ActivityInfo(type: "lamp", amount: self.amount), atIndex: 0)
        self.activities.insert(ActivityInfo(type: "car", amount: self.amount), atIndex: 0)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return activities.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "StatisticsTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! StatisticsTableViewCell

        let activity = activities[indexPath.row]
        
        if (activity.type == "car") {
            cell.dataLabel.text = "\(String(activity.dataInt)) km"
        }
        else {
            cell.dataLabel.text = "\(convertMinutes(activity.dataInt))"
        }

        
        cell.titleLabel.text = activity.title
        cell.explanationLabel.text = activity.description
        
        print(activity.dataInt)
        
        return cell
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
