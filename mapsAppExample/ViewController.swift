//
//  ViewController.swift
//  mapsAppExample
//
//  Created by Kadir GÜLLÜOĞLU on 8.03.2023.
//

import UIKit
import MapKit
import CoreLocation
import CoreData


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    var locationManager = CLLocationManager()
    var listAnnotation = [Annotation]()
    var selectedLongitude = Double()
    var selectedLatitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        getData()
        
    
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(selectLocation(gestureRecognizer:)))
        
        gestureRecognizer.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(gestureRecognizer)
        
        for element in listAnnotation {
            let annotation =  MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: element.latitude, longitude: element.longitude)
            annotation.title = element.title
            annotation.subtitle = element.subtitle
            mapView.addAnnotation(annotation)
        }
     
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let coordinate = locations[0].coordinate
        let location = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
      
        let  region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    

    @objc func selectLocation(gestureRecognizer: UILongPressGestureRecognizer){
        
        if gestureRecognizer.state == .began{
            let selectedPoint = gestureRecognizer.location(in: mapView)
            let selectedCoordinate = mapView.convert(selectedPoint, toCoordinateFrom: mapView)
            selectedLatitude = selectedCoordinate.latitude
            selectedLongitude = selectedCoordinate.longitude
            let annotation = MKPointAnnotation()
            annotation.coordinate = selectedCoordinate
            annotation.title = nameTextField.text
            annotation.subtitle = noteTextField.text
            mapView.addAnnotation(annotation)

            saveData()
            nameTextField.text = ""
            noteTextField.text = ""
        }
    }
    
    
    
    func getData () {
        let context = getContext()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        request.returnsObjectsAsFaults = false
        
        do {
            let sonuclar = try context.fetch(request)
            if sonuclar.count > 0 {
                for sonuc in sonuclar as! [NSManagedObject]{
                    listAnnotation.append(Annotation(title: sonuc.value(forKey: "name") as? String,
                                                     subtitle: sonuc.value(forKey: "note") as? String,
                                                     latitude: sonuc.value(forKey: "latitude") as? CLLocationDegrees,
                                                      longitude: sonuc.value(forKey: "longitude") as? CLLocationDegrees))
                }
            }
        }
        catch{
            print("Veriler Yüklenemedi")
        }
        
    }
    

    
    func saveData(){
        let context = getContext()
        let newLocation = NSEntityDescription.insertNewObject(forEntityName: "Location", into: context)
        
        newLocation.setValue(nameTextField.text, forKey: "name")
        newLocation.setValue(noteTextField.text, forKey: "note")
        newLocation.setValue(selectedLongitude, forKey: "longitude")
        newLocation.setValue(selectedLongitude, forKey: "latitude")
        
        do{
            try context.save()
        }
        catch {
            print("Önbelleğe kaydedilemedi")
        }
        
    }
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        return context
    }
    
}

