//
//  FloatingPoint+Radians.swift
//  FoursquareARCamera
//
//  Created by Gareth Paul Jones 02/07/2017.
//  Copyright © 2017 Foursquare. All rights reserved.
//

import Foundation

public extension FloatingPoint {
    public var degreesToRadians: Self { return self * .pi / 180 }
    public var radiansToDegrees: Self { return self * 180 / .pi }
}
