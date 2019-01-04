//
//  MainPopoverViewController.swift
//  RitsAssistant
//
//  Created by Zhou Fang on 2019/01/02.
//  Copyright © 2019 Zhou Fang. All rights reserved.
//

import Cocoa

enum connectButtonTypes {
    case connect
    case disconnect
    case viewPassword
}

class MainPopoverViewCotroller: NSViewController, AccountSettingDelegate, RitsAssistantWifiHelperDelegate {

    var internetStatus: Bool = false
    var ritswifiStatus: Bool = false
    
    let userData = UserData()
    let WiFiHelper = RitsAssistantWiFiHelper()
    
    var buttonType: connectButtonTypes = .viewPassword {
        didSet {
            switch buttonType {
            case .viewPassword:
                connectButton.title = "View Rits-Webauth password"
                connectButton.tag = 0
            case .connect:
                connectButton.title = "Connect"
                connectButton.tag = 1
            case .disconnect:
                connectButton.title = "Disconnect"
                connectButton.tag = 2
            }
        }
    }
    
    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var statusImage: NSImageView!
    @IBOutlet weak var connectButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        internetStatus = WiFiHelper.internetAvailable
        ritswifiStatus = WiFiHelper.hasConnectedToRitsWebauth

        updateUI()
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
    
    func internetDidChange(forStatus status: Bool) {
        internetStatus = status
        updateUI()
    }
    
    func ritsWifiDidChange(forStatus status: Bool) {
        ritswifiStatus = status
        updateUI()
    }
    
    func updateUI() {
        if ritswifiStatus {
            if internetStatus {
                statusLabel.stringValue = "Connected to Internet."
                buttonType = .disconnect
            } else {
                statusLabel.stringValue = "No Internet with Rits-Webauth."
                buttonType = .connect
            }
        } else {
            statusLabel.stringValue = "Please connect to Rits-Webauth."
            buttonType = .viewPassword
        }
        
        
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
