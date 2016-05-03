//
//  ToplistViewController.swift
//  Pantarevir
//
//  Created by Anton Källbom on 18/04/16.
//  Copyright © 2016 PonyCorp Inc. All rights reserved.
//

import UIKit

class ToplistViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        veckaOutlet.titleLabel!.textColor = UIColor.grayColor()
        // Do any additional setup after loading the view.
    }

    var containedVC: ToplistTableViewController!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embedContainedToplist" {
            containedVC = segue.destinationViewController as! ToplistTableViewController
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var veckaOutlet: UIButton!
    @IBOutlet weak var totaltOutlet: UIButton!
    
    @IBAction func veckaButton(sender: UIButton) {
        containedVC.setVeckaState(true)
        sender.titleLabel?.textColor = UIColor.whiteColor()
        totaltOutlet.titleLabel?.textColor = UIColor.grayColor()
    }
    
    @IBAction func totaltButton(sender: UIButton) {
        containedVC.setVeckaState(false)
        sender.titleLabel?.textColor = UIColor.whiteColor()
        veckaOutlet.titleLabel?.textColor = UIColor.grayColor()
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
