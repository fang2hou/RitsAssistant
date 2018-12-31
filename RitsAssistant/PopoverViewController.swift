//
//  PopoverViewController.swift
//  RitsAssistant
//
//  Created by Zhou Fang on 2018/12/31.
//  Copyright © 2018 Zhou Fang. All rights reserved.
//

import Cocoa

class PopoverViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func quitAssistant(_ sender: Any?) {
        NSApplication.shared.terminate(sender)
    }
    
    @IBAction func openAccountSetting(_ sender: Any?) {
//        weak var view = AccountViewController.freshController()
        
        self.present(AccountViewController.freshController(), animator: NSViewAnimation.EffectName(rawValue: "slideLeft") as! NSViewControllerPresentationAnimator)
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
}
