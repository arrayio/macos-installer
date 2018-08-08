//
//  ContainerVC.swift
//  Installer
//
//  Created by Mikhail Lutskiy on 13.07.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Cocoa

class ContainerVC: NSPageController, NSPageControllerDelegate {
    
    @IBOutlet weak var licenseViewButtons: NSView!
    @IBOutlet weak var continueButton: NSButton!
    @IBOutlet weak var closeButton: NSButton!
    
    var viewArray = ["one", "two", "three", "four"]

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        self.arrangedObjects = viewArray
        self.transitionStyle = .horizontalStrip
        self.licenseViewButtons.isHidden = true
        self.closeButton.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(navigateForward(_:)), name: .navigationForward, object: nil)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        Loader.shared.loadConfig()
        self.view.window?.title = (Loader.shared.config.title?.en)!
    }
    
    override func scrollWheel(with event: NSEvent) {
        
    }
    
    func pageController(_ pageController: NSPageController, viewControllerForIdentifier identifier: NSPageController.ObjectIdentifier) -> NSViewController {
        print(identifier.rawValue)
        switch identifier.rawValue {
        case "one":
            return self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "WelcomeVC")) as! NSViewController
        case "two":
            return self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "LicenseVC")) as! LicenseVC
        case "three":
            return self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "ProgressVC")) as! ProgressVC
        case "four":
            return self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "FinalVC")) as! FinalVC
        default:
            return self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: identifier.rawValue)) as! NSViewController
        }
    }

    func pageController(_ pageController: NSPageController, identifierFor object: Any) -> NSPageController.ObjectIdentifier {
        return NSPageController.ObjectIdentifier(rawValue: String(describing: object))
    }
    
    func pageControllerDidEndLiveTransition(_ pageController: NSPageController) {
        self.completeTransition()
    }
    
    override func navigateForward(_ sender: Any?) {
        super.navigateForward(sender)
        switch self.selectedIndex {
        case 0:
            self.continueButton.isHidden = false
            self.licenseViewButtons.isHidden = true
            self.closeButton.isHidden = true
        case 1:
            self.continueButton.isHidden = true
            self.licenseViewButtons.isHidden = false
            self.closeButton.isHidden = true
        case 2:
            self.continueButton.isHidden = true
            self.licenseViewButtons.isHidden = true
            self.closeButton.isHidden = true
        case 3:
            self.continueButton.isHidden = true
            self.licenseViewButtons.isHidden = true
            self.closeButton.isHidden = false
        default:
            break
        }
    }
    
    @IBAction func declineAction(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    @IBAction func closeAction(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
}
