//
//  ViewController.swift
//  Pantarevir
//
//  Created by Pontus Hilding on 12/04/16.
//  Copyright © 2016 PonyCorp Inc. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

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
/*
    func getAndStoreUserDataFromFacebookInFirebase(loginResults : FBSDKLoginManagerLoginResult){

        

    }
  */
    //Login via facebook.
    @IBAction func loginUserFacebook(sender: UIButton) {
        let loginViaFacebook = FBSDKLoginManager()
        
        loginViaFacebook.logInWithReadPermissions(["email"], fromViewController: self ,handler: {
            (facebookResult, facebookError) -> Void in
            
            if facebookError != nil{
                print("Failed to perform facebook login. Error: \(facebookError)")
            } else if facebookResult.isCancelled{
                print("Facebook login cancelled by the user.")
            } else{
                let facebookAccessToken = FBSDKAccessToken.currentAccessToken().tokenString
                
                DataService.service.rootRef.authWithOAuthProvider("facebook", token: facebookAccessToken, withCompletionBlock: {error, authData in
                    
                    if error != nil{
                        print("Failed to login.")
                    }else{
                        print("Logged in successfully via Facebook.")
                        let loginResults : FBSDKLoginManagerLoginResult = facebookResult
                        if loginResults.grantedPermissions.contains("email"){
                            //self.getAndStoreUserDataFromFacebookInFirebase(loginResults)
                            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, email, name, first_name, last_name, picture.type(large)"]).startWithCompletionHandler({(connection, result, error) -> Void in
                                
                                print(result["name"])
                                print(result["first_name"])
                                print(result["last_name"])
                                print(result["id"])
                                
                                let firstName = result["name"] as! String
                                let surName = result["last_name"] as! String
                                let email = result["email"] as! String
                             
                                //For later:
                                //let profilepic = result["picture.type(large)"]
                                
                                //----------IMPORTANT: CHECK IF VALUES ARE BEING OVERWRITTEN FOR A USER THAT LOGS OUT--------------------
                                
                                let newUser = ["provider": authData.provider!, "name" : firstName, "surname" : surName, "email" : email, "city" : "Uppsala", "belopptotal" : "0", "beloppvecka" : "0"]
                                DataService.service.createNewAccount(authData.uid, user: newUser)
                            })
                        }
                        self.performSegueWithIdentifier("fromLoginToMainMenuSegue", sender: nil)
                    }
                })
            }
        })
    }
    
    
    
    
    
    
}

