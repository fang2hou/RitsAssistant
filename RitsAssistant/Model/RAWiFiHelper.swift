//
//  RAWiFiHelper.swift
//  RitsAssistant
//
//  Created by Zhou Fang on 2019/01/04.
//  Copyright © 2019 Zhou Fang. All rights reserved.
//

import Foundation
import Alamofire

enum fakeUserAgent: String {
    case Safari = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0.2 Safari/605.1.15"
    case Chrome = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"
}

class RAWiFiHelper {
    var isNetworkAviable: Bool
    var hasConnectedToRitsWebauth: Bool
    
    let headers: HTTPHeaders = [
        "User-Agent": fakeUserAgent.Safari.rawValue
    ]
    
    init() {
        isNetworkAviable = false
        hasConnectedToRitsWebauth = false
        
    }
    
    func testMethod(withId id: String, andPassword password: String) {
        let testURL = "https://httpbin.org/get"
        
        let params: [String:String] = [
            "id": id,
            "password": password
        ]
        
        Alamofire.request(testURL, method: .get, parameters: params, headers: headers).responseString {
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
