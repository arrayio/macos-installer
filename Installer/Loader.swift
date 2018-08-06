//
//  Loader.swift
//  Installer
//
//  Created by Mikhail Lutskiy on 16.07.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation
import ObjectMapper

class Loader {
    static let shared = Loader()
    
    var config: Config!
    
    func loadConfig () {
        let bundle = Bundle.main
        let file = bundle.path(forResource: "config", ofType: "json")
        print( try! String(contentsOfFile: file!))
        config = Config(JSONString: try! String(contentsOfFile: file!))
    }
}
