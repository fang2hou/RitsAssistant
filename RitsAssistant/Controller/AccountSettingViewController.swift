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
    func updateRainbowAccount(id: String, password: String)
}

class AccountSettingViewController: NSViewController {

    var delegate: AccountSettingDelegate?
    
    @IBOutlet weak var idText: NSTextField!
    @IBOutlet weak var passwordText: NSSecureTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func backButtonPressed(_ sender: NSButton) {
        if sender.tag == 1 {
            delegate?.updateRainbowAccount(id: idText.stringValue, password: passwordText.stringValue)
        }
        dismiss(self)
    }
}
