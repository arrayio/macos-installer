//
//  AppDelegate.swift
//  Installer
//
//  Created by Mikhail Lutskiy on 13.07.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Cocoa

let loader = Loader.shared

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        loader.loadConfig()
        let langStr = Locale.current.languageCode
        print(langStr)
        let langAnother = Locale.preferredLanguages[0]
        print(langAnother)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        NSApplication.shared.terminate(self)
        return true
    }


}

