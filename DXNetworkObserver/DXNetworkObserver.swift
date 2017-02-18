//
//  DXNetworkObserver.swift
//  Pods
//
//  Created by dhcdht on 2017/2/17.
//
//

import UIKit

private let kUserDefaultDXNetworkObserverEnableKey = "com.dhcdht.ios.DXNetworkObserver.enable"

public let kDXNetworkObserverRequestCompleteNotification = Notification.Name(rawValue: "com.dhcdht.ios.DXNetworkObserver.requestCompleteNotification")

public class DXNetworkObserver: NSObject {
    public class func setEnable(enable: Bool) {
        UserDefaults.standard.set(true, forKey: kUserDefaultDXNetworkObserverEnableKey)
        
        if enable {
            URLProtocol.registerClass(DXURLProtocol.self)
            
            if !DXURLSessionConfiguration.default().isSwizzle {
                DXURLSessionConfiguration.default().load()
            }
        } else {
            URLProtocol.unregisterClass(DXURLProtocol.self)
            
            if DXURLSessionConfiguration.default().isSwizzle {
                DXURLSessionConfiguration.default().unload()
            }
        }
    }
    
    public class func isEnable() -> Bool {
        return UserDefaults.standard.bool(forKey: kUserDefaultDXNetworkObserverEnableKey)
    }
}
