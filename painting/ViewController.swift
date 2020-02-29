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
    var swipedUp = false
    var swipedRight = false
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
                case UISwipeGestureRecognizer.Direction.down:
                    print("swipedUp down")
                    swipedUp = false
                    swipedRight = false
                    self.viewDidLoad()
                case UISwipeGestureRecognizer.Direction.right:
                    print("swipedUp right")
                    swipedUp = false
                    swipedRight = true
                    self.viewDidLoad()
                case UISwipeGestureRecognizer.Direction.up:
                    print("swipedUp up")
                    swipedUp = true
                    swipedRight = false
                    self.viewDidLoad()
                default:
                    break
            }
        }
    }
    
    @IBAction func didTapGoogle(sender: AnyObject) {
        UIApplication.shared.open(URL(string: "www.google.com")!, options: [:], completionHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        self.view.addGestureRecognizer(swipeUp)
        
        var swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
        
        let scanningPanel = UIImageView()
        scanningPanel.backgroundColor = UIColor(displayP3Red: 0.501, green: 0.0, blue: 0.0, alpha: 1.0)
        scanningPanel.layer.masksToBounds = true
        scanningPanel.frame = CGRect(x: self.arView.frame.width/2-90,
                                     y: 40,
                                 width: 180,
                                height: 50)

        scanningPanel.layer.cornerRadius = 10

        let scanInfo = UILabel(frame: CGRect(x: self.arView.frame.width/2-80,
                                             y: 40,
                                         width: 160,
                                        height: 50))

        scanInfo.textAlignment = .left
        scanInfo.font = scanInfo.font.withSize(20)
        scanInfo.textColor = UIColor.white
        scanInfo.text = "UNSUNG AGGIES"
        scanInfo.font = UIFont(name:"Avenir Next", size: 18.0)
        self.arView.addSubview(scanningPanel)
        self.arView.addSubview(scanInfo)
        
        
        let btnBack = UIImageView()
        btnBack.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.2, blue: 0.8, alpha: 1.0)
        btnBack.layer.masksToBounds = true
        btnBack.frame = CGRect(x: self.arView.frame.width-100,
             y: 40,
         width: 80,
        height: 50)

        btnBack.layer.cornerRadius = 10
        
        let donateBtn = UIButton(frame: CGRect(x: self.arView.frame.width-120,
                                                   y: 40,
                                               width: 120,
                                              height: 50))
        donateBtn.setTitle("Donate!", for: .normal)
        
        donateBtn.addTarget(self, action: "didTapGoogle", for: .touchUpInside)
        
        self.arView.addSubview(btnBack)
        self.arView.addSubview(donateBtn)
        
        
        if(swipedUp == true){
            let pos = CGRect(x: 10,
                y: 2*arView.frame.height/3,
                width: self.arView.frame.width-20,
                height: self.arView.frame.height/3-10)
            
            let mapView = MKMapView(frame: pos)
            
            mapView.layer.cornerRadius = 10.0;
            mapView.layer.cornerRadius = 10
            
            mapView.showsUserLocation = true
            mapView.mapType = MKMapType.satellite
        
            
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
                        let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 2
                            , longitudinalMeters: 2)
                        mapView.setRegion(viewRegion, animated: false)
                    }
                }
            }
            
            var annotation = MKPointAnnotation()
            var centerCoordinate = CLLocationCoordinate2D(latitude: 30.614298, longitude:-96.339449)
            annotation.coordinate = centerCoordinate
            annotation.title = "Corps Of Cadets"
            mapView.addAnnotation(annotation)
           
            annotation = MKPointAnnotation()
            centerCoordinate = CLLocationCoordinate2D(latitude: 30.619734, longitude:-96.338191)
            annotation.coordinate = centerCoordinate
            annotation.title = "Langford A Architecture"
            mapView.addAnnotation(annotation)
            
            self.arView.addSubview(mapView)

        }
        else{
            for v in self.arView.subviews {
                if v is MKMapView{
                   v.removeFromSuperview()
                }
            }
        }
        
//        if(swipedRight == true){
//            let scanningPanel = UIImageView()
//           scanningPanel.backgroundColor = UIColor(white: 0.33, alpha: 0.6)
//           scanningPanel.layer.masksToBounds = true
//           scanningPanel.frame = CGRect(x: 20,
//                                       y: 40,
//                                       width: self.arView.frame.width-20,
//                                       height: 30)
//
//
//           scanningPanel.layer.cornerRadius = 10
//
//           let scanInfo = UILabel(frame: CGRect(x: 20,
//                                                y: 40,
//                                            width: self.arView.frame.width-20,
//                                            height: 30))
//
//           scanInfo.textAlignment = .left
//           scanInfo.font = scanInfo.font.withSize(15)
//           scanInfo.textColor = UIColor.white
//           scanInfo.text = "* She is the first African American women to have joined the Corps of Cadets."
//           self.arView.addSubview(scanningPanel)
//           self.arView.addSubview(scanInfo)
//        }
//        else{
//            for v in self.arView.subviews {
//                if v is UIImageView{
//                   v.removeFromSuperview()
//                }
//                if v is UILabel{
//                   v.removeFromSuperview()
//                }
//            }
//        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        let boxAnchor = try! Experience.loadBox()
        arView.scene.anchors.append(boxAnchor)
    }
}
