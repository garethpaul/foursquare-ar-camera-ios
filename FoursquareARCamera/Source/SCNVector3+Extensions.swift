//
//  SCNVecto3+Extensions.swift
//  FoursquareARCamera
//
//  Created by Gareth Paul Jones 02/07/2017.
//  Copyright © 2017 Foursquare. All rights reserved.
//

import SceneKit

extension SCNVector3 {
    ///Calculates distance between vectors
    ///Doesn't include the y axis, matches functionality of CLLocation 'distance' function.
    func distance(to anotherVector: SCNVector3) -> Float {
        return sqrt(pow(anotherVector.x - x, 2) + pow(anotherVector.z - z, 2))
    }
}
