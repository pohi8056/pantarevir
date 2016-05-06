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
    private var _timeStamp : Int!
    private var _amount : Double!
    private var _weekly : String!
    private var _total : String!
    
    
    var receiptEAN: String{
        return _receiptEAN
    }
    
    var userUID: String{
        return _userUID
    }
    
    var timeStamp: String{
        return "\(_timeStamp)"
    }
    
    var amount: String{
        return "\(_amount)"
    }
    
    var weekly: String{
        return _weekly
    }
    
    var total: String{
        return _total
    }
    
    
    init(receiptEAN : String, userUID : String, amount : Double){
        self._receiptEAN = receiptEAN
        self._userUID = userUID
        self._amount = amount
        
        let date = NSDate()
        let cal = NSCalendar.currentCalendar()
        let comps = cal.component([.Year, .Month, .Day, .Hour, .Minute], fromDate: date)
        self._timeStamp = comps
        
        self._receiptRef = DataService.service.receiptRef.childByAppendingPath(self._receiptEAN)
    }
    
    
    
    
    func prepareReceiptForFirebase() -> Dictionary<String, String>{
        let dic = ["UserID" : userUID, "time" : timeStamp, "amount" : amount, "ean" : receiptEAN]
        return dic
    }
}
