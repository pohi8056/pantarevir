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
            //self.performSegueWithIdentifier("fromLoginToMainMenuSegue", sender: nil)

            
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
        emailTextField.text = "clark@nielsen.corp"
        passwordTextField.text = "Clark"
    }
    
    //FIX VALIDATION OF DB ENTRIES, not just auth validatation!!!!!!
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
                    print("Logged in successfully via email/password")
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
        /* COULD BE DANGEROUS //The Pope */
        FBSDKAccessToken.setCurrentAccessToken(nil)
        FBSDKProfile.setCurrentProfile(nil)
        /*-----------------------------*/
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
                                let name = result["name"] as! String
                                let firstName = result["first_name"] as! String
                                let surName = result["last_name"] as! String
                                let email = result["email"] as! String
                                let fbID = result["id"] as! String //Used for retrieving profilepic
                                
                                //For later:
                                //let profilepic = result["picture.type(large)"]
                                
                                //----------IMPORTANT: CHECK IF VALUES ARE BEING OVERWRITTEN FOR A USER THAT LOGS OUT--------------------
                                DataService.service.userRef.observeSingleEventOfType(.Value, withBlock: { snapshot in 
                                    if snapshot.value.objectForKey(authData.uid) == nil{
                                        let newUser = ["provider": authData.provider!, "name" : firstName, "surname" : surName, "email" : email, "city" : "Uppsala", "total" : 0, "weekly" : 0, "fbID" : fbID]
                                        DataService.service.createNewAccount(authData.uid, user: newUser as! Dictionary<String, AnyObject>)
                                    }
                                    NSUserDefaults.standardUserDefaults().setValue(name, forKey: "name")
                                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                                    self.performSegueWithIdentifier("fromLoginToMainMenuSegue", sender: nil)

                                    
                                    }, withCancelBlock: { error in
                                        print("Error looking for existing user.")
                                })
                                

                                //NSUserDefaults.standardUserDefaults().setValue(name, forKey: "name")

                            })
                                //NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                        }
                        //self.performSegueWithIdentifier("fromLoginToMainMenuSegue", sender: nil)
                    }
                })
            }
        })
    }
    
    
    
    
    
    
}

