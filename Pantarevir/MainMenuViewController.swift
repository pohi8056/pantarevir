//
//  MainMenuViewController.swift
//  Pantarevir
//
//  Created by Pontus Hilding on 12/04/16.
//  Copyright © 2016 PonyCorp Inc. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    
    @IBAction func PantaDittRevirButton(sender: UIButton) {
    }
    
    @IBAction func RevirkartaButton(sender: UIButton) {
    }
    
    @IBAction func DinStatistikButton(sender: UIButton) {
    }
    
    @IBAction func TopplistaButton(sender: UIButton) {
    }
    
    @IBAction func LoggaUtButton(sender: UIButton) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DataService.service.currentUserRef.observeEventType(.Value, withBlock: { snapshot in
            let nameOfCurrentUser = snapshot.value.objectForKey("name") as! String
            let surnameOfCurrentUser = snapshot.value.objectForKey("surname") as! String
            let totalOfCurrentUser = snapshot.value.objectForKey("total") as! String
            let facebookID = snapshot.value.objectForKey("fbID") as! String
            
            if facebookID != "0"{
                let facebookProfilePictureURL = NSURL(string: "https://graph.facebook.com/\(facebookID)/picture?type=large")
                self.setProfileImage(facebookProfilePictureURL!)
            }
            self.nameLabel.text = "\(nameOfCurrentUser) \(surnameOfCurrentUser)"
            self.amountLabel.text = "\(totalOfCurrentUser) kr"
            }, withCancelBlock: { error in
                print("Error retrieving or displaying the user's name.")
        })
 
 
    }
    
    
    func setProfileImage(imageURL : NSURL){
        let obtainedImage = NSData(contentsOfURL: imageURL)
        if obtainedImage != nil{
            self.profilePicture.image = UIImage(data: obtainedImage!)
            
            //----------------------------FIX PLS UX DEPARTMENT.------------------------------------//
            
            self.profilePicture.layer.borderWidth = 1
            self.profilePicture.layer.masksToBounds = false
            self.profilePicture.layer.borderColor = UIColor.whiteColor().CGColor
            self.profilePicture.layer.cornerRadius = profilePicture.frame.size.width/1.5
            self.profilePicture.clipsToBounds = true
            
            //--------------------------------------------------------------------------------------//
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
