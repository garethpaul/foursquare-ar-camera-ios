//
//  MBXCompassMapView.swift
//  MapboxCompassMapViewSwift
//
//  Created by Jordan Kiley on 7/19/17.
//  Copyright © 2017 Mapbox. All rights reserved.
//

import Mapbox

class MBXCompassMapView: MGLMapView, MGLMapViewDelegate {
    
    var isMapInteractive : Bool = true {
        didSet {
            
            // Disable individually, then add custom gesture recognizers as needed.
            self.isZoomEnabled = false
            self.isScrollEnabled = false
            self.isPitchEnabled = false
            self.isRotateEnabled = false
        }
    }
    
    // Create a map view and set the style.
    override convenience init(frame: CGRect, styleURL: URL?) {
        self.init(frame: frame)
        self.styleURL = styleURL
    }
    
    // Create a map view.
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.alpha = 0.8
        self.delegate = self
        hideMapSubviews()
    }
    
    // Make the map view a circle.
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.width / 2
    }
    
    // Hide the Mapbox wordmark, attribution button, and compass view. Move the attribution button and wordmark based on your design. See www.mapbox.com/help/how-attribution-works/#how-attribution-works for more information about attribution requirements.
    private func hideMapSubviews() {
        self.logoView.isHidden = true
        self.attributionButton.isHidden = true
        self.compassView.isHidden = true
    }
    
    // Set the user tracking mode to `.followWithHeading`. This rotates the map based on the direction that the user is facing.
    func mapViewWillStartLoadingMap(_ mapView: MGLMapView) {
        self.userTrackingMode = .followWithHeading
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Adds a border to the map view.
    func setMapViewBorderColorAndWidth(color: CGColor, width: CGFloat) {
        self.layer.borderWidth = width
        self.layer.borderColor = color
    }
}

extension MBXCompassMapView {
    func setupUserTrackingMode() {
        self.showsUserLocation = true
        self.setUserTrackingMode(.followWithHeading, animated: false)
        self.displayHeadingCalibration = false
    }
}

