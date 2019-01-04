//
//  RAWiFiHelper.swift
//  RitsAssistant
//
//  Created by Zhou Fang on 2019/01/04.
//  Copyright © 2019 Zhou Fang. All rights reserved.
//

import Foundation
import Alamofire

enum networkStatus {
    case ethernetOrWiFi
    case wwan
    case unreachable
    case unknown
}

enum fakeUserAgent: String {
    case Safari = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0.2 Safari/605.1.15"
    case Chrome = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"
}

protocol RitsAssistantWifiHelperDelegate {
    func connect()
}

class RitsAssistantWiFiHelper {
    
    private var headers: HTTPHeaders = ["User-Agent": fakeUserAgent.Safari.rawValue]
    private let internetMonitor = NetworkReachabilityManager(host: "8.8.8.8")
    private let ritsWebauthMonitor = NetworkReachabilityManager(host: "webauth.ritsumei.ac.jp")
    
    var delegate: RitsAssistantWifiHelperDelegate?
    
    var status: networkStatus {
        didSet {
            print("network changed to \(status)")
        }
    }
    
    var userAgent: fakeUserAgent = .Safari {
        didSet {
            print(userAgent.rawValue)
            headers.updateValue(userAgent.rawValue, forKey: "User-Agent")
        }
    }
    
    var hasConnectedToRitsWebauth: Bool
    
    init() {
        status = .unknown
        hasConnectedToRitsWebauth = false
        
        internetMonitor?.listener = { status in
            switch status {
            case .reachable(.ethernetOrWiFi):
                self.status = .ethernetOrWiFi
            case .reachable(.wwan):
                self.status = .wwan
            case .notReachable:
                self.status = .unreachable
            case .unknown:
                self.status = .unknown
            }
        }
        
        internetMonitor?.startListening()
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
    
}
