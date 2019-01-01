//
//  PopoverViewController.swift
//  RitsAssistant
//
//  Created by Zhou Fang on 2018/12/31.
//  Copyright © 2018 Zhou Fang. All rights reserved.
//

import Cocoa
import Alamofire
import CoreWLAN

class PopoverViewController: NSViewController {

    @IBOutlet weak var statusLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if NetworkReachabilityManager()!.isReachableOnEthernetOrWiFi {
            print("Yes! internet is available.")
            guard let SSID = CWWiFiClient.shared().interface()?.ssid() else {
                print("cannot get wifi name.")
                return
            }
            if SSID != "FzWiFi" {
                statusLabel.stringValue = "Please connect to Rits-Webauth."
            } else {
                // TODO: Internet confirmation
                print("placeholder")
            }
        }
        
    }
    
    @IBAction func quitAssistant(_ sender: Any?) {
        NSApplication.shared.terminate(sender)
    }
    
    @IBAction func openAccountSetting(_ sender: Any?) {
        // get AppDelegate of RitsAssistant
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        // change view controller
        appDelegate.menuBarPopover.contentViewController = AccountViewController.freshController()
    }
}

extension PopoverViewController {
    static func freshController() -> PopoverViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("PopoverViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? PopoverViewController else {
            fatalError("Error: Cannot find Popover View Controller.")
        }
        return viewcontroller
    }
    
    static func accountController() -> PopoverViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("AccountViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? PopoverViewController else {
            fatalError("Error: Cannot find Popover View Controller.")
        }
        return viewcontroller
    }
}
