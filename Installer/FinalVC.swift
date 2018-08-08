//
//  FinalVC.swift
//  Installer
//
//  Created by Mikhail Lutskiy on 07.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Cocoa

class FinalVC: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do view setup here.
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return NameStorage.shared.data.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "FinalCell"), owner: self) as! FinalCell
        cell.textField?.stringValue = NameStorage.shared.data[row]
        cell.openButton.title = NameStorage.shared.data[row]
        cell.path = NameStorage.shared.data[row]
        return cell
    }
    
    
}
