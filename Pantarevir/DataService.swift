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
        }
}
    

    
    //Load specific data, WORK IN PROGRESS
    func loadSpecificData(branch : Data.Branch, val : Data.Value) -> String{

        let semaphore = dispatch_semaphore_create(0)
        var obtainedData = "No data obtained"
        print("Current thread \(NSThread.currentThread()).1")

        
        switch branch {
        case .User:
                print("yesp im here")
                print("Current thread \(NSThread.currentThread()).2")

                DataService.service.currentUserRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                    print("Current thread \(NSThread.currentThread()).3")

                    print("sdf: \(snapshot.value)")
                    obtainedData = snapshot.value.objectForKey("\(val.rawValue)") as! String
                    print("Value obtained from \(val): \(obtainedData)")
                    dispatch_semaphore_signal(semaphore)
                    }, withCancelBlock: { error in
                        print("Error retrieving \(val)")
                })

            case .City:
                DataService.service.citiesRef.observeEventType(.Value, withBlock: { snapshot in
                    obtainedData = snapshot.value.objectForKey("\(val.rawValue)") as! String
                    print("Value obtained from \(val): \(obtainedData)")
                    dispatch_semaphore_signal(semaphore)

                    }, withCancelBlock: { error in
                        print("Error retrieving \(val)")
                })

            case .Receipt:
                DataService.service.receiptRef.observeEventType(.Value, withBlock: { snapshot in
                obtainedData = snapshot.value.objectForKey("\(val.rawValue)") as! String
                print("Value obtained from \(val): \(obtainedData)")
                dispatch_semaphore_signal(semaphore)

                }, withCancelBlock: { error in
                    print("Error retrieving \(val)")
            })
        }

        print("Current thread \(NSThread.currentThread()).4")

        print("obtained data: \(obtainedData)")

        print("dispatch main queue: \(obtainedData)")

        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) //funkar med fast dispatch time
        print("Timed out.")
        print("obtained data: \(obtainedData)")
            
        
        return obtainedData
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
    
    func createNewAccount(uid: String, user: Dictionary<String, String>) {
        userRef.childByAppendingPath(uid).setValue(user)
    }
    
    
    
    
    //NOTE TO TOMORROW: Read last total/weekly and add instead of overwrite.
    func addReceipt(receipt : Receipt){
        //test()
        //let previousTotal = loadSpecificData(.User, val: .Total)
        print("kom hit")
        //let newTotal = Double(previousTotal)! + Double(receipt.amount)!
        print("men inte hit")
        let variablesOfReceipt = receipt.prepareReceiptForFirebase()

        receiptRef.childByAppendingPath(receipt.receiptEAN).setValue(variablesOfReceipt)
        userRef.childByAppendingPath(receipt.userUID).updateChildValues(["total" : receipt.amount])
        userRef.childByAppendingPath(receipt.userUID).updateChildValues(["weekly" : receipt.amount])
    }
    
    
    func returnCityRevirRef(city : String)-> Firebase{
        return Firebase(url: "\(_citiesRef)/\(city)/revir")
    }
    
    
    
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
                    let total    = snap.value.objectForKey("total")          as! Int
                    let weekly   = snap.value.objectForKey("weekly")         as! Int
                    
                    // login details
                    let facebookID = snap.value.objectForKey("fbID")         as! String
                    let loginService = snap.value.objectForKey("provider")   as! String
                    
                    
                    // set FB-pictures or "empty" picture
                    if loginService == "facebook" {
                        
                        let facebookProfilePictureURL = NSURL(string: "https://graph.facebook.com/\(facebookID)/picture?type=square")
                        let profilePicture = self.setProfileImage(facebookProfilePictureURL!)
                        
                        users.append(
                            UserInfo(firstName: name, surname: surname, total: total,weekly: weekly, profilePicture: profilePicture, city: city, fbID: facebookID, provider: loginService, email: email,userID: userID))
                    }
                    else {
                        
                        let pic = UIImage(named: "empty.png")!
                        profilePicture = UIImageView(image: pic)
                        users.append(
                            UserInfo(firstName: name, surname: surname, total: total,weekly: weekly, profilePicture: profilePicture, city: city, fbID: facebookID, provider: loginService, email: email,userID: userID))
                    }
                    
                    
                    
                }
            }
        })
        
        return users
    }
    
    
    
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
 
    


}
