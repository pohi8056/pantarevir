//
//  UserInfo.swift
//  Pantarevir
//
//  Created by Pontus Hilding on 12/04/16.
//  Copyright © 2016 PonyCorp Inc. All rights reserved.
//

import UIKit

class UserInfo{
    // M I A M I V I C E L U L L
    
    // user details
    var firstName:      String?
    var surname:        String?
    var name:           String?
    var profilePicture: UIImageView?
    var city:           String?

    
    // login details
    var fbID:       String?
    var provider:   String?
    var email:      String?
    
    // amount
    var amount:     String?
    var total:      Int?
    var weekly:     Int?
    
    
    // antes: untouched
    init(name: String, amount: String, profilePicture: UIImageView){
        self.name = name
        self.amount = amount
        self.profilePicture = profilePicture
    }
    
    
    // M I A M I V I C E L U L L
    init(firstName: String, surname: String, total: Int, weekly: Int, profilePicture: UIImageView, city: String, fbID: String, provider: String, email: String){

        self.firstName      = firstName
        self.surname        = surname
        self.name           = "\(firstName) \(surname)"
        self.city           = city
        self.profilePicture = profilePicture
        
        
        // login details
        self.fbID           = fbID
        self.provider       = provider
        self.email          = email
        
        // amount
        self.amount         = String(total)
        self.total          = total
        self.weekly         = weekly
        
    }
    
    
    func returnName() -> String{
        return name!
    }
    
    func returnAmount() -> String{
        return amount!
    }
    
    func returnAmountInt() -> Int{
        return Int(amount!)!
    }
}