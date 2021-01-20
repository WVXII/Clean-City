//
//  Rubbish.swift
//  Clean City
//
//  Created by Alexandre GILBERT on 14/09/2020.
//  Copyright © 2020 Alexandre GILBERT. All rights reserved.
//

import UIKit
import Photos

class Rubbish: NSObject, NSCoding {
    var longitude: String
    var latitude: String
    var image: String
    //var longitude: CLLocationDegrees
    //var latitude: CLLocationDegrees

    
    init(longitude: String, latitude: String, image: String){
        self.longitude = longitude
        self.latitude = latitude
        self.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        longitude = aDecoder.decodeObject(forKey: "longitude") as? String ?? ""
        latitude = aDecoder.decodeObject(forKey: "latitude") as? String ?? ""
        image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(image, forKey: "image")
    }
}

