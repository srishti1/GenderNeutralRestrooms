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
        //create custom annotation using the Name of the place, Coordinates and the subttitle
        self.title = title;
        self.coordinate = coordinate;
        self.subTit = subtitle;
        
    }
    func mapItem() -> MKMapItem{
        let placemark = MKPlacemark(coordinate: self.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
        
    }
    
}
