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
    
    func updateUserIDList(city : String, store : String, receipt : Receipt){
        
        DataService.service.returnCityUserRef(city, store: store).observeSingleEventOfType(.Value, withBlock: { snapshot in
            print("A")
            if snapshot.value.objectForKey("\(receipt.userUID)") != nil{
                print("B")
                print(receipt.userUID)

                let obtainedData = snapshot.childSnapshotForPath("\(receipt.userUID)").value.objectForKey(Data.Value.Belopp.rawValue) as! Double
                print("C")
                
                let newAmount = obtainedData + receipt.amount
                self.returnCityUserRef(city, store: store).childByAppendingPath(receipt.userUID).updateChildValues([Data.Value.Belopp.rawValue : newAmount, Data.Value.Name.rawValue : receipt.name])
                print("D")
            }else {
                self.returnCityUserRef(city, store: store).childByAppendingPath(receipt.userUID).setValue([Data.Value.Belopp.rawValue : receipt.amount, Data.Value.Name.rawValue : receipt.name])
            }
           
            }, withCancelBlock: { error in
                print("Error with the userlist")
            
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
        updateUserIDList("uppsala", store: "ICA Nära Folkes Livs", receipt: receipt)
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
    
    func returnCityRevirRef(city : String)-> Firebase{
        return self.citiesRef.childByAppendingPath("\(city)/revir")
    }
    
 /*
    // M I A M I V I C E L U L L
    // obs! cunncurency issues?
    func loadUsers() -> [UserInfo]{
        
        var users: [UserInfo] = []
        
        DataService.service.userRef.observeEventType(.Value, withBlock: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots {
                    
                    // user details
                    let name           = snap.value.objectForKey("name")     as! String
                    let surname        = snap.value.objectForKey("surname")  as! String
                    let city           = snap.value.objectForKey("city")     as! String
                    let email          = snap.value.objectForKey("email")    as! String
                    let profilePicture: UIImageView
                    
                    let userID         = snap.key
                    
                    // amount
                    let total    = snap.value.objectForKey("total")          as! Double
                    let weekly   = snap.value.objectForKey("weekly")         as! Double
                    
                    // login details
                    let facebookID = snap.value.objectForKey("fbID")         as! String
                    let loginService = snap.value.objectForKey("provider")   as! String
                    
                    
                    // set FB-pictures or "empty" picture
                    if loginService == "facebook" {
                        
                        let facebookProfilePictureURL = NSURL(string: "https://graph.facebook.com/\(facebookID)/picture?type=square")
                        let profilePicture = self.setProfileImage(facebookProfilePictureURL!)
                        
                        users.append(
                            UserInfo(firstName: name, surname: surname, total: total ,weekly: weekly, profilePicture: profilePicture, city: city, fbID: facebookID, provider: loginService, email: email,userID: userID))
                    }
                    else {
                        
                        let pic = UIImage(named: "empty.png")!
                        profilePicture = UIImageView(image: pic)
                        users.append(
                            UserInfo(firstName: name, surname: surname, total: total, weekly: weekly, profilePicture: profilePicture, city: city, fbID: facebookID, provider: loginService, email: email,userID: userID))
                    }
                    
                    
                    
                }
            }
        })
        //dangerzone !  !  !
        return users
    }
    
    */
    
    // set fb-pic to correct format (helper function)
    func setProfileImage(imageURL : NSURL) -> UIImageView {
        let obtainedImage = NSData(contentsOfURL: imageURL)
        let profilePicture : UIImageView = UIImageView(image: UIImage(data: obtainedImage!))
        if obtainedImage != nil{
            profilePicture.image = UIImage(data: obtainedImage!)!
            let square = CGSize(width: min(profilePicture.frame.size.width, profilePicture.frame.size.height), height: min(profilePicture.frame.size.width, profilePicture.frame.size.height))
            let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
            imageView.contentMode = .ScaleAspectFill
            imageView.image = profilePicture.image
            imageView.layer.cornerRadius = square.width/2
            imageView.layer.masksToBounds = true
            UIGraphicsBeginImageContext(imageView.bounds.size)
            let context = UIGraphicsGetCurrentContext()
            imageView.layer.renderInContext(context!)
            profilePicture.image = UIGraphicsGetImageFromCurrentImageContext()
        }
        return profilePicture
    }
 
    

    
    
    // M I A M I V I C E L U L L
    // obs! cunncurency issues?
/*    func loadUser(userID: String) -> UserInfo{
        
        var user: UserInfo
        
        let ref =  DataService.service.userRef
                    // user details
        //obs
                    let name           = ref.childByAppendingPath(userID).childByAppendingPath("name").key as String
                    let surname        = ref.childByAppendingPath(userID).childByAppendingPath("surname").key  as String
                    let city           = ref.childByAppendingPath(userID).childByAppendingPath("city").key     as String
                    let email          = ref.childByAppendingPath(userID).childByAppendingPath("email").key    as String
                    let profilePicture: UIImageView
        
                    // amount
                    let total    = ref.childByAppendingPath(userID).childByAppendingPath("total")          as! Double
                    let weekly   = ref.childByAppendingPath(userID).childByAppendingPath("weekly")        as! Double
                    
                    // login details
                    let facebookID   = ref.childByAppendingPath(userID).childByAppendingPath("fbID").key       as String
                    let loginService = ref.childByAppendingPath(userID).childByAppendingPath("provider").key
                        as String
                    
                    
                    // set FB-pictures or "empty" picture
                    if loginService == "facebook" {
                        
                        let facebookProfilePictureURL = NSURL(string: "https://graph.facebook.com/\(facebookID)/picture?type=square")
                        let profilePicture = self.setProfileImage(facebookProfilePictureURL!)
                        
                        user =
                            UserInfo(firstName: name, surname: surname, total: total,weekly: weekly, profilePicture: profilePicture, city: city, fbID: facebookID, provider: loginService, email: email,userID: userID)
                    }
                    else {
                        
                        let pic = UIImage(named: "empty.png")!
                        profilePicture = UIImageView(image: pic)
                        
                        user =
                            UserInfo(firstName: name, surname: surname, total: total,weekly: weekly, profilePicture: profilePicture, city: city, fbID: facebookID, provider: loginService, email: email,userID: userID)
                    }
   
        
        return user
    }
*/
    
    
    

}
