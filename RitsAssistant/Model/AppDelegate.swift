//
//  AppDelegate.swift
//  RitsAssistant
//
//  Created by Zhou Fang on 2018/12/31.
//  Copyright © 2018 Zhou Fang. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let menuBarItem = MenuBarItem()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
    
    @objc func togglePopover(_ sender: Any?) {
        if menuBarItem.popover.isShown {
            menuBarItem.closePopover(sender: sender)
        } else {
            menuBarItem.showPopover(sender: sender)
        }
    }
}
