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
    
    
  
    
    /* Checks whether the textfield has any input */
    func validateTextField(textField : String) -> Bool{
        if textField == ""{
            return true
        }else{
            return false
        }
    }
    
    /* Changes the border color of the textfield to red. */
    func setTextFieldBorderColor(textField: UITextField){
        textField.borderStyle = UITextBorderStyle.Line
        //textField.layer.masksToBounds = true
        textField.layer.borderColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 150/255).CGColor
        textField.layer.borderWidth = 1

    }
    
    /* Checks whether the passwords match. */

    
    func doIncorrectTextFieldsRed(){
        
        if validateTextField(nameField.text!){
            setTextFieldBorderColor(nameField)
        }else{
            nameField.borderStyle = UITextBorderStyle.None
            nameField.layer.borderWidth = 0
        }
        
        if validateTextField(surnameField.text!){
            setTextFieldBorderColor(surnameField)
        }else{
            surnameField.borderStyle = UITextBorderStyle.None
            surnameField.layer.borderWidth = 0
        }
        
        if validateTextField(emailField.text!){
            setTextFieldBorderColor(emailField)
        }else{
            emailField.borderStyle = UITextBorderStyle.None
            emailField.layer.borderWidth = 0
        }
        
        if validateTextField(password1Field.text!) || validateTextField(password2Field.text!) || password1Field.text! != password2Field.text!{
            setTextFieldBorderColor(password1Field)
            setTextFieldBorderColor(password2Field)
        }else{
            password1Field.borderStyle = UITextBorderStyle.None
            password1Field.layer.borderWidth = 0
            password2Field.borderStyle = UITextBorderStyle.None
            password2Field.layer.borderWidth = 0
        }
        /*
        if validateTextField(password2Field.text!){
            setTextFieldBorderColor(password2Field)
        }else{
            password2Field.borderStyle = UITextBorderStyle.None
            password2Field.layer.borderWidth = 0
        }
         */
    }
    
    
    /*
     Create a new user from the textfields' information.
    */
    
    @IBAction func createAccount(sender: UIButton) {
        let name = nameField.text
        let surname = surnameField.text
        let email = emailField.text
        let password1 = password1Field.text
        let password2 = password1Field.text
        
        doIncorrectTextFieldsRed()
        
        
    }


}
