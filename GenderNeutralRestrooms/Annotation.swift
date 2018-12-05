//
//  Annotation.swift
//  GenderNeutralRestrooms
//
//  Created by Srishti on 03/12/18.
//  Copyright © 2018 Srishti Miglani. All rights reserved.
//

import UIKit
import Contacts
import MapKit

class Annotation: NSObject,MKAnnotation {
    
    var title : String?
    var subTit : String?
    var coordinate : CLLocationCoordinate2D
    
    init(title:String,coordinate : CLLocationCoordinate2D,subtitle:String){
        self.title = title; //name
        self.coordinate = coordinate;
        self.subTit = subtitle; //first line
        
    }
    func mapItem() -> MKMapItem{
        //let addressDictionary = [CNPostalAddressStreetKey: subTit!]
        let placemark = MKPlacemark(coordinate: self.coordinate)
        //let placemark = MKPlacemark(coordinate: self.coordinate, addressDictionary: addressDictionary)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    
    }
    
}
