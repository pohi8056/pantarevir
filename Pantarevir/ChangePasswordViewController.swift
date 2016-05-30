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
    @IBOutlet weak var newPasswordConfirmTextField: UITextField!
    
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
        /*if (self.validateTextField(self.newPasswordTextField.text!) ||
            self.validateTextField(self.newPasswordConfirmTextField.text!) ||
            self.newPasswordTextField.text! != self.newPasswordConfirmTextField.text!) {
            self.setTextFieldBorderColor(self.newPasswordTextField)
            self.setTextFieldBorderColor(self.newPasswordConfirmTextField)
        }*/
        
        ref.changePasswordForUser(self.email, fromOld: oldPassword,
                                  toNew: newPassword, withCompletionBlock: { error in
                                    if (error != nil) {
                                        print("ERROR: \(error)")
                                        if (!(error.code == -6)) {
                                            self.setTextFieldBorderColor(self.tempPasswordTextField)
                                            let alertPopup = UIAlertController(title: "Fel", message: "Den temporära koden stämmer inte.", preferredStyle: UIAlertControllerStyle.Alert)
                                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { Void in
                                                //confirmedAmount = true
                                                //dispatch_semaphore_signal(semaphore)
                                            })
                                            
                                            //dispatch_async(backgroundQueue, {
                                            alertPopup.addAction(okAction)
                                            self.presentViewController(alertPopup, animated: true, completion: nil)
                                        }
                                        else if (self.validateTextField(self.newPasswordTextField.text!) ||
                                            self.validateTextField(self.newPasswordConfirmTextField.text!) ||
                                            self.newPasswordTextField.text! != self.newPasswordConfirmTextField.text!) {
                                            self.setTextFieldBorderColor(self.newPasswordTextField)
                                            self.setTextFieldBorderColor(self.newPasswordConfirmTextField)
                                        }
                                    } else {
                                        
                                        let alertPopup = UIAlertController(title: "", message: "Ditt lösenord har ändrats.", preferredStyle: UIAlertControllerStyle.Alert)
                                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { Void in
                                            self.performSegueWithIdentifier("fromChangePasswordToLoginSegue", sender: nil)
                                        })
                                                
                                        alertPopup.addAction(okAction)
                                        self.presentViewController(alertPopup, animated: true, completion: nil)
                                    }
        })
        
     }
    
    func validateTextField(textField : String) -> Bool{
        if textField == ""{
            return true
        }else{
            return false
        }
    }

    func setTextFieldBorderColor(textField: UITextField){
        //textField.borderStyle = UITextBorderStyle.Line
        textField.borderStyle = UITextBorderStyle.RoundedRect
        //textField.layer.masksToBounds = true
        textField.layer.borderColor = UIColor(red: 210/255, green: 0/255, blue: 0/255, alpha: 100/255).CGColor
        textField.layer.borderWidth = 1
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
