//
//  ForgotPasswordViewController.swift
//  Pantarevir
//
//  Created by Pontus Hilding on 12/04/16.
//  Copyright © 2016 PonyCorp Inc. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {

    var userEmails = [String]()
    let ref = Firebase(url: "https://pantarevir.firebaseio.com")
    
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadUserEmails()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadUserEmails() {
        DataService.service.userRef.observeEventType(.Value, withBlock: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                self.userEmails.removeAll()
                for snap in snapshots {
                    
                    let provider = snap.value.objectForKey("provider") as! String
                    let userEmail = snap.value.objectForKey("email") as! String
                    
                    if (provider != "facebook") {
                        self.userEmails.insert(userEmail, atIndex: 0)
                        print("INTE FB")
                    }
                    else {
                        print("FB")
                    }
                }
            }
        })
    }
    
    func checkEmailExistance(email: String) -> Bool {
        if self.userEmails.contains(email) {
            print("TRUEEH")
            return true
        }
        else {
            print("FALSEEE")
            return false
        }
    }
    
    @IBAction func resetPasswordButton(sender: UIButton) {
        let email = emailTextField.text
        
        if (checkEmailExistance(email!) == false) {
            let alertPopup = UIAlertController(title: "Fel", message: "Angiven e-postadress existerar ej.", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { Void in
                print("CONFIRMHERE")
                //confirmedAmount = true
                //dispatch_semaphore_signal(semaphore)
            })

            //dispatch_async(backgroundQueue, {
            alertPopup.addAction(okAction)
            self.presentViewController(alertPopup, animated: true, completion: nil)
        }
            
        else {
            ref.resetPasswordForUser(email, withCompletionBlock: { error in
                if error != nil {
                    print("Felmeddelande: \(error)")
                } else {
                    print("Lösenord skickat via e-post")
                    self.performSegueWithIdentifier("fromForgotPasswordToChangePasswordSegue", sender: nil)
                }
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "fromForgotPasswordToChangePasswordSegue" {
            let changePasswordViewController = segue.destinationViewController as! ChangePasswordViewController
            changePasswordViewController.email = self.emailTextField.text!
        }
    }
    
    @IBAction func backButton(sender: UIButton) {
        let menuView = self.storyboard!.instantiateViewControllerWithIdentifier("Login")
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
