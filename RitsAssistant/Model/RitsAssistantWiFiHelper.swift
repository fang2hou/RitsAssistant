//
//  RAWiFiHelper.swift
//  RitsAssistant
//
//  Created by Zhou Fang on 2019/01/04.
//  Copyright © 2019 Zhou Fang. All rights reserved.
//

import Foundation
import Alamofire
import CoreWLAN

enum fakeUserAgent: String {
    case Safari = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0.2 Safari/605.1.15"
    case Chrome = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"
}

protocol RitsAssistantWifiHelperDelegate {
    func internetDidChange(forStatus: Bool)
    func ritsWifiDidChange(forStatus: Bool)
}

class RitsAssistantWiFiHelper: CWEventDelegate {
    private let WIFI_NAME = "FzWiFi"//"Rits-Webauth"
    
    private var headers: HTTPHeaders = ["User-Agent": fakeUserAgent.Safari.rawValue]
    private let wifiClient = CWWiFiClient()
    private let internetMonitor = NetworkReachabilityManager(host: "8.8.8.8")
    
    var delegate: RitsAssistantWifiHelperDelegate?
    
    var internetAvailable: Bool {
        didSet {
            delegate?.internetDidChange(forStatus: internetAvailable)
        }
    }
    
    var hasConnectedToRitsWebauth: Bool {
        didSet {
            if hasConnectedToRitsWebauth {
                internetMonitor?.startListening()
            } else {
                internetMonitor?.stopListening()
                internetAvailable = false
            }
            
            delegate?.ritsWifiDidChange(forStatus: hasConnectedToRitsWebauth)
        }
    }
    
    var userAgent: fakeUserAgent = .Safari {
        didSet {
            print(userAgent.rawValue)
            headers.updateValue(userAgent.rawValue, forKey: "User-Agent")
        }
    }
    
    init() {
        internetAvailable = false
        hasConnectedToRitsWebauth = false

        // listener init
        internetMonitor?.listener = { status in
            switch status{
            case .reachable(.ethernetOrWiFi):
                self.internetAvailable = true
            default:
                self.internetAvailable = false
            }
        }
        
        // check wifi ssid
        if let wifiInterfaceNames = CWWiFiClient.interfaceNames() {
            // get names of all wifi interface
            for wifiInterfaceName in wifiInterfaceNames {
                ssidDidChangeForWiFiInterface(withName: wifiInterfaceName)
            }
        }
        
        // handle if ssid changed
        wifiClient.delegate = self
        
        // start to monitor if wifi ssid changed
        do {
            try wifiClient.startMonitoringEvent(with: .ssidDidChange)
            try wifiClient.startMonitoringEvent(with: .powerDidChange)
        } catch {
            print("Cannot monitor ssid change event: \(error)")
        }
    }
    
    func testMethod(withId id: String, andPassword password: String) {
        let testURL = "https://httpbin.org/post"
        
        let params: [String:String] = [
            "id": id,
            "password": password
        ]
        
        Alamofire.request(testURL, method: .post, parameters: params, headers: headers).responseString {
            response in
            switch response.result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print("Alamofire request failed. \n\(error)")
                
            }
        }
    }
    
    func ssidDidChangeForWiFiInterface(withName interfaceName: String) {
        
        if let wifiName = wifiClient.interface(withName: interfaceName)!.ssid() {
            if wifiName == WIFI_NAME {
                hasConnectedToRitsWebauth = true
            } else {
                hasConnectedToRitsWebauth = false
            }
        }
    }
    
    func powerStateDidChangeForWiFiInterface(withName interfaceName: String) {
        
        let wifiState = wifiClient.interface(withName: interfaceName)!.powerOn()
        if !wifiState {
            hasConnectedToRitsWebauth = false
        }
    }
    
}
