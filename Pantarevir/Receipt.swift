//
//  Receipt.swift
//  Pantarevir
//
//  Created by Pontus Hilding on 04/05/16.
//  Copyright © 2016 PonyCorp Inc. All rights reserved.
//

import Foundation

class Receipt{
    
    private var _receiptEAN : String!
    private var _userUID : String!
    private var _timeStamp : Int!
    
    
    var receiptEAN: String{
        return _receiptEAN
    }
    
    var userUID: String{
        return _userUID
    }
    
    var timeStamp: String{
        return "\(_timeStamp)"
    }
    
    init(receiptEAN : String, userUID : String){
        self._receiptEAN = receiptEAN
        self._userUID = userUID
        let date = NSDate()
        let cal = NSCalendar.currentCalendar()
        let comps = cal.component([.Year, .Month, .Day, .Hour, .Minute], fromDate: date)
        self._timeStamp = comps
    }
    
    
    
}
