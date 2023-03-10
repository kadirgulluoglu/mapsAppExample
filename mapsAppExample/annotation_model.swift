//
//  annotation_model.swift
//  mapsAppExample
//
//  Created by Kadir Güllüoğlu on 10.03.2023.
//

import Foundation
import CoreLocation

class Annotation{
    let title: String
    let subtitle : String
    let latitude : CLLocationDegrees
    let longitude : CLLocationDegrees
    
    init(title: String?, subtitle: String?, latitude: Double?, longitude: Double?) {
        self.title = title ?? "untitled"
        self.subtitle = subtitle ?? "untitled"
        self.latitude = latitude ?? 0
        self.longitude = longitude ?? 0
    }
}
