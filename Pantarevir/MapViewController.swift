//
//  ViewController.swift
//  MapApp
//
//  Created by Lukas Hamberg on 18/04/16.
//  Copyright © 2016 Lulbasaurus X. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    var revirArray: [Revir] = []
    var users: [UserInfo] = []
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // M I A M I   <3   V I C E
    
    func checkLocationAuthorizationStatus() {
        
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            let userLocation = locationManager.location
            centerMapOnLocation(userLocation!)
            
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
        
        if CLLocationManager.locationServicesEnabled() {
            print("Location service enabled")
        }
        else{
            print("Location service disabled")
            let defaultLocation = CLLocation(latitude: 59.8588200, longitude: 17.6388900)
            centerMapOnLocation(defaultLocation)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        checkLocationAuthorizationStatus()
        updateRevir("uppsala")

        
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mapView.mapType = MKMapType.Standard
        
        self.mapView.delegate = self
        self.loadUsers()

        

    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 2000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(
            location.coordinate,
            regionRadius,
            regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func centerMapOnLocationDefault(location: CLLocation) {
        let regionRadius: CLLocationDistance = 2000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(
            location.coordinate,
            regionRadius,
            regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        if let overlay = overlay as? MKCircle{
            var color: UIColor?
            for item in self.revirArray{
                if item.name == overlay.title{
                    color = item.color
                }
                else{
                    color = UIColor.purpleColor()
                }
            }
            
            let circleRenderer = MKRevirCircleRenderer(overlay: overlay, color: color!)
            circleRenderer.fillColor = color!.colorWithAlphaComponent(0.2)
            //circleRenderer.strokeColor = color
            //circleRenderer.lineWidth = 2
            return circleRenderer
        }
        
        print("Fault in mapView Overlay Rendering!")
        
        return MKRevirCircleRenderer(overlay:overlay, color: UIColor.purpleColor())
    }
    
    
    
    
    
    // update revir by city
    func updateRevir(city: String){
        
        //DataService.service.returnCityRevirRef(city).observeSingleEventOfType(.Value, withBlock: { snapshot in
        DataService.service.returnCityRevirRef(city).observeEventType(.Value, withBlock: { snapshot in

            print(snapshot.childrenCount)
            
            //remove array values
            self.revirArray.removeAll()

            
            //remove old overlays and annotaitons
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.removeOverlays(self.mapView.overlays)
            
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? FDataSnapshot {
                let nam = rest.key as String
                let lat  = rest.childSnapshotForPath("Latitud").value as! Double
                let lon  = rest.childSnapshotForPath("Longitud").value as! Double
                let userID  = rest.childSnapshotForPath("UserID").value as! String
                let color  = rest.childSnapshotForPath("Color").value as! Int
                let radius  = rest.childSnapshotForPath("Radie").value as! Double
                let playerName  = rest.childSnapshotForPath("playerName").value as! String
                let value  = rest.childSnapshotForPath("belopp").value as! Double

                
                let subtitle = "Ägare: \(playerName) | \(value)kr"
                print("UPDATE_REVIR_ARRAY_DATASERVICE:")
                print(nam)
                print(lat)
                print(lon)
                print(userID)
                print(color)
                print(radius)

                
                let newRevir = Revir(name: nam,latitude: lat,longitude: lon, userID: userID, radius: radius, intColor: color)
                
                
                //newRevir.createRevirAnnotation(nam,subtitle: userID,lat: lat,long: lon)
                //newRevir.createRevirAnnotation2(nam,subtitle: playerName,lat: lat,long: lon, id: userID)
                newRevir.createRevirAnnotation2(nam,subtitle: subtitle,lat: lat,long: lon, id: userID)

                
                self.revirArray.append(newRevir)

                
                self.mapView.addOverlay(newRevir.revirCircle!)
                self.mapView.addAnnotation(newRevir.revirAnnotation!)
                

            }
            
        })
        
    }
    
    
    func loadUsers(){
        
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
                        
                        self.users.append(
                            UserInfo(firstName: name, surname: surname, total: total ,weekly: weekly, profilePicture: profilePicture, city: city, fbID: facebookID, provider: loginService, email: email, userID: userID))
                    }
                    else {
                        
                        let pic = UIImage(named: "revirprofilbild.png")!
                        profilePicture = UIImageView(image: pic)
                        self.users.append(
                            UserInfo(firstName: name, surname: surname, total: total, weekly: weekly, profilePicture: profilePicture, city: city, fbID: facebookID, provider: loginService, email: email,userID: userID))
                    }
                    
                    
                    
                }
            }
        })
        
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
    
    @IBAction func backButton(sender: UIButton) {
        let menuView = self.storyboard!.instantiateViewControllerWithIdentifier("MainMenu")
        UIApplication.sharedApplication().keyWindow?.rootViewController = menuView
    }    
}

extension MapViewController {
    
    func mapView(mapView: MKMapView,viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        if (annotation is MKUserLocation) {
            return nil
        }
        else{
            
            let revirAnnotationView = RevirAnnotationView(annotation: annotation, reuseIdentifier: "Revir")
            var image: UIImage?
            revirAnnotationView.canShowCallout = true
            print("annotaionimage load before print")
            print(users.count)
            let annot = annotation as! MKRevirAnnotation
            image = UIImage(named: "icon_unclaimed")!

            for item in users {
                if item.userID != nil && item.userID == annot.id{
                //if item.fbID != nil && item.fbID == annot.id{

                    print("annotaionimage load")
                
                    image = item.profilePicture!.image
                    
                }
                /*else{
                    image = UIImage(named: "logo")!
                }*/
                
            }
            
            let button = UIButton(type: UIButtonType.Custom) as UIButton
            button.frame.size.width = 44
            button.frame.size.height = 44
            button.backgroundColor = UIColor.clearColor()
            button.setImage(image, forState: .Normal)
            revirAnnotationView.leftCalloutAccessoryView = button

            return revirAnnotationView
            
        }
    }
}