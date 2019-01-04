//
//  AccountViewController.swift
//  RitsAssistant
//
//  Created by Zhou Fang on 2018/12/31.
//  Copyright © 2018 Zhou Fang. All rights reserved.
//

import Cocoa
import CoreData

protocol AccountSettingDelegate {
    func updateRainbowAccount(withId: String, andPassword: String)
}

class AccountSettingViewController: NSViewController {

    var delegate: AccountSettingDelegate?
    var savedRainbowID: String?
    var savedRainbowPassword: String?
    
    @IBOutlet weak var idText: NSTextField!
    @IBOutlet weak var passwordText: NSSecureTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if the default value has been initialized
        if let id = savedRainbowID {
            idText.stringValue = id
        }
        if let password = savedRainbowPassword {
            passwordText.stringValue = password
        }
    }
    
    @IBAction func backButtonPressed(_ sender: NSButton) {
        // tag = 0 -> quit without update
        // tag = 1 -> quit with update
        if sender.tag == 1 {
            delegate?.updateRainbowAccount(withId: idText.stringValue, andPassword: passwordText.stringValue)
        }
        dismiss(self)
    }
}
