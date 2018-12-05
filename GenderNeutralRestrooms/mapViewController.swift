//
//  mapViewController.swift
//  GenderNeutralRestrooms
//
//  Created by Srishti on 02/12/18.
//  Copyright © 2018 Srishti Miglani. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation
import CDYelpFusionKit

class MapViewController: ViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    let yelpAPIClient = CDYelpAPIClient(apiKey: "GmuBVXSGq4ts8A_LEkusZgNtgDep7QwQD3Qilq24VcBrOQV9v85LqqFHoprXvNBdfhfoVrXN-8XMp3hX8Ju8g-p-bu9h1HJCoojJ2urtkfGlWKFIuaI-xpS1b3MDXHYx")
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    var latitude: Double?
    var longitude: Double?
    var location: CLLocation?
    var Annotations: Array<MKPointAnnotation> = []
    var results:Array<CDYelpBusiness> = []
    var ann: Annotation = Annotation(title: "" , coordinate: CLLocationCoordinate2D(latitude: 34.01925306236066, longitude: -118.28152770275595), subtitle: "")
    var selected:Annotation = Annotation(title: "" , coordinate: CLLocationCoordinate2D(latitude: 34.01925306236066, longitude: -118.28152770275595), subtitle: "")
//    var results:Array<CDYelpBusiness> {
//        get {
//            return (self.tabBarController!.viewControllers![0] as! ListViewController).results
//        }
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        results = getResults()
        mapView.reloadInputViews()
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //results = getResults()
        mapView.delegate = self
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        //Zoom to user location
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 2000, longitudinalMeters: 2000)
            mapView.setRegion(viewRegion, animated: false)
            latitude = userLocation.latitude
            longitude = userLocation.longitude
        }
        
        self.locationManager = locationManager
        DispatchQueue.main.async {
//            let annotation = MKPointAnnotation()
            self.locationManager.startUpdatingLocation()
        }
    }
    func getResults() -> Array<CDYelpBusiness>{
        var toReturn: Array<CDYelpBusiness> = []
        yelpAPIClient.cancelAllPendingAPIRequests()
        yelpAPIClient.searchBusinesses(byTerm: nil,
                                       location: nil,
                                       latitude: latitude ?? 34.01925306236066, //userLocation.latitude,
            longitude: longitude ?? -118.28152770275595, //userLocation.longitude,
            radius: 40000,
            categories: nil ,
            locale: CDYelpLocale.english_unitedStates,
            limit: 50,
            offset: 0,
            sortBy: .distance ,
            priceTiers: nil,
            openNow: false,
            openAt: nil,
            attributes: [.genderNeutralRestrooms] ) { (response) in
                if let response = response,
                    let businesses = response.businesses,
                    businesses.count > 0 {
                    
                    toReturn = businesses
                    self.results = businesses
                }
        }
        return toReturn
    }
    func displayAnnotation(){
        for i in 0...(self.results.count-1){
            let coord = CLLocationCoordinate2D(latitude: self.results[i].coordinates?.latitude ?? 100.00, longitude: self.results[i].coordinates?.longitude ?? 120.5)
            ann = Annotation(title: self.results[i].name ?? "no name", coordinate: coord, subtitle: self.results[i].location?.addressOne ?? "Def val")
            self.mapView.addAnnotation(ann)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print("new location: ", locations[0])
        if results.count > 0{
            displayAnnotation()
        }
        //location = (locations.last as! CLLocation)
        location = locations.last!
        latitude =  location?.coordinate.latitude ?? 37.7710347
        longitude =  location?.coordinate.longitude ?? -122.4040795
//        if let userLocation = location?.coordinate {
//            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 2000, longitudinalMeters: 2000)
//            mapView.setRegion(viewRegion, animated: false)
//        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Annotation else{
            return nil
        }
        let identifier = "Marker"
        var annotationView:MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as?
            MKMarkerAnnotationView{
            dequeuedView.annotation = annotation
            annotationView = dequeuedView
        }else{
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return annotationView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let launchOptions = [MKLaunchOptionsMapCenterKey: CLLocationCoordinate2D(latitude: latitude ?? 34.01925306236066, longitude: longitude ?? -118.28152770275595) ]
        selected.mapItem().openInMaps(launchOptions: launchOptions)
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selected = (view.annotation as? Annotation)!
    }
}
