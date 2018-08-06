//
//  l18n.swift
//  Installer
//
//  Created by Mikhail Lutskiy on 16.07.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation
import ObjectMapper

class l18n: Mappable {
    
    var en: String?
    var en_UK: String?
    var ru: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        en <- map["en"]
        en_UK <- map["en_UK"]
        ru <- map["ru"]
    }
}
