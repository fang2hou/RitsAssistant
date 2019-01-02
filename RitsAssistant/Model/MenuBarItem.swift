//
//  MenuBarItem.swift
//  RitsAssistant
//
//  Created by Zhou Fang on 2019/01/02.
//  Copyright © 2019 Zhou Fang. All rights reserved.
//

import Cocoa

class MenuBarItem {
    let statusItem: NSStatusItem
    let popover: NSPopover
    
    init() {
        statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
        
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
            button.action = #selector(AppDelegate.togglePopover(_:))
        }
        
        popover = NSPopover()
        popover.animates = true
        popover.contentViewController = MainPopoverViewCotroller.freshController()
    }
    
    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.maxY)
        }
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
    }
}
