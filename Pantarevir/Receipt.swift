//
//  Receipt.swift
//  Pantarevir
//
//  Created by Pontus Hilding on 04/05/16.
//  Copyright © 2016 PonyCorp Inc. All rights reserved.
//

import Foundation
import Firebase

class Receipt{
    
    private var _receiptRef : Firebase!
    private var _receiptEAN : String!
    private var _userUID : String!
    private var _timeStamp : String!
    private var _amount : Double!
    private var _weekly : Double!
    private var _total : Double!
    private var _name : String!
    
    
    var name: String{
        return _name
    }
    
    var receiptEAN: String{
        return _receiptEAN
    }
    
    var userUID: String{
        return _userUID
    }
    
    var timeStamp: String{
        return _timeStamp
    }
    
    var amount: Double{
        return _amount
    }
    
    var weekly: Double{
        return _weekly
    }
    
    var total: Double{
        return _total
    }
    
    
    init(receiptEAN : String, userUID : String, amount : Double){
        self._receiptEAN = receiptEAN
        self._userUID = userUID
        self._amount = amount
        self._name = NSUserDefaults.standardUserDefaults().stringForKey("name")

        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        let dateWithFormat = dateFormatter.stringFromDate(date)
        self._timeStamp = dateWithFormat
        
        self._receiptRef = DataService.service.receiptRef.childByAppendingPath(self._receiptEAN)
    }
    
    
    
    
    func prepareReceiptForFirebase() -> Dictionary<String, AnyObject>{
        let dic = ["UserID" : userUID, "time" : timeStamp, "amount" : amount, "ean" : receiptEAN]
        return dic as! Dictionary<String, AnyObject>
    }
}
