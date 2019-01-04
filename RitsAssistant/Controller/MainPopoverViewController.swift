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

    var internetStatus: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    var ritswifiStatus: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    let userData = UserData()
    let WiFiHelper = RitsAssistantWiFiHelper()
    
    var buttonType: connectButtonTypes = .viewPassword {
        didSet {
            switch self.buttonType {
            case .viewPassword:
                self.connectButton.title = "Copy Rits-Webauth password"
                self.connectButton.tag = 0
            case .connect:
                self.connectButton.title = "Connect"
                self.connectButton.tag = 1
            case .disconnect:
                self.connectButton.title = "Disconnect"
                self.connectButton.tag = 2
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
        
        WiFiHelper.delegate = self

        updateUI()
    }
    
    @IBAction func testButton(_ sender: Any?) {
        if let a = WiFiHelper.internetMonitor?.isReachable {
            if a {
                print("online")
            } else {
                print("offline")
            }
        }
    }
    
    @IBAction func openSiteButtonPressed(_ sender: Any?) {
        connectToInternet()
    }
    
    @IBAction func connectButtonPressed(_ sender: NSButton) {
        switch sender.tag {
        case 0:
            let pasteBoard = NSPasteboard.general
            pasteBoard.clearContents()
            pasteBoard.setString("webauth.ritsumei.ac.jp", forType: .string)
        case 1:
            let (result, errString) = WiFiHelper.login(withId: userData.rainbowID, andPassword: userData.rainbowPassword)
            if result {
                internetStatus = true
            } else {
                if let errorMessage = errString {
                    print(errorMessage)
                }
            }
        case 2:
            let (result, errString) = WiFiHelper.logout()
            if result {
                internetStatus = false
            } else {
                if let errorMessage = errString {
                    print(errorMessage)
                }
            }
        default:
            print("nothing")
        }
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
    }
    
    func ritsWifiDidChange(forStatus status: Bool) {
        ritswifiStatus = status
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            if self.ritswifiStatus {
                if self.internetStatus {
                    self.statusLabel.stringValue = "Connected to Internet."
                    self.buttonType = .disconnect
                } else {
                    self.statusLabel.stringValue = "No Internet with Rits-Webauth."
                    self.buttonType = .connect
                }
            } else {
                self.statusLabel.stringValue = "Please connect to Rits-Webauth."
                self.buttonType = .viewPassword
            }
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
