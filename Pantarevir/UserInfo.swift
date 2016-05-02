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
    //var profilePicture: UIImageView
    
    //TODO: Insert profilePicture in init()!
    init(name: String, amount: String){
        self.name = name
        self.amount = amount
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