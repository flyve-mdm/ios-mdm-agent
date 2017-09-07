/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * Location.swift is part of flyve-mdm-ios
 *
 * flyve-mdm-ios is a subproject of Flyve MDM. Flyve MDM is a mobile
 * device management software.
 *
 * flyve-mdm-ios is free software: you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 3
 * of the License, or (at your option) any later version.
 *
 * flyve-mdm-ios is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * ------------------------------------------------------------------------------
 * @author    Hector Rondon
 * @date      14/07/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-agent
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import Foundation
import CoreLocation

/// LocationDelegate protocol
protocol LocationDelegate: class {
    /// current location
    func currentLocation(coordinate: CLLocationCoordinate2D)
}

/// Location class
class Location: NSObject {
    /// location delegate
    weak var delegate: LocationDelegate?
    /// locationManager
    let locationManager = CLLocationManager()
}

// MARK: extension
extension Location: CLLocationManagerDelegate {
    
    /// request current location
    func getCurrentLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
    }
    
    /// update current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil

        if let coordinate = locations.first?.coordinate {
            delegate?.currentLocation(coordinate: coordinate)
        }
    }
}
