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
    
    var viewArray = ["one", "two", "three"]

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        self.arrangedObjects = viewArray
        self.transitionStyle = .horizontalStrip
        self.licenseViewButtons.isHidden = true
    }
    
    func pageController(_ pageController: NSPageController, viewControllerForIdentifier identifier: NSPageController.ObjectIdentifier) -> NSViewController {
        print(identifier.rawValue)
        switch identifier.rawValue {
        case "one":
            return self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "WelcomeVC")) as! NSViewController
        case "two":
            return self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "LicenseVC")) as! NSViewController
        case "three":
            return self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "ProgressVC")) as! NSViewController
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
        case 1:
            self.continueButton.isHidden = true
            self.licenseViewButtons.isHidden = false
        case 2:
            self.continueButton.isHidden = true
            self.licenseViewButtons.isHidden = true
        default:
            break
        }
    }
    
    @IBAction func declineAction(_ sender: Any) {
    }
}
