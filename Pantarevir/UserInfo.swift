//
//  UserInfo.swift
//  Pantarevir
//
//  Created by Pontus Hilding on 12/04/16.
//  Copyright © 2016 PonyCorp Inc. All rights reserved.
//

import UIKit

class UserInfo{
    
    
    var name: String
    var amount: String
    var profilePicture: UIImageView
    
    init(name: String, amount: String, profilePicture: UIImageView){
        self.name = name
        self.amount = amount
        self.profilePicture = profilePicture
    }
    
    func returnName() -> String{
        return name
    }
    
    func returnAmount() -> String{
        return amount
    }
    
    func returnAmountInt() -> Int{
        return Int(amount)!
    }
}