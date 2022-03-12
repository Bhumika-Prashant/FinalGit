//
//  ViewController.swift
//  TravelBook
//
//  Created by Bhumika Hirapara on 3/5/22.
//

import UIKit
import MapKit
import CoreLocation     // for user's current location
import CoreData

// To set the custom locationin the simulator: Features -> location -> custom location

class ViewController: UIViewController, MKMapViewDelegate { // Map

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager() // The object that you use to start and stop the delivery of location-related events to your app. LocationManager is responsible for getting hold of the current GPS location of the phone
    
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest  // we need best accuracy in our project->it uses more battery
        locationManager.requestWhenInUseAuthorization() // request the user's permission to use location services while the app is in use
        locationManager.startUpdatingLocation() // it will get the user's location and give it to us
//        we have to provide explanation to user why we need your location and we will do that in info.plist
        
        
//        LongPressGestureRecognizer to add the Annotation
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 3  // longpress for 3 seconds
        mapView.addGestureRecognizer(gestureRecognizer)
    }

    @objc func chooseLocation(gestureRecognizer: UILongPressGestureRecognizer) {    // because we have to use the properties of gestureRecognizer and that's why we gave input
        
        if gestureRecognizer.state == .began {  // gesture property
            
            let touchedPoint = gestureRecognizer.location(in: mapView)  // once it begins, we will get touchPoint of the user
            let touchedCoordinates = mapView.convert(touchedPoint, toCoordinateFrom: mapView) // it will give us the coordinates of that touchPoint
            
            chosenLatitude = touchedCoordinates.latitude
            chosenLongitude = touchedCoordinates.longitude
            
//            Now let's create a pin and its called Annotation
            
            let annotaion = MKPointAnnotation()
            annotaion.coordinate = touchedCoordinates   // give those coordinates to the annotation
            annotaion.title = nameText.text
            annotaion.subtitle = commentText.text
            mapView.addAnnotation(annotaion)
            
        }
    }
    
    //  MARK: - Coredata
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {   // to save data in the coredata database
        
//        we have to use AppDelegate in order to reach and use automatically generated coredata functions.
        
        let delegate = (UIApplication.shared.delegate) as! AppDelegate
        let context  = delegate.persistentContainer.viewContext
        
        let newPlace = Places(context: context)
        
        newPlace.title = nameText.text
        newPlace.subTitle = commentText.text
        newPlace.latitude = chosenLatitude
        newPlace.longitude = chosenLongitude
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

//  MARK: - Location Manager

extension ViewController: CLLocationManagerDelegate {   // user's current location
    
//    what will happen after we get the user's current location, we will set location to the map
//    This method tell the delegate that new data is availbale
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)     // get first latitude and longitude
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)    // zoom level of map -> defines the width and height of the current map
//        0.1 -> zoom but if you want much better zoom 0.05 span
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)

    }
    
}
