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
import CoreData
import SpriteKit
import AudioToolbox
import AVFoundation

class BerryMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var messageLabel: UILabel!
    
    //Map
    @IBOutlet weak var berryMap: MKMapView!
    var activePins = [MKPinAnnotationView]()
    
    let manager = CLLocationManager()
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var coordinatesList = [Coordinates]()
    var inventoryList:Inventory?
    var firstRun = true
    var berrySound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "Sound/berrysound", ofType:"mp3")!)
    var audioPlayer = AVAudioPlayer()
    
    func getBatchLocations() {
        let url = URL(string: "http://localhost:8000/api/berrylist")
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: {
            data, response, error in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    print(jsonResult)
                }
            } catch {
                print(error)
            }
        })
        task.resume()
    }
    
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
        var deleteTargets:Int?
        print(activePins.count)
        for i in 0..<activePins.count {
            print(i, activePins[i].annotation?.coordinate.latitude, activePins[i].annotation?.coordinate.longitude)
            let coord1 = CLLocation(latitude: (activePins[i].annotation?.coordinate.latitude)!, longitude: (activePins[i].annotation?.coordinate.longitude)!)
            let coord2 = CLLocation(latitude: myLocation.latitude, longitude: myLocation.longitude)
            let dist = coord1.distance(from: coord2)
            print(i, dist)
//            print("\(coord1.coordinate.latitude), \(coord1.coordinate.longitude)")
            if dist <= 10 {
                print("\(i) - In range to pick up \(activePins[i].annotation?.title!!)")
                deleteTargets = i
            }
        }
        if let i = deleteTargets {
            print("deleting \(i)")
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Inventory")
            do {
                // If inventory does not exist, initialize empty inventory
                let result = try managedObjectContext.fetch(request)
                var item = result as! [Inventory]
                if item.count == 0 {
                    let playerInv = Inventory(context: managedObjectContext)
                    playerInv.redCount = 0
                    playerInv.blueCount = 0
                    playerInv.greenCount = 0
                    playerInv.yellowCount = 0
                    playerInv.gojira = 0
                    playerInv.kendama = 0
                    playerInv.rubberBall = 0
                    do {
                        try managedObjectContext.save()
                    } catch { print("Error") }
                    item = [playerInv]
                }
                // Assign the inventory instance to self
                self.inventoryList = item[0]
            } catch {
                let playerInv = Inventory(context: managedObjectContext)
                playerInv.redCount = 3
                playerInv.blueCount = 3
                playerInv.greenCount = 3
                playerInv.yellowCount = 3
                playerInv.gojira = 3
                playerInv.kendama = 3
                playerInv.rubberBall = 3
                do {
                    try managedObjectContext.save()
                } catch { print("Error") }
            }
            let title = activePins[i].annotation?.title
            switch(title!!) {
            case "Red Berry":
                inventoryList?.redCount += 1
                messageLabel.text = "You picked up a red berry!"
                messageLabel.alpha = 1.0
                UIView.animate(withDuration: 3.0, animations: {self.messageLabel.alpha = 0.0})
            case "Blue Berry":
                inventoryList?.blueCount += 1
                messageLabel.text = "You picked up a blue berry!"
                messageLabel.alpha = 1.0
                UIView.animate(withDuration: 3.0, animations: {self.messageLabel.alpha = 0.0})
            case "Green Berry":
                messageLabel.text = "You picked up a green berry!"
                messageLabel.alpha = 1.0
                UIView.animate(withDuration: 3.0, animations: {self.messageLabel.alpha = 0.0})
                inventoryList?.greenCount += 1
            case "Yellow Berry":
                messageLabel.text = "You picked up a yellow berry!"
                messageLabel.alpha = 1.0
                UIView.animate(withDuration: 3.0, animations: {self.messageLabel.alpha = 0.0})
                inventoryList?.yellowCount += 1
            default:
                break;
            }
            do {
                try managedObjectContext.save()
            } catch { print("Error") }
            berryMap.removeAnnotation(activePins[i].annotation!)
            activePins[i].removeFromSuperview()
            activePins.remove(at: i)
            managedObjectContext.delete(coordinatesList[i])
            do {
                try managedObjectContext.save()
            } catch {
                print("Could not delete \(i)")
            }
            coordinatesList.remove(at: i)
//            if let soundURL = Bundle.main.url(forResource: "berrysound.mp3", withExtension: "mp3") {
//                var mySound: SystemSoundID = 0
////                AudioServicesCreateSystemSoundID(soundURL as CFURL, &mySound)
//                // Play
//                AudioServicesPlaySystemSound(mySound);
//            }
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: berrySound as URL)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch {print("Error playing sound!")}
        }
    }
    func fetchAllItems() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Coordinates")
        do {
            // If berry list does not exist, initialize empty berry list
            let result = try managedObjectContext.fetch(request)
            let item = result as! [Coordinates]
            if item.count == 0 {
//                print("Generating new locations")
                generateAnnoLoc()
                do {
                    try managedObjectContext.save()
                } catch { print("Error") }
            }
            else {
//                print("Found existing coordinates of length \(item.count)")
                coordinatesList = item
                existingAnnoLoc()
            }
        } catch {
//            print("Error - coordinates list empty")
            generateAnnoLoc()
            do {
                try managedObjectContext.save()
            } catch { print("Error") }
        }
    }
    
    func generateAnnoLoc() {
        //First we declare While to repeat adding Annotation
        for _ in 0..<10 {
            //Add Annotation
            
            
            let annotation = CustomPointAnnotation()
            
            annotation.coordinate = generateRandomCoordinates(min: 200, max: 400) //this will be the maximum and minimum distance of the annotation from the current Location (Meters)
            
            let coord = annotation.coordinate
            let coordObject = Coordinates(context: managedObjectContext)
            coordObject.latitude = coord.latitude
            coordObject.longitude = coord.longitude
            coordObject.color = Int16(arc4random_uniform(4))
            coordinatesList.append(coordObject)
            do {
                try managedObjectContext.save()
            } catch {
                print("Error!")
            }
            switch(coordObject.color) {
            case 0:
                annotation.title = "Red Berry"
                annotation.subtitle = "Happiness"
                annotation.pinCustomImageName = "redberry"
            case 1:
                annotation.title = "Green Berry"
                annotation.subtitle = "Healing"
                annotation.pinCustomImageName = "greenberry"
            case 2:
                annotation.title = "Blue Berry"
                annotation.subtitle = "Nutritious"
                annotation.pinCustomImageName = "blueberry"
            case 3:
                annotation.title = "Yellow Berry"
                annotation.subtitle = "Energizing"
                annotation.pinCustomImageName = "yellowberry"
            default:
                annotation.title = "Mystery Berry"
                annotation.subtitle = "One way to find out!"
            }
            //            mapView(mapView: berryMap, viewForAnnotation: annotation)
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            berryMap.addAnnotation(pinAnnotationView.annotation!)
            activePins.append(pinAnnotationView)
        }
    }
    
    func existingAnnoLoc() {
        //First we declare While to repeat adding Annotation
        for i in 0..<coordinatesList.count {
            //Add Annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate =  CLLocationCoordinate2DMake(coordinatesList[i].latitude, coordinatesList[i].longitude)
            switch(coordinatesList[i].color) {
            case 0:
                annotation.title = "Red Berry"
                annotation.subtitle = "Happiness"
            case 1:
                annotation.title = "Green Berry"
                annotation.subtitle = "Healing"
            case 2:
                annotation.title = "Blue Berry"
                annotation.subtitle = "Nutritious"
            case 3:
                annotation.title = "Yellow Berry"
                annotation.subtitle = "Energizing"
            default:
                annotation.title = "Mystery Berry"
                annotation.subtitle = "One way to find out!"
            }
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            berryMap.addAnnotation(pinAnnotationView.annotation!)
            activePins.append(pinAnnotationView)
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
        berryMap.delegate = self
        berryMap.mapType = MKMapType.standard
        berryMap.showsUserLocation = true
        self.fetchAllItems()
        getBatchLocations()
//        for i in coordinatesList {
//            print("\(i): \(i.longitude), \(i.latitude)")
//        }
        //generateAnnoLoc()
    }
    
    
    // MKMapViewDelegate method
    // Called when the map view needs to display the annotation.
    // E.g. If you drag the map so that the annotation goes offscreen, the annotation view will be recycled. When you drag the annotation back on screen this method will be called again to recreate the view for the annotation.
    //
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let color = annotation.title

        if annotation.isEqual(mapView.userLocation) {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "userLocation")
            annotationView.image = UIImage(named: "geo-1")
            return annotationView
        }
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        switch(color!!) {
        case "Red Berry":
            annotationView!.image = UIImage(named: "redberry")
        case "Blue Berry":
            annotationView!.image = UIImage(named: "blueberry")
        case "Green Berry":
            annotationView!.image = UIImage(named: "greenberry")
        case "Yellow Berry":
            annotationView!.image = UIImage(named: "yellowberry")
        default:
            print("Couldn't find image for \(color!!)")
            annotationView!.image = UIImage(named: "redberry")
        }
        return annotationView
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
