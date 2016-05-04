//
//  ToplistViewController.swift
//  Pantarevir
//
//  Created by Anton Källbom on 18/04/16.
//  Copyright © 2016 PonyCorp Inc. All rights reserved.
//

import UIKit

class ToplistViewController: UIViewController {
    
    @IBOutlet weak var veckaOutlet: UIButton!
    @IBOutlet weak var totaltOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //veckaOutlet.titleLabel?.textColor = UIColor.grayColor()
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
    

    
    @IBAction func veckaButton(sender: UIButton) {
        containedVC.setVeckaState(true)
        //veckaOutlet.titleLabel?.textColor = UIColor.whiteColor()
        veckaOutlet.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        totaltOutlet.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)

    }
    
    @IBAction func totaltButton(sender: UIButton) {
        containedVC.setVeckaState(false)
        totaltOutlet.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        veckaOutlet.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
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
