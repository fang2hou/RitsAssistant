//
//  userData.swift
//  RitsAssistant
//
//  Created by Zhou Fang on 2019/01/04.
//  Copyright © 2019 Zhou Fang. All rights reserved.
//

import Foundation

class UserData {
    var rainbowID: String
    var rainbowPassword: String
    
    init() {
        rainbowID = ""
        rainbowPassword = ""
        load()
    }
    
    func save() {
        // Save
        print(rainbowID)
        print(rainbowPassword)
    }
    
    func load() {
        // Load from database
    }
}
