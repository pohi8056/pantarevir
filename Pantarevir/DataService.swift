//
//  DataService.swift
//  Pantarevir
//
//  Created by Pontus Hilding on 12/04/16.
//  Copyright © 2016 PonyCorp Inc. All rights reserved.
//

import Foundation
import Firebase
import MapKit


class DataService{
    
    static let service = DataService()
    
    private let _rootRef = Firebase(url: "\(ROOT_URL)")
    private let _userRef = Firebase(url: "\(ROOT_URL)/users")
    private var _receiptRef = Firebase(url: "\(ROOT_URL)/receipts")
    private var _citiesRef = Firebase(url: "\(ROOT_URL)/cities")
    private let _cityUserRef = Firebase(url: "\(ROOT_URL)/cities")
    
    enum Data{
        enum Branch{
            case User
            case City
            case Receipt
        }
        enum Value : String{
            case Name = "name"
            case Owner = "playerName"
            case Surname = "surname"
            case City = "city"
            case Email = "email"
            case Total = "total"
            case Weekly = "weekly"
            case FbID = "fbid"
            case Provider = "provider"
            case Amount = "amount"
            case Time = "time"
            case Uid = "UserID"
            case Color = "Color"
            case Street = "Gata"
            case Latitude = "Latitud"
            case Longitude = "Longitude"
            case Zip = "Postnr"
            case Radius = "Radie"
            case Belopp = "belopp"
        }
}
    

    
    //Load specific data, WORK IN PROGRESS
    func updateSpecificData(branch : Data.Branch, val : Data.Value, newEntry : AnyObject){

        
        //let semaphore = dispatch_semaphore_create(0)
        //print("Current thread \(NSThread.currentThread()).1")

        
        switch branch {
        case .User:
                print("yesp im here")
                //print("Current thread \(NSThread.currentThread()).2")

                DataService.service.currentUserRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                    //print("Current thread \(NSThread.currentThread()).3")
                    if val == Data.Value.Total{
                        print("HERE INSIDE TOTAL IN THE LOOP IN THE SWITCH")
                        let obtainedData = snapshot.value.objectForKey("\(val.rawValue)") as! Double
                        let tmpRec = newEntry as! Receipt
                        let newAmount = obtainedData + Double(tmpRec.amount)
                        print(tmpRec.amount)
                        print(newAmount)
                        self.userRef.childByAppendingPath(tmpRec.userUID).updateChildValues(["total" : newAmount])
                        self.userRef.childByAppendingPath(tmpRec.userUID).updateChildValues(["weekly" : newAmount])
                        
                    }
                    //print("sdf: \(snapshot.value)")
                    //obtainedData = snapshot.value.objectForKey("\(val.rawValue)") as! String
                    //print("Value obtained from \(val): \(obtainedData)")
                    //dispatch_semaphore_signal(semaphore)
                    }, withCancelBlock: { error in
                        print("Error retrieving \(val)")
                })

            case .City:
                DataService.service.citiesRef.observeEventType(.Value, withBlock: { snapshot in
                    let obtainedData = snapshot.value.objectForKey("\(val.rawValue)") as! String
                    print("Value obtained from \(val): \(obtainedData)")
                    
                    
                        
                    
                    }, withCancelBlock: { error in
                        print("Error retrieving \(val)")
                })

            case .Receipt:
                DataService.service.receiptRef.observeEventType(.Value, withBlock: { snapshot in
                let obtainedData = snapshot.value.objectForKey("\(val.rawValue)") as! String
                print("Value obtained from \(val): \(obtainedData)")
                //dispatch_semaphore_signal(semaphore)

                }, withCancelBlock: { error in
                    print("Error retrieving \(val)")
            })
            
        }

        print("Current thread \(NSThread.currentThread()).4")

        //print("obtained data: \(obtainedData)")

        //print("dispatch main queue: \(obtainedData)")

        //dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) //funkar med fast dispatch time
        print("Timed out.")
        //print("obtained data: \(obtainedData)")
        
        //return obtainedData
    }
    
    func updateUserIDList(city : String, receipt : Receipt){
        
        DataService.service.returnCityUserRef(city, store: receipt.store).observeSingleEventOfType(.Value, withBlock: { snapshot in
            print("A")
            if snapshot.value.objectForKey("\(receipt.userUID)") != nil{
                print("B")
                print(receipt.userUID)

                let obtainedData = snapshot.childSnapshotForPath("\(receipt.userUID)").value.objectForKey(Data.Value.Belopp.rawValue) as! Double
                print("C")
                
                let newAmount = obtainedData + receipt.amount
                self.returnCityUserRef(city, store: receipt.store).childByAppendingPath(receipt.userUID).updateChildValues([Data.Value.Belopp.rawValue : newAmount, Data.Value.Name.rawValue : receipt.name])
                print("D")
                
                self.updateStoreOwner(city, receipt: receipt, newValue: newAmount)
                
            }else {
                self.returnCityUserRef(city, store: receipt.store).childByAppendingPath(receipt.userUID).setValue([Data.Value.Belopp.rawValue : receipt.amount, Data.Value.Name.rawValue : receipt.name])
            }
            
           
            }, withCancelBlock: { error in
                print("Error with the userlist")
            
        })
    }
    
    func updateStoreOwner(city : String, receipt : Receipt, newValue: Double){
        
        DataService.service.returnCityStoreRef(city, store: receipt.store).observeSingleEventOfType(.Value, withBlock: { snapshot in

                
            let oldValue = snapshot.childSnapshotForPath("belopp").value as! Double
            
            if oldValue < newValue{
                //OBS: radie ökning med multipel 2
                
                self.returnCityStoreRef(city, store: receipt.store).updateChildValues([Data.Value.Belopp.rawValue : newValue, Data.Value.Owner.rawValue : receipt.name, Data.Value.Radius.rawValue: newValue*2, Data.Value.Uid.rawValue: receipt.userUID])
            }
            
            
            
            }, withCancelBlock: { error in
                print("Error with the storeowner")
                
        })
    }
    
    
    var citiesRef: Firebase {
        return _citiesRef
    }
    
    
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
    
    func createNewAccount(uid: String, user: Dictionary<String, AnyObject>) {
        userRef.childByAppendingPath(uid).setValue(user)
    }
    
    
    
    
    //NOTE TO TOMORROW: Read last total/weekly and add instead of overwrite.
    func addReceipt(receipt : Receipt){
        //test()
        updateSpecificData(.User, val: .Total, newEntry: receipt)
        print("kom hit")
        updateUserIDList("uppsala", receipt: receipt)
        //let newTotal = Double(previousTotal)! + Double(receipt.amount)!
        print("men inte hit")
        let variablesOfReceipt = receipt.prepareReceiptForFirebase()
        receiptRef.childByAppendingPath(receipt.receiptEAN).setValue(variablesOfReceipt)
        //returnCityRevirRef("uppsala").childByAppendingPath("ICA Nära Folkes Livs").updateChildValues([Data.Value.Belopp.rawValue : receipt.amount, Data.Value.Uid.rawValue : receipt.userUID])
    }
    
    func returnUserInCity(city : String, store : String, uid : String) -> Firebase{
        return self.citiesRef.childByAppendingPath("\(city)/revir/\(store)/UserIDList/\(uid)")
    }
    
    func returnCityUserRef(city : String, store : String) -> Firebase{
        return self.citiesRef.childByAppendingPath("\(city)/revir/\(store)/UserIDList")
    }
    
    func returnCityStoreRef(city : String, store : String) -> Firebase{
        return self.citiesRef.childByAppendingPath("\(city)/revir/\(store)")
    }
    
    func returnCityRevirRef(city : String)-> Firebase{
        return self.citiesRef.childByAppendingPath("\(city)/revir")
    }
    

    
    
    

}
