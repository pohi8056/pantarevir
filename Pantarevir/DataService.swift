//
//  DataService.swift
//  Pantarevir
//
//  Created by Pontus Hilding on 12/04/16.
//  Copyright © 2016 PonyCorp Inc. All rights reserved.
//

import Foundation
import Firebase

class DataService{

    static let service = DataService()

    private var _rootRef = Firebase(url: "\(ROOT_URL)")
    private var _userRef = Firebase(url: "\(ROOT_URL)/users")
    private var _receiptRef = Firebase(url: "\(ROOT_URL)/receipts")

    var rootRef: Firebase {
        return _rootRef
    }

    var userRef: Firebase {
        return _userRef
    }
    
    var receiptRef: Firebase {
        return _receiptRef
    }
    
    var currentUserRef: Firebase {
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
    
        let currentUser = Firebase(url: "\(rootRef)").childByAppendingPath("users").childByAppendingPath(userID)
    
        return currentUser!
    }

    func createNewAccount(uid: String, user: Dictionary<String, String>) {
        userRef.childByAppendingPath(uid).setValue(user)
    }
    
    func addReceipt(receipt : Receipt){
       receiptRef.childByAppendingPath(receipt.receiptEAN).setValue(receipt)
    }

}
