//
//  FirstVC.swift
//  Installer
//
//  Created by Mikhail Lutskiy on 21.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Cocoa

class FirstVC: NSViewController {

    @IBOutlet weak var descrField: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        Loader.shared.loadConfig()
        self.descrField.stringValue = Language().getString(array: Loader.shared.config.descr ?? [String : String]())
    }
    
}
