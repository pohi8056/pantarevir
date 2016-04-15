//
//  ViewController.swift
//  Pantarevir
//
//  Created by Pontus Hilding on 12/04/16.
//  Copyright © 2016 PonyCorp Inc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tmpAutoFillFields()
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil && DataService.service.currentUserRef.authData != nil{
            
            //Avkommentera sen! xD
            //self.performSegueWithIdentifier("fromLoginToMainMenuSegue", sender: nil
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func alertUserOfError(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)

    }
    
    func validateFields(field1 : String, field2 : String) -> Bool{
        if field1 != "" && field2 != ""{
            return true
        }else{
            return false
        }
        
    }
    
    func tmpAutoFillFields(){
        emailTextField.text = "noreply@ponycorp.com"
        passwordTextField.text = "Clark"
    }
    
    @IBAction func loginUser(sender: UIButton) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if validateFields(email!, field2: password!){
            
            DataService.service.rootRef.authUser(email, password: password, withCompletionBlock: {error, authData in
                
                if error != nil{
                    self.alertUserOfError("Kunde inte verifiera användare", msg: "Kontrollera dina uppgifter igen.")
                    self.passwordTextField.text = ""
                    print("Gick inte logga invettu")
                }else{
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                    self.performSegueWithIdentifier("fromLoginToMainMenuSegue", sender: nil)
                }
                
            })
            
            
        }
    }
    
    
    
    
    
}

