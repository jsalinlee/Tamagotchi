//
//  BerryMapViewController.swift
//  Tamagotchi
//
//  Created by Jonathan Salin Lee on 3/16/17.
//  Copyright © 2017 Jonathan Salin Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class BerryMapViewController: UIViewController, CLLocationManagerDelegate {
    
    //Map
    @IBOutlet weak var berryMap: MKMapView!
    
    let manager = CLLocationManager()
    var firstRun = true
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        // gets latest location of player
        let location = locations[0]
        // sets the view distance for the map
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        // grabs the current location coordinates
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        // zooms into region based on view distance and player coordinates
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        if firstRun {
            berryMap.setRegion(region, animated: false)
            firstRun = false
        }
        else {
            berryMap.setCenter(myLocation, animated: false)
        }
        //        let dojoLocationPin = DojoAnnotation(title: "Berry", subtitle: "Location", coordinate: )
        //        print(location.altitude)
        //        print(location.speed)
        //        print(location.coordinate)
        self.berryMap.showsUserLocation = true
    }
    func generateAnnoLoc() {
        
        var num = 0
        //First we declare While to repeat adding Annotation
        while num != 10 {
            num += 1
            
            //Add Annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = generateRandomCoordinates(min: 200, max: 400) //this will be the maximum and minimum distance of the annotation from the current Location (Meters)
            annotation.title = "Annotation Title"
            annotation.subtitle = "SubTitle"
            berryMap.addAnnotation(annotation)
            
        }
        
    }
    func generateRandomCoordinates(min: UInt32, max: UInt32)-> CLLocationCoordinate2D {
        //Get the Current Location's longitude and latitude
        //        let location: CLLocationCoordinate2D =  CLLocationCoordinate2DMake(37.375578, -121.91007)
        let currentLong = manager.location?.coordinate.longitude
        let currentLat = manager.location?.coordinate.latitude
        
        //1 KiloMeter = 0.00900900900901° So, 1 Meter = 0.00900900900901 / 1000
        let meterCord = 0.00900900900901 / 1000
        
        //Generate random Meters between the maximum and minimum Meters
        let randomMeters = UInt(arc4random_uniform(max) + min)
        
        //then Generating Random numbers for different Methods
        let randomPM = arc4random_uniform(6)
        
        //Then we convert the distance in meters to coordinates by Multiplying number of meters with 1 Meter Coordinate
        let metersCordN = meterCord * Double(randomMeters)
        
        //here we generate the last Coordinates
        if randomPM == 0 {
            return CLLocationCoordinate2D(latitude: currentLat! + metersCordN, longitude: currentLong! + metersCordN)
        }else if randomPM == 1 {
            return CLLocationCoordinate2D(latitude: currentLat! - metersCordN, longitude: currentLong! - metersCordN)
        }else if randomPM == 2 {
            return CLLocationCoordinate2D(latitude: currentLat! + metersCordN, longitude: currentLong! - metersCordN)
        }else if randomPM == 3 {
            return CLLocationCoordinate2D(latitude: currentLat! - metersCordN, longitude: currentLong! + metersCordN)
        }else if randomPM == 4 {
            return CLLocationCoordinate2D(latitude: currentLat!, longitude: currentLong! - metersCordN)
        }else {
            return CLLocationCoordinate2D(latitude: currentLat! - metersCordN, longitude: currentLong!)
        }
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        //        manager.stopUpdatingLocation()
        //        print(manager.location)
        generateAnnoLoc()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
