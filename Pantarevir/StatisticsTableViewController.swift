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
    var amount = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadStatistics()
    }
    
    //  Räkna på: 0.1574 kWh/kr samt 0.1574 kg/kr i belopp.
    func convertAmount(amount : Double) -> Double {
        //print ("JKDSFKJNSKF: \(Double(amount) * 0.1574)")
        return (amount * 0.1574)
    }
    
    func convertToString(value : Int, unitSingular : String, unitPlural : String) -> String {
        var valueString = ""
        if (value != 0) {
            if (value >= 2) {
                valueString = "\(String(value)) \(unitPlural)"
            }
            else {
                valueString = "\(String(value)) \(unitSingular)"
            }
        }
        return valueString
    }
    
    func convertMinutesToMessage(data : Int) -> String {
        let years = data / 525600
        let months = (data % 525600) / 43800
        let weeks = (data % 43800) / 10080
        let days = (data % 10080) / 1440
        let hours = (data % 1440) / 60
        let minutes = (data % 60)
        
        var yearString = ""
        var monthString = ""
        var weekString = ""
        var dayString = ""
        var hourString = ""
        var minuteString = ""
        
        yearString = convertToString(years, unitSingular: "år", unitPlural: "år")
        monthString = convertToString(months, unitSingular: "månad", unitPlural: "månader")
        weekString = convertToString(weeks, unitSingular: "vecka", unitPlural: "veckor")
        
        if (yearString == "") {
           dayString = convertToString(days, unitSingular: "dag", unitPlural: "dagar")
        }
        
        if (monthString == "") {
            hourString = convertToString(hours, unitSingular: "timme", unitPlural: "timmar")
        }
        
        if (weekString == "") {
            minuteString = convertToString(minutes, unitSingular: "minut", unitPlural: "minuter")
        }
        
        return "\(yearString) \(monthString) \(weekString) \(dayString) \(hourString) \(minuteString)"
    }
    
    func loadStatistics() {
        
        /*DataService.service.currentUserRef.observeEventType(.Value, withBlock: { snapshot in
            let totalOfCurrentUser = snapshot.value.objectForKey("total") as! String
            print("FIRST: \(totalOfCurrentUser)")
            
            self.amount = totalOfCurrentUser
        })*/

        self.activities.insert(ActivityInfo(type: "shower", amount: convertAmount(self.amount)), atIndex: 0)
        self.activities.insert(ActivityInfo(type: "computer", amount: convertAmount(self.amount)), atIndex: 0)
        self.activities.insert(ActivityInfo(type: "house", amount: convertAmount(self.amount)), atIndex: 0)
        self.activities.insert(ActivityInfo(type: "dryer", amount: convertAmount(self.amount)), atIndex: 0)
        self.activities.insert(ActivityInfo(type: "microwave", amount: convertAmount(self.amount)), atIndex: 0)
        self.activities.insert(ActivityInfo(type: "charger", amount: convertAmount(self.amount)), atIndex: 0)
        self.activities.insert(ActivityInfo(type: "lamp", amount: convertAmount(self.amount)), atIndex: 0)
        self.activities.insert(ActivityInfo(type: "car", amount: convertAmount(self.amount)), atIndex: 0)
        self.activities.insert(ActivityInfo(type: "bus", amount: convertAmount(self.amount)), atIndex: 0)
        self.activities.insert(ActivityInfo(type: "food", amount: convertAmount(self.amount)), atIndex: 0)
        
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
            cell.dataLabel.text = "\(String(activity.dataInt)) mil"
        }
        
        else if (activity.type == "flight") {
            cell.dataLabel.text = "\(String(activity.dataInt)) %"
        }
            
        else if (activity.type == "bus" || activity.type == "food") {
            cell.dataLabel.text = "\(String(activity.dataInt)) st"
        }
            
        else {
            cell.dataLabel.text = "\(convertMinutesToMessage(activity.dataInt))"
        }
        
        cell.titleLabel.text = activity.title
        cell.explanationLabel.text = activity.description
        
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
                
        return cell
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
