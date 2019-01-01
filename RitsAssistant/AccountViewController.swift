//
//  AccountViewController.swift
//  RitsAssistant
//
//  Created by Zhou Fang on 2018/12/31.
//  Copyright © 2018 Zhou Fang. All rights reserved.
//

import Cocoa

class AccountViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func backToMainPopover(_ sender: Any?) {
        // get AppDelegate of RitsAssistant
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        // change view controller
        appDelegate.menuBarPopover.contentViewController = PopoverViewController.freshController()
    }
}

extension AccountViewController {
    static func freshController() -> AccountViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("AccountViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? AccountViewController else {
            fatalError("Error: Cannot find Account View Controller.")
        }
        return viewcontroller
    }
}
