//
//  MainPopoverViewController.swift
//  RitsAssistant
//
//  Created by Zhou Fang on 2019/01/02.
//  Copyright © 2019 Zhou Fang. All rights reserved.
//

import Cocoa
import CoreWLAN

class MainPopoverViewCotroller: NSViewController, AccountSettingDelegate, RitsAssistantWifiHelperDelegate {

    let userData = UserData()
    let WiFiHelper = RitsAssistantWiFiHelper()
    
    @IBOutlet weak var statusLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func testButton(_ sender: Any?) {
        if statusLabel.stringValue != "test text test text test text test text" {
            statusLabel.stringValue = "test text test text test text test text"
        } else {
            statusLabel.stringValue = "test"
        }
        
        WiFiHelper.userAgent = .Chrome
    }
    
    @IBAction func openSiteButtonPressed(_ sender: Any?) {
        connectToInternet()
    }
    
    // exit application
    @IBAction func quitAssistant(_ sender: Any?) {
        NSApplication.shared.terminate(sender)
    }
    
    // Account Setting View Controller Delegate
    // handle the value passed by account setting view controller
    func updateRainbowAccount(withId id: String, andPassword password: String) {
        userData.rainbowID = id
        userData.rainbowPassword = password
        userData.save()
    }

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainToAccountSetting" {
            // Account Setting View Controller
            // set main view controller to be the delegate of account setting view controller.
            let destinationViewController = segue.destinationController as! AccountSettingViewController
            destinationViewController.delegate = self
            
            // pass on the values for displaying on text field
            destinationViewController.savedRainbowID = userData.rainbowID
            destinationViewController.savedRainbowPassword = userData.rainbowPassword
        }
    }
    
    func connectToInternet() {
        WiFiHelper.testMethod(withId: userData.rainbowID, andPassword: userData.rainbowPassword)
    }
    
    func connect() {
        print("s")
    }
}

extension MainPopoverViewCotroller {
    // return a instance of main popover view controller
    static func freshController() -> MainPopoverViewCotroller {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("MainPopoverViewCotroller")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? MainPopoverViewCotroller else {
            fatalError("Error: Cannot find Main Popover View Controller.")
        }
        return viewcontroller
    }
}
