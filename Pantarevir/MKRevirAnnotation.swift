//
//  MKRevirAnnotation.swift
//  MapApp
//
//  Created by Lukas Hamberg on 02/05/16.
//  Copyright © 2016 Lulbasaurus X. All rights reserved.
//

import Foundation
import MapKit


enum revirType: Int {
    case conquered = 0
    case free
}

class MKRevirAnnotation: NSObject, MKAnnotation{

    
    var title: String?
    var subtitle: String?
    
    var coordinate: CLLocationCoordinate2D
    
    var image: UIImage?
    
    var type: revirType

    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.type = revirType.free
        
        super.init()
    }
    
    


}