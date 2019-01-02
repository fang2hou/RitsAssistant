//
//  MainPopoverViewController.swift
//  RitsAssistant
//
//  Created by Zhou Fang on 2019/01/02.
//  Copyright © 2019 Zhou Fang. All rights reserved.
//

import Foundation
import Cocoa
import Alamofire
import CoreWLAN

class MainPopoverViewCotroller: NSViewController {
    
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
    
    @IBAction func testButton(_ sender: Any?) {
        statusLabel.stringValue = "test text test text test text test text"
    }
    
    @IBAction func openSiteButtonPressed(_ sender: Any?) {
        print("pressed")
    }
    
    @IBAction func quitAssistant(_ sender: Any?) {
        NSApplication.shared.terminate(sender)
    }
    
    @IBAction func openAccountSetting(_ sender: Any?) {
        presentAsSheet(AccountViewController.freshController())
    }
}

extension MainPopoverViewCotroller {
    static func freshController() -> MainPopoverViewCotroller {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("MainPopoverViewCotroller")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? MainPopoverViewCotroller else {
            fatalError("Error: Cannot find Main Popover View Controller.")
        }
        return viewcontroller
    }
}
