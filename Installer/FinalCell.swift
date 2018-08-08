//
//  FinalCell.swift
//  Installer
//
//  Created by Mikhail Lutskiy on 08.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Cocoa

class FinalCell: NSTableCellView {

    @IBOutlet weak var openButton: NSButton!
    var path: String!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    @IBAction func openAction(_ sender: Any) {
        let applicationsPath = NSSearchPathForDirectoriesInDomains(.applicationDirectory, .userDomainMask, true)[0]
        let destURL = URL(fileURLWithPath: applicationsPath, isDirectory: true)
        let completelyDestURL = destURL.appendingPathComponent(Loader.shared.config.name ?? "Application", isDirectory: true)
        
        let script = NSAppleScript(source: "do shell script \"open '" + completelyDestURL.appendingPathComponent(path).path + "'\"")
        var errorInfo: NSDictionary?
        script?.executeAndReturnError(&errorInfo)
        if let error = errorInfo {
            print("ERROR: \(error)")
//            self.errorReadingResults(question: "Ошибка", text: "Ошибка при разархивировании")
        }
    }
}
