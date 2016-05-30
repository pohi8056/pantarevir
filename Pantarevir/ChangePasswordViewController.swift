//
//  ChangePasswordViewController.swift
//  Pantarevir
//
//  Created by Anton Källbom on 29/05/16.
//  Copyright © 2016 PonyCorp Inc. All rights reserved.
//

import UIKit
import Firebase

class ChangePasswordViewController: UIViewController {
    let ref = Firebase(url: "https://pantarevir.firebaseio.com")
    
    @IBOutlet weak var tempPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    var email: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changePasswordButton(sender: UIButton) {
        let oldPassword = tempPasswordTextField.text
        let newPassword = newPasswordTextField.text
        ref.changePasswordForUser(self.email, fromOld: oldPassword,
                                  toNew: newPassword, withCompletionBlock: { error in
                                    if error != nil {
                                        print("Felmeddelande")
                                        let alertPopup = UIAlertController(title: "Fel", message: "Det temporära lösenordet stämmer inte.", preferredStyle: UIAlertControllerStyle.Alert)
                                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { Void in
                                            //confirmedAmount = true
                                            //dispatch_semaphore_signal(semaphore)
                                        })
                                        
                                        //dispatch_async(backgroundQueue, {
                                        alertPopup.addAction(okAction)
                                        self.presentViewController(alertPopup, animated: true, completion: nil)
                                    } else {
                                        print("Lösenordet har ändrats")
                                        self.performSegueWithIdentifier("fromForgotPasswordToChangePasswordSegue", sender: nil)
                                    }
        })
    }
    
    @IBAction func cancelButton(sender: UIButton) {
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
