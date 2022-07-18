//
//  Location.swift
//  ToDoApp
//
//  Created by Andriy on 30.06.2022.
//

import Foundation
import CoreLocation

struct Location {
    let name: String
    let coordinate: CLLocationCoordinate2D?
    
    //Властивість яка буде робити з словника Location
    var dict: [String : Any] {
        var dict: [String : Any] = [:]
        
        //Беремо з словника імя та передаємт в властивість
        dict["name"] = name
        
        //Якщо є координати то присвоїмо їх coordinate
        if let coordinate = coordinate {
            dict["latitude"] = coordinate.latitude
            dict["longitude"] = coordinate.longitude
        }
        return dict
    }
    
    init(name: String, coordinate: CLLocationCoordinate2D? = nil) {
        self.name = name
        self.coordinate = coordinate
    }
}

//Для створення Location через dictionary
extension Location {
    typealias PlistDicrionary = [String : Any]
    
    init?(dict: PlistDicrionary) {
        
        self.name = dict["name"] as! String
        
        //Якщо будуть координати то створимо їх
        if let latitude = dict["longitude"] as? Double,
           let longitude = dict["latitude"] as? Double {
            
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            self.coordinate = nil
        }
    }
}

//Equatable - для того щоб порівнювати 2 однакові властивості.Для того щоб порівняти coordinate напишемо розширення
extension Location: Equatable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        guard rhs.coordinate?.latitude ==
                lhs.coordinate?.latitude &&
              lhs.coordinate?.longitude ==
                rhs.coordinate?.longitude &&
              lhs.name == rhs.name else { return false }
        return true
    }
}
