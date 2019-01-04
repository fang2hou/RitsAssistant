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
    private let WIFI_NAME = "Rits-Webauth"
    private let AUTH_URL = "https://webauth.ritsumei.ac.jp"
    
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
    
    
    func login(withId id: String, andPassword password: String) -> (Bool, String?) {
        let params: [String:String] = [
            "username": id,
            "password": password,
            "buttonClicked": "4",
            "redirect_url": "",
            "err_flag": "0"
        ]
        
        let logoutURL = AUTH_URL + "/login.html"
        
        var result = false
        var errString: String?
        
        Alamofire.request(logoutURL, method: .post, parameters: params, headers: headers).responseString {
            response in
            switch response.result {
            case .success(let data):
                if data.range(of: "Login Successful") != nil {
                    result = true
                } else if data.range(of: "statusCode=1") != nil {
                    errString = "You are already logged in. No further action is required on your part."
                } else if data.range(of: "statusCode=2") != nil {
                    errString = "You are not configured to authenticate against web portal. No further action is required on your part."
                } else if data.range(of: "statusCode=3") != nil {
                    errString = "The username specified cannot be used at this time. Perhaps the username is already logged into the system?"
                } else if data.range(of: "statusCode=4") != nil {
                    errString = "The User has been excluded. Please contact the administrator."
                } else if data.range(of: "statusCode=5") != nil {
                    errString = "Invalid User ID and password. Please try again."
                }
            case .failure(_):
                errString = "Network issue has occured."
            }
        }
        
        return (result, errString)
    }
    
    func logout() -> (Bool, String?) {
        let params: [String:String] = [
            "userStatus": "1",
            "err_msg": "",
            "err_flag": "0"
        ]
    
        let logoutURL = AUTH_URL + "/logout.html"
        
        var result = false
        var errString: String?
        
        Alamofire.request(logoutURL, method: .post, parameters: params, headers: headers).responseString {
            response in
            switch response.result {
            case .success(let data):
                if data.range(of: "To complete the log off process") != nil {
                    result =  true
                } else {
                    errString = "Unknown issue."
                }
            case .failure(_):
                errString = "Network issue has occured."
            }
        }
        
        return (result, errString)
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
