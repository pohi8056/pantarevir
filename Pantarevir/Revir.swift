//
//  Revir.swift
//  MapApp
//
//  Created by Lukas Hamberg on 26/04/16.
//  Copyright © 2016 Lulbasaurus X. All rights reserved.
//


import Foundation
import MapKit
import Firebase


class Revir{
    
    var name: String?
    var latitude: Double?
    var longitude: Double?
    var color: UIColor?
    var radius: CLLocationDistance?
    var revirCircle: MKCircle?
    var revirImage: UIImage?
    var belopp : Double?
    
    var revirAnnotation: MKRevirAnnotation?
    
    private var currentUserID: String?
    

    // M I A M I   <3   V I C E
    
    init(name: String, latitude: Double, longitude: Double, userID: String, radius: CLLocationDistance, intColor: Int){
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.currentUserID = userID
        self.radius = radius
        self.belopp = radius
        switch intColor {
        case 0:
            self.color = UIColor.redColor()
        case 1:
            self.color = UIColor.blueColor()
        case 2:
            self.color = UIColor.cyanColor()
        case 3:
            self.color = UIColor.yellowColor()
        case 4:
            self.color = UIColor.orangeColor()
        case 5:
            self.color = UIColor.magentaColor()
        case 6:
            self.color = UIColor.greenColor()
        default:
            self.color = UIColor.blackColor()
        }
        self.revirCircle = createAndReturnRevirCircle(latitude, andLongitude: longitude, radius: radius, name: name, color: self.color!)
    }
    
    func getCurrentUserID() -> String { return currentUserID! }
    
    
    func createAndReturnRevirCircle(latitude: Double, andLongitude longitude: Double,radius: CLLocationDistance ,name: String, color: UIColor) -> MKCircle{
        
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        self.revirCircle = MKCircle(centerCoordinate: coordinates, radius: radius)
        revirCircle?.title = name
        return self.revirCircle!
    }
    
    func createAndReturnRevirAnnotation(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) -> MKRevirAnnotation{
        
        self.revirAnnotation = MKRevirAnnotation(title: title, subtitle: subtitle, coordinate: coordinate)
    
            return self.revirAnnotation!
    }
    
    func createRevirAnnotation(title: String, subtitle: String, lat: Double, long: Double){
        self.revirAnnotation = MKRevirAnnotation(
            title: title, subtitle: subtitle, coordinate: CLLocationCoordinate2DMake(lat, long))
    }
    
    func createRevirAnnotation2(title: String, subtitle: String, lat: Double, long: Double, id: String){
        self.revirAnnotation = MKRevirAnnotation(
            title: title, subtitle: subtitle, coordinate: CLLocationCoordinate2DMake(lat, long), id: id)
    }
    
    func prepareForFirebase() -> Dictionary<String, AnyObject>{
        return [DataService.Data.Value.Uid.rawValue : currentUserID!, DataService.Data.Value.Belopp.rawValue : belopp!]
    }
    
    
}