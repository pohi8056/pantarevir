//
//  StatisticsViewController.swift
//  Pantarevir
//
//  Created by Anton Källbom on 07/05/16.
//  Copyright © 2016 PonyCorp Inc. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    var userAmount: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textLabel.text = "Din återvinning på \(self.userAmount) kr motsvarar..."
        
        //veckaOutlet.titleLabel?.textColor = UIColor.grayColor()
        // Do any additional setup after loading the view.
    }
    
    var containedVC: StatisticsTableViewController!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embedContainedStatistics" {
            containedVC = segue.destinationViewController as! StatisticsTableViewController
            containedVC.amount = userAmount
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(sender: UIButton) {
        let menuView = self.storyboard!.instantiateViewControllerWithIdentifier("MainMenu")
        UIApplication.sharedApplication().keyWindow?.rootViewController = menuView
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
