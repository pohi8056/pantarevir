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
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
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
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        checkLocationAuthorizationStatus()
        
        
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mapView.mapType = MKMapType.Standard
        
        self.mapView.delegate = self
        
        updateRevir("uppsala")
        
    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        //later

    }
    
    
    func centerMapOnLocation(location: CLLocation) {
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
                    print("renderer purple")
                    color = UIColor.purpleColor()
                }
            }
            
            let circleRenderer = MKRevirCircleRenderer(overlay: overlay, color: color!)
            print("renderer")
            circleRenderer.fillColor = color!.colorWithAlphaComponent(0.1)
            circleRenderer.strokeColor = color
            circleRenderer.lineWidth = 2
            return circleRenderer
        }
        
        print("Fault in mapView Overlay Rendering!")
        
        return MKRevirCircleRenderer(overlay:overlay, color: UIColor.purpleColor())
    }
    
    
    
    
    
    // update revir by city
    func updateRevir(city: String){
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)

        
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
                
                self.revirArray.append(newRevir)

                
                self.mapView.addOverlay(newRevir.revirCircle!)
                self.mapView.addAnnotation(newRevir.revirAnnotation!)
                
            }
            
        })
        
        
    }
    
    
    
    func drawRevir(revir: [Revir]){
        print("Draw_revir")
        for item in revirArray {
            print("Draw_revir_loop:")
            print(item.latitude)
            print(item.longitude)
            
            self.mapView.addOverlay(item.revirCircle!)
            //loadOverlayForRegionWithLatitude(item.latitude!, andLongitude: item.longitude!)
            
        }
    }
    
    
}

extension MapViewController {
    
    func mapView(mapView: MKMapView,viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        if (annotation is MKUserLocation) {
            return nil
        }
        else{
            
            let revirAnnotationView = RevirAnnotationView(annotation: annotation, reuseIdentifier: "Revir")
            
            revirAnnotationView.canShowCallout = true
            return revirAnnotationView
            
        }
    }
}