//
//  MainPopoverViewController.swift
//  RitsAssistant
//
//  Created by Zhou Fang on 2019/01/02.
//  Copyright © 2019 Zhou Fang. All rights reserved.
//

import Cocoa
import CoreWLAN

class MainPopoverViewCotroller: NSViewController {
    
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
