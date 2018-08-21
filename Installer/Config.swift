//
//  Config.swift
//  Installer
//
//  Created by Mikhail Lutskiy on 16.07.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation
import ObjectMapper

class Config: Mappable {
    
    var name: String?
    var image: String?
    var icon: String?
    var script: String?
    var gpgKey: String?
    var title: [String : String]?
    var descr: [String : String]?
    var license: [String : String]?
    var downloadLinks: [String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        image <- map["image"]
        icon <- map["icon"]
        script <- map["script"]
        gpgKey <- map["gpgKey"]
        title <- map["title"]
        descr <- map["description"]
        license <- map["licenseFile"]
        downloadLinks <- map["downloadLinks"]
    }
    
    
}
