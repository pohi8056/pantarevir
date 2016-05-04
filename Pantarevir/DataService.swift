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
    private var _citiesRef = Firebase(url: "\(ROOT_URL)/cities")
    
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
    
    func addReceipt(receipt : Receipt){
        receiptRef.childByAppendingPath(receipt.receiptEAN).setValue(receipt)
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
 
    
    // update revir by city
    func updateRevir(city: String)-> [Revir]{
        
        var revirArray: [Revir] = []
        
        DataService.service.returnCityRevirRef(city).observeSingleEventOfType(.Value, withBlock: { snapshot in
            print(snapshot.childrenCount) // I got the expected number of items
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? FDataSnapshot {
                let nam = rest.key as String
                let lat  = rest.childSnapshotForPath("Latitud").value as! Double
                let lon  = rest.childSnapshotForPath("Longitud").value as! Double
                let userID  = rest.childSnapshotForPath("UserID").value as! String
                let color  = rest.childSnapshotForPath("Color").value as! Int
                let radius  = rest.childSnapshotForPath("Radie").value as! Double
                
                print("UPDATE_REVIR_ARRAY_DATASERVICE:")
                print(nam)
                print(lat)
                print(lon)
                print(userID)
                print(color)
                print(radius)
                
                let newRevir = Revir(name: nam,latitude: lat,longitude: lon, userID: userID, radius: radius, intColor: color)
                
                newRevir.createRevirAnnotation(nam,subtitle: userID,lat: lat,long: lon)
                
                revirArray.append(newRevir)
                
                print(revirArray)
                
            }
        })
        
        return revirArray
    }

}
