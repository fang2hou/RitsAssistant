//
//  AccountViewController.swift
//  RitsAssistant
//
//  Created by Zhou Fang on 2018/12/31.
//  Copyright © 2018 Zhou Fang. All rights reserved.
//

import Cocoa
import CoreData

class AccountViewController: NSViewController {

    @IBOutlet weak var idText: NSTextField!
    @IBOutlet weak var passwordText: NSSecureTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func backToMainPopover(_ sender: Any?) {
        dismiss(self)
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
