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
    
    var revirAnnotation: MKRevirAnnotation?
    
    private var currentUserID: String?
    

    
    init(name: String, latitude: Double, longitude: Double, userID: String, radius: CLLocationDistance, intColor: Int){
        
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.currentUserID = userID
        self.radius = radius
        switch intColor {
        case 0:
            self.color = UIColor.redColor()
        case 1:
            self.color = UIColor.blueColor()
        case 2:
            self.color = UIColor.cyanColor()
        case 3:
            self.color = UIColor.yellowColor()
        default:
            self.color = UIColor.purpleColor()
        }
        self.revirCircle = createAndReturnRevirCircle(latitude, andLongitude: longitude, radius: radius, name: name, color: self.color!)
    }
    
    func getCurrentUserID() -> String { return currentUserID! }
    
    
    func createAndReturnRevirCircle(latitude: Double, andLongitude longitude: Double,radius: CLLocationDistance ,name: String, color: UIColor) -> MKCircle{
     print("create")
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        //self.revirCircle = MKRevirCircle(centerCoordinate: coordinates, radius: radius)
        self.revirCircle = MKCircle(centerCoordinate: coordinates, radius: radius)
        revirCircle?.title = name
        return self.revirCircle!
    }
    
    func createAndReturnRevirAnnotation(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) -> MKRevirAnnotation{
        
        self.revirAnnotation = MKRevirAnnotation(title: title, subtitle: subtitle, coordinate: coordinate)
    
            return self.revirAnnotation!
    }
    
    
    
    
}