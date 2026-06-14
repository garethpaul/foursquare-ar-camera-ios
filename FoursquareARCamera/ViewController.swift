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
import ReachabilitySwift

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
    private let venueLookupRetryDelay: TimeInterval = 30.0
    private var hasVenueTapGesture = false
    
    var adjustNorthByTappingSidesOfScreen = false

    private func configuredValue(_ key: String) -> String? {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
            return nil
        }

        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedValue.isEmpty || trimmedValue.contains("$(") {
            return nil
        }

        return trimmedValue
    }

    private func allowVenueLookupRetryAfterDelay(reason: String) {
        DDLogWarn("\(reason) Allowing venue lookup retry after \(Int(venueLookupRetryDelay)) seconds.")
        DispatchQueue.main.asyncAfter(timeInterval: venueLookupRetryDelay) { [weak self] in
            self?.loaded = false
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        if let reach = Reachability() {
            if reach.currentReachabilityString == "No Connection" {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Oops", message: "We are currently struggling to access to the internet. This app requires access to the internet in order to find locations around you.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                        // perhaps use action.title here
                    })
                    self.present(alert, animated: true)
                }
            }
        } else {
            DDLogWarn("Skipping reachability check because Reachability could not be created.")
        }
    
        
        // Add Foursquare Attribution
        let imgAttr = UIImage.init(named: "fsq")
        let imgAttrView = UIImageView.init(image: imgAttr)
        
        
        imgAttrView.frame = CGRect(x: imgAttrView.frame.origin.x,
                                   y: self.view.frame.height-120,
                                   width: self.view.frame.width-100,
                                   height: 200)
        imgAttrView.center.x = self.view.center.x
        imgAttrView.contentMode = UIViewContentMode.scaleAspectFit
        
        
        sceneLocationView.addSubview(imgAttrView)
        sceneLocationView.showAxesNode = true
        sceneLocationView.locationDelegate = self
        
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
        DDLogDebug("Scene image tapped")
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
            guard let clientID = configuredValue("FoursquareClientID"),
                let clientSecret = configuredValue("FoursquareClientSecret") else {
                self.allowVenueLookupRetryAfterDelay(reason: "Skipping Foursquare venue lookup because API credentials are not configured.")
                return
            }

            let categoryId = "4d4b7105d754a06374d81259" // food
            let ll = lat + "," + lng
            let parameters: Parameters = [
                "v": "20161016",
                "ll": ll,
                "client_id": clientID,
                "client_secret": clientSecret,
                "limit": 5,
                "categoryId": categoryId,
                "radius": 200,
            ]
            
            // Send HTTP request
            Alamofire.request("https://api.foursquare.com/v2/venues/search", parameters: parameters)
                .validate(statusCode: 200..<300)
                .validate { _, response, _ in
                    guard let finalURL = response.url,
                        let components = URLComponents(url: finalURL, resolvingAgainstBaseURL: false),
                        components.scheme == "https",
                        components.host == "api.foursquare.com",
                        components.user == nil,
                        components.password == nil,
                        components.port == nil,
                        components.percentEncodedPath == "/v2/venues/search",
                        components.fragment == nil else {
                        return .failure(NSError(domain: "FoursquareResponseValidation", code: 1, userInfo: nil))
                    }

                    return .success
                }
                .validate(contentType: ["application/json"])
                .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let resp = json["response"]
                    let venues = resp["venues"]
                    var validVenueCount = 0
                    // Iterate through the venues
                    for venue in venues {
                        guard let name = venue.1["name"].string,
                            let venueLatitude = venue.1["location"]["lat"].double,
                            let venueLongitude = venue.1["location"]["lng"].double,
                            let distance = venue.1["location"]["distance"].double,
                            venueLatitude.isFinite,
                            (-90.0...90.0).contains(venueLatitude),
                            venueLongitude.isFinite,
                            (-180.0...180.0).contains(venueLongitude),
                            distance.isFinite,
                            distance >= 0 else {
                            DDLogWarn("Skipping malformed Foursquare venue response.")
                            continue
                        }

                        let categoryName = venue.1["categories"].array?.first?["name"].string ?? "Venue"
                        let ratingStr = Int(distance * 3.28084)
                        
                        let frameSize = CGRect(x: 0, y: 0, width: 362, height: 291)
                        let fsview = FSQView(frame: frameSize)
                        fsview.venueName.text = name
                        fsview.categoryName.text = categoryName
                        fsview.ratingStr.text = "\(ratingStr)ft"
                        
                        var image = UIImage.imageWithView(view: fsview)
                        
                        
                        // Mask an image to avoid pixelated images in AR.
                        if let mask = UIImage(named: "fsqMask") {
                            image = UIImage.aImage(image: image, mask: mask)
                        } else {
                            DDLogWarn("Rendering Foursquare venue without the fsqMask asset.")
                        }
                        image = UIImage.resizeImage(image: image, newHeight: 200)
                        
                        let venueCoordinate = CLLocationCoordinate2D(latitude: venueLatitude, longitude: venueLongitude)
                        let venueLocation = CLLocation(coordinate: venueCoordinate, altitude: 30.84)
                        let venueImage = image
                        let venueLocationNode = LocationAnnotationNode(location: venueLocation, image: venueImage)


                        self.ensureVenueTapGesture()
                        
                        self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: venueLocationNode)

                        let compassMarker = MGLPointAnnotation()
                        compassMarker.coordinate = venueCoordinate
                        self.compass.addAnnotation(compassMarker)
                        validVenueCount += 1
                        
                    }

                    if validVenueCount == 0 {
                        self.allowVenueLookupRetryAfterDelay(reason: "No valid Foursquare venues were returned.")
                    }
                    
                case .failure:
                    self.allowVenueLookupRetryAfterDelay(reason: "Foursquare venue lookup failed.")
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

        guard let result = hitResults.first else {
            return
        }

        guard let material = result.node.geometry?.firstMaterial else {
            DDLogWarn("Skipping AR node highlight because material is unavailable.")
            return
        }

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

    private func ensureVenueTapGesture() {
        if hasVenueTapGesture {
            return
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        sceneLocationView.isUserInteractionEnabled = true
        sceneLocationView.addGestureRecognizer(tapGesture)
        hasVenueTapGesture = true
    }
    
    
    
    // MARK: Update the user location
    
    @objc func updateUserLocation() {
        
        if let currentLocation = sceneLocationView.currentLocation() {
            DispatchQueue.main.async {
                if let bestEstimate = self.sceneLocationView.bestLocationEstimate(),
                    let position = self.sceneLocationView.currentScenePosition() {
                    
                    self.getFoursquareLocations(currentLocation)
                    DDLogDebug("Updating AR location estimate")
                    
                    _ = bestEstimate.translatedLocation(to: position)
                    
                    DDLogDebug("Updated translated AR location estimate")
                }
                
                let userAnnotation: MKPointAnnotation
                if let existingUserAnnotation = self.userAnnotation {
                    userAnnotation = existingUserAnnotation
                } else {
                    userAnnotation = MKPointAnnotation()
                    self.userAnnotation = userAnnotation
                    self.mapView.addAnnotation(userAnnotation)
                }
                
                UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                    userAnnotation.coordinate = currentLocation.coordinate
                }, completion: nil)
            
                if self.centerMapOnUserLocation {
                    UIView.animate(withDuration: 0.45, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                        self.mapView.setCenter(userAnnotation.coordinate, animated: false)
                    }, completion: {
                        _ in
                        self.mapView.region.span = MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
                    })
                }
                
                if self.displayDebugging {
                    if let bestLocationEstimate = self.sceneLocationView.bestLocationEstimate() {
                        let locationEstimateAnnotation: MKPointAnnotation
                        if let existingLocationEstimateAnnotation = self.locationEstimateAnnotation {
                            locationEstimateAnnotation = existingLocationEstimateAnnotation
                        } else {
                            locationEstimateAnnotation = MKPointAnnotation()
                            self.locationEstimateAnnotation = locationEstimateAnnotation
                            self.mapView.addAnnotation(locationEstimateAnnotation)
                        }

                        locationEstimateAnnotation.coordinate = bestLocationEstimate.location.coordinate
                    } else {
                        if let locationEstimateAnnotation = self.locationEstimateAnnotation {
                            self.mapView.removeAnnotation(locationEstimateAnnotation)
                            self.locationEstimateAnnotation = nil
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Update the label information
    
    @objc func updateInfoLabel() {
        var infoLabelLines = [String]()

        if let position = sceneLocationView.currentScenePosition() {
            infoLabelLines.append("x: \(String(format: "%.2f", position.x)), y: \(String(format: "%.2f", position.y)), z: \(String(format: "%.2f", position.z))")
        }
        
        if let eulerAngles = sceneLocationView.currentEulerAngles() {
            infoLabelLines.append("Euler x: \(String(format: "%.2f", eulerAngles.x)), y: \(String(format: "%.2f", eulerAngles.y)), z: \(String(format: "%.2f", eulerAngles.z))")
        }
        
        if let heading = sceneLocationView.locationManager.heading,
            let accuracy = sceneLocationView.locationManager.headingAccuracy {
            infoLabelLines.append("Heading: \(heading)º, accuracy: \(Int(round(accuracy)))º")
        }
        
        let date = Date()
        let comp = Calendar.current.dateComponents([.hour, .minute, .second, .nanosecond], from: date)
        
        if let hour = comp.hour, let minute = comp.minute, let second = comp.second, let nanosecond = comp.nanosecond {
            infoLabelLines.append("\(String(format: "%02d", hour)):\(String(format: "%02d", minute)):\(String(format: "%02d", second)):\(String(format: "%03d", nanosecond / 1000000))")
        }

        infoLabel.text = infoLabelLines.joined(separator: "\n")
    }
    
    //MARK: SceneLocationViewDelegate
    
    func sceneLocationViewDidAddSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        
        // Add Foursquare Location
        self.getFoursquareLocations(location)
        
        DDLogDebug("Added scene location estimate")
    }
    
    func sceneLocationViewDidRemoveSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        DDLogDebug("Removed scene location estimate")
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
