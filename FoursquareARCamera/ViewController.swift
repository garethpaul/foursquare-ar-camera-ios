//
//  ViewController.swift
//  FoursquareARCamera
//
//  Created by Gareth Paul Jones on 02/07/2017.
//  Copyright © 2017 Foursquare. All rights reserved.
//

import UIKit
import SceneKit 
import MapKit
import CocoaLumberjack
import Alamofire
import SwiftyJSON
import Mapbox
import Reachability

class ViewController: UIViewController, MKMapViewDelegate, MGLMapViewDelegate, SceneLocationViewDelegate {
    let sceneLocationView = SceneLocationView()

    var subway =  CLLocation()
    
    let mapView = MKMapView()

    var userAnnotation: MKPointAnnotation?
    var locationEstimateAnnotation: MKPointAnnotation?
    var compass : MBXCompassMapView!
    var updateUserLocationTimer: Timer?
    
    ///Whether to show a map view
    ///The initial value is respected
    var showMapView: Bool = false
    
    var centerMapOnUserLocation: Bool = true
    
    ///Whether to display some debugging data
    ///This currently displays the coordinate of the best location estimate
    ///The initial value is respected
    var displayDebugging = false
    
    var infoLabel = UILabel()
    
    var updateInfoLabelTimer: Timer?
    
    var loaded: Bool = false
    
    var adjustNorthByTappingSidesOfScreen = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        let reach = Reachability()!
        
        if reach.currentReachabilityString == "No Connection" {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Oops", message: "We are currently struggling to access to the internet. This app requires access to the internet in order to find locations around you.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                    // perhaps use action.title here
                })
                self.present(alert, animated: true)
            }
        }
    
        
        
        
        // Add Scene Location
        view.addSubview(sceneLocationView)
        

        

        // Add the compass to the View
        // See https://blog.mapbox.com/compass-for-arkit-42c0692c4e51
        compass = MBXCompassMapView(frame: CGRect(x: self.view.frame.width-110,
                                                  y:  self.view.frame.height-160,
                                                  width: 100,
                                                  height: 100),
                                    styleURL: URL(string: "mapbox://styles/mapbox/navigation-guidance-day-v2"))
        compass.isMapInteractive = false
        compass.tintColor = .black
        compass.delegate = self
        view.addSubview(compass)
        

        
    }
    
    @objc
    func imageTapped(_ tapGestureRecognizer: UITapGestureRecognizer)
    {
        print(tapGestureRecognizer)
        let sceneTapped = tapGestureRecognizer.view
        sceneTapped?.isHidden = true
        //let tappedImage = tapGestureRecognizer.view
        //tappedImage.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DDLogDebug("run")
        sceneLocationView.run()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        DDLogDebug("pause")
        // Pause the view's session
        sceneLocationView.pause()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = CGRect(
            x: 0,
            y: 0,
            width: self.view.frame.size.width,
            height: self.view.frame.size.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: Get foursquare locations
    
    func getFoursquareLocations(_ currentLocation:CLLocation) {
        
        // Check if the request has loaded to avoid multuple requests.
        if self.loaded == false  {
            self.loaded = true
            let lat = String(currentLocation.coordinate.latitude)
            let lng = String(currentLocation.coordinate.longitude)
            let client_id = ""
            let client_secret = ""
            let categoryId = "4d4b7105d754a06374d81259" // food
            let ll = lat + "," + lng
            let url = "https://api.foursquare.com/v2/venues/search?v=20161016&ll=\(ll)&client_id=\(client_id)&client_secret=\(client_secret)&limit=5&categoryId=\(categoryId)&radius=200"
            
            // Send HTTP request
            Alamofire.request(url).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let resp = json["response"]
                    let venues = resp["venues"]
                    // Iterate through the venues
                    for venue in venues {
                        let name = (venue.1["name"])
                        let lat = venue.1["location"]["lat"]
                        let lng = venue.1["location"]["lng"]
                        let categoryName = venue.1["categories"][0]["name"]
                        let ratingStr = Int(venue.1["location"]["distance"].double! * 3.28084)
                        
                        let frameSize = CGRect(x: 0, y: 0, width: 362, height: 291)
                        let fsview = FSQView(frame: frameSize)
                        fsview.venueName.text = name.string
                        fsview.categoryName.text = categoryName.string
                        fsview.ratingStr.text = "\(ratingStr)ft"
                        
                        var image = UIImage.imageWithView(view: fsview)
                        
                        
                        // Mask an image to avoid pixelated images in AR.
                        let m = UIImage(named: "fsqMask")!
                        image = UIImage.aImage(image: image, mask:m)
                        image = UIImage.resizeImage(image: image, newHeight: 200)
                        
                        let starbucksCoordinate = CLLocationCoordinate2D(latitude: lat.double!, longitude: lng.double!)
                        let starbucksLocation = CLLocation(coordinate: starbucksCoordinate, altitude: 30.84)
                        let starbucksImage = image
                        let starbucksLocationNode = LocationAnnotationNode(location: starbucksLocation, image: starbucksImage)


                         let tapGesture = UITapGestureRecognizer(target: self,  action: #selector(self.handleTap(_:)))
                        
                        self.sceneLocationView.isUserInteractionEnabled = true
                        self.sceneLocationView.addGestureRecognizer(tapGesture)
                        
                        self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: starbucksLocationNode)

                        let compassMarker = MGLPointAnnotation()
                        compassMarker.coordinate = starbucksCoordinate
                        self.compass.addAnnotation(compassMarker)
                        
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
    
    
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.sceneLocationView// as! ARSCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.red
            SCNTransaction.commit()
            
            result.node.isHidden = true
        }
    }
    
    
    
    // MARK: Update the user location
    
    @objc func updateUserLocation() {
        
        if let currentLocation = sceneLocationView.currentLocation() {
            DispatchQueue.main.async {
                if let bestEstimate = self.sceneLocationView.bestLocationEstimate(),
                    let position = self.sceneLocationView.currentScenePosition() {
                    
                    self.getFoursquareLocations(currentLocation)
                    DDLogDebug("")
                    DDLogDebug("Fetch current location")
                    DDLogDebug("best location estimate, position: \(bestEstimate.position), location: \(bestEstimate.location.coordinate), accuracy: \(bestEstimate.location.horizontalAccuracy), date: \(bestEstimate.location.timestamp)")
                    DDLogDebug("current position: \(position)")
                    DDLogDebug("altitude: \(currentLocation.altitude)")
                    
                    let translation = bestEstimate.translatedLocation(to: position)
                    
                    DDLogDebug("translation: \(translation)")
                    DDLogDebug("translated location: \(currentLocation)")
                    DDLogDebug("")
                }
                
                if self.userAnnotation == nil {
                    self.userAnnotation = MKPointAnnotation()
                    self.mapView.addAnnotation(self.userAnnotation!)
                }
                
                UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                    self.userAnnotation?.coordinate = currentLocation.coordinate
                }, completion: nil)
            
                if self.centerMapOnUserLocation {
                    UIView.animate(withDuration: 0.45, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                        self.mapView.setCenter(self.userAnnotation!.coordinate, animated: false)
                    }, completion: {
                        _ in
                        self.mapView.region.span = MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
                    })
                }
                
                if self.displayDebugging {
                    let bestLocationEstimate = self.sceneLocationView.bestLocationEstimate()
                    
                    if bestLocationEstimate != nil {
                        if self.locationEstimateAnnotation == nil {
                            self.locationEstimateAnnotation = MKPointAnnotation()
                            self.mapView.addAnnotation(self.locationEstimateAnnotation!)
                        }
                        
                        self.locationEstimateAnnotation!.coordinate = bestLocationEstimate!.location.coordinate
                    } else {
                        if self.locationEstimateAnnotation != nil {
                            self.mapView.removeAnnotation(self.locationEstimateAnnotation!)
                            self.locationEstimateAnnotation = nil
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Update the label information
    
    @objc func updateInfoLabel() {
        if let position = sceneLocationView.currentScenePosition() {
            infoLabel.text = "x: \(String(format: "%.2f", position.x)), y: \(String(format: "%.2f", position.y)), z: \(String(format: "%.2f", position.z))\n"
        }
        
        if let eulerAngles = sceneLocationView.currentEulerAngles() {
            infoLabel.text!.append("Euler x: \(String(format: "%.2f", eulerAngles.x)), y: \(String(format: "%.2f", eulerAngles.y)), z: \(String(format: "%.2f", eulerAngles.z))\n")
        }
        
        if let heading = sceneLocationView.locationManager.heading,
            let accuracy = sceneLocationView.locationManager.headingAccuracy {
            infoLabel.text!.append("Heading: \(heading)º, accuracy: \(Int(round(accuracy)))º\n")
        }
        
        let date = Date()
        let comp = Calendar.current.dateComponents([.hour, .minute, .second, .nanosecond], from: date)
        
        if let hour = comp.hour, let minute = comp.minute, let second = comp.second, let nanosecond = comp.nanosecond {
            infoLabel.text!.append("\(String(format: "%02d", hour)):\(String(format: "%02d", minute)):\(String(format: "%02d", second)):\(String(format: "%03d", nanosecond / 1000000))")
        }
    }
    
    //MARK: SceneLocationViewDelegate
    
    func sceneLocationViewDidAddSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        
        // Add Foursquare Location
        self.getFoursquareLocations(location)
        
        DDLogDebug("add scene location estimate, position: \(position), location: \(location.coordinate), accuracy: \(location.horizontalAccuracy), altitude: \(location.altitude), date: \(location.timestamp)")
    }
    
    func sceneLocationViewDidRemoveSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        DDLogDebug("remove scene location estimate, position: \(position), location: \(location.coordinate), accuracy: \(location.horizontalAccuracy), date: \(location.timestamp)")
    }
    
    func sceneLocationViewDidConfirmLocationOfNode(sceneLocationView: SceneLocationView, node: LocationNode) {
    }
    
    func sceneLocationViewDidSetupSceneNode(sceneLocationView: SceneLocationView, sceneNode: SCNNode) {
        
    }
    
    func sceneLocationViewDidUpdateLocationAndScaleOfLocationNode(sceneLocationView: SceneLocationView, locationNode: LocationNode) {
        
    }
}

extension DispatchQueue {
    func asyncAfter(timeInterval: TimeInterval, execute: @escaping () -> Void) {
        self.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(timeInterval * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: execute)
    }
}

extension UIView {
    func recursiveSubviews() -> [UIView] {
        var recursiveSubviews = self.subviews
        
        for subview in subviews {
            recursiveSubviews.append(contentsOf: subview.recursiveSubviews())
        }
        
        return recursiveSubviews
    }
}
