//
//  ViewController.swift
//  mapsAppExample
//
//  Created by Kadir GÜLLÜOĞLU on 8.03.2023.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.delegate = self
    }


}

