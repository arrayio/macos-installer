//
//  LicenseVC.swift
//  Installer
//
//  Created by Mikhail Lutskiy on 16.07.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Cocoa
import WebKit

class LicenseVC: NSViewController {

    @IBOutlet weak var licenseTextView: NSScrollView!
    @IBOutlet var textView: NSTextView!
    @IBOutlet weak var licenseWebView: WebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bundle = Bundle.main
        Loader.shared.loadConfig()
        let filePath = bundle.path(forResource: Language().getString(array: Loader.shared.config.license ?? [String : String]()), ofType: nil)
        licenseWebView.mainFrameURL = filePath
    }
    
}
