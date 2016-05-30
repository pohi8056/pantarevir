//
//  CreateAccountViewController.swift
//  Pantarevir
//
//  Created by Pontus Hilding on 12/04/16.
//  Copyright © 2016 PonyCorp Inc. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var password1Field: UITextField!
    @IBOutlet weak var password2Field: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        surnameField.delegate = self
        emailField.delegate = self
        password1Field.delegate = self
        password2Field.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.layer.borderWidth = 0
    }

    /* Checks whether the textfield has any input */
    func validateTextField(textField : String) -> Bool{
        if textField == ""{
            return true
        }else{
            return false
        }
    }
    
    /* Validates if email is given in correct format*/
    func validateEmail(testStr:String) -> Bool {
        let validSymbols = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", validSymbols)
        return testEmail.evaluateWithObject(testStr)
    }
    

    /* Changes the border color of the textfield to red. */
    func setTextFieldBorderColor(textField: UITextField){
        //textField.borderStyle = UITextBorderStyle.Line
        textField.borderStyle = UITextBorderStyle.RoundedRect
        //textField.layer.masksToBounds = true
        textField.layer.borderColor = UIColor(red: 210/255, green: 0/255, blue: 0/255, alpha: 100/255).CGColor
        textField.layer.borderWidth = 1
    }

    /* Makes a red border around incorrect textfields. Checks whether passwords matches and returns true if all is correct. */
    func doIncorrectTextFieldsRed() -> Bool{
        let numberOfTextFields = 4
        var correctNumberOfTextFields = 0

        if validateTextField(nameField.text!){
            setTextFieldBorderColor(nameField)
        }else{
            nameField.borderStyle = UITextBorderStyle.RoundedRect
            nameField.layer.borderWidth = 0
            correctNumberOfTextFields += 1
        }

        if validateTextField(surnameField.text!){
            setTextFieldBorderColor(surnameField)
        }else{
            surnameField.borderStyle = UITextBorderStyle.RoundedRect
            surnameField.layer.borderWidth = 0
            correctNumberOfTextFields += 1
        }

        if validateTextField(emailField.text!) || !validateEmail(emailField.text!){
            setTextFieldBorderColor(emailField)
        }else{
            emailField.borderStyle = UITextBorderStyle.RoundedRect
            emailField.layer.borderWidth = 0
            correctNumberOfTextFields += 1
        }

        if validateTextField(password1Field.text!) || validateTextField(password2Field.text!) || password1Field.text! != password2Field.text!{
            setTextFieldBorderColor(password1Field)
            setTextFieldBorderColor(password2Field)
        }else{
            password1Field.borderStyle = UITextBorderStyle.RoundedRect
            password1Field.layer.borderWidth = 0
            password2Field.borderStyle = UITextBorderStyle.RoundedRect
            password2Field.layer.borderWidth = 0
            correctNumberOfTextFields += 1
        }

        if numberOfTextFields == correctNumberOfTextFields{
            return true
        }else{
            return false
        }
    }


    /*
     Create a new user from the textfields' information.
    */

    @IBAction func createAccount(sender: UIButton) {
        let name = nameField.text
        let surname = surnameField.text
        let email = emailField.text
        let password = password1Field.text
        let city = "Uppsala"
        //let password2 = password1Field.text
        
        if doIncorrectTextFieldsRed(){
            print("ALL CORRECT!")
                
            DataService.service.rootRef.createUser(email, password: password, withValueCompletionBlock: {error, result in
                
                if error != nil{
                    print("Fel vid skapande av konto. Vänligen försök igen! \(error)")
                }else{
                        DataService.service.rootRef.authUser(email, password: password, withCompletionBlock: {
                        err, authData in
                            let newUser = ["provider": authData.provider!, "name": name!, "surname": surname!, "email": email!, "city": city, "total": 0, "weekly": 0, "fbID" : "0"]
                        DataService.service.createNewAccount(authData.uid, user: newUser as! Dictionary<String, AnyObject>)
                    })
                    
                    NSUserDefaults.standardUserDefaults().setValue(result ["uid"], forKey: "uid")
                    self.dismissViewControllerAnimated(true, completion: {})
                }
                
            })
            
        }
    }
    
    /* Dismiss the view controller when cancel is pushed */
    @IBAction func cancelRegistration(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    
    
    
    
    
}