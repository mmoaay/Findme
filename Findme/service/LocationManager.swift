//
//  LocationManager.swift
//  Findme
//
//  Created by zhengperry on 2017/11/12.
//  Copyright © 2017年 mmoaay. All rights reserved.
//

import UIKit
import CoreLocation

typealias LocationUpdatedCompletion = (_ location:CLLocation) -> Void
typealias DistanceFilteredCompletion = (_ location:CLLocation) -> Void

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        filter(locations)
    }
    
    private func filter (_ locations: [CLLocation]) {
        for location in locations {
            print("horizontalAccuracy: ", location.horizontalAccuracy, ", verticalAccuracy: ", location.verticalAccuracy)
            
            if let completion = locationUpdatedCompletion { completion(location) }
            
            if let cur = current {
                if (cur.distance(from: location) >= Constant.DISTANCE_FILTER) {
                    current = location
                    if let completion = distanceFilteredCompletion { completion(location) }
                }
            } else {
                current = location
                if let completion = distanceFilteredCompletion { completion(location) }
            }
        }
    }
}

class LocationManager: NSObject {
    private let locationManager:CLLocationManager = { () -> CLLocationManager in
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        return locationManager
    }()
    
    private var locationUpdatedCompletion:LocationUpdatedCompletion? = nil
    private var distanceFilteredCompletion:DistanceFilteredCompletion? = nil
    
    static let shared = LocationManager();
    
    var current:CLLocation? = nil
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func start(locationUpdated: LocationUpdatedCompletion? = nil, distanceFiltered: DistanceFilteredCompletion? = nil) {
        locationUpdatedCompletion = locationUpdated
        distanceFilteredCompletion = distanceFiltered
        
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        current = nil
    }
}
