//
//  ViewController.swift
//  painting
//
//  Created by Sanjay Kumaran on 2/28/20.
//  Copyright © 2020 Sanjay Kumaran. All rights reserved.
//

import UIKit
import RealityKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet var arView: ARView!
    
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pos = CGRect(x: 10,
            y: 2*arView.frame.height/3,
            width: self.arView.frame.width-20,
            height: self.arView.frame.height/3-10)
        
        let mapView = MKMapView(frame: pos)
        
        mapView.layer.cornerRadius = 10.0;
        mapView.layer.cornerRadius = 10
        let boxAnchor = try! Experience.loadBox()
        mapView.showsUserLocation = true
    
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // Check for Location Services
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            defer { currentLocation = locations.last }

            if currentLocation == nil {
                // Zoom to user location
                if let userLocation = locations.last {
                    let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1
                        , longitudinalMeters: 1)
                    mapView.setRegion(viewRegion, animated: false)
                }
            }
        }
        self.arView.addSubview(mapView)

        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
    }
}
