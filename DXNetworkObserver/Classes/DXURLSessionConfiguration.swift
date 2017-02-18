//
//  DXURLSessionConfiguration.swift
//  Pods
//
//  Created by dhcdht on 2017/2/18.
//
//

import UIKit

internal class DXURLSessionConfiguration: NSObject {
    private(set) var isSwizzle : Bool
    
    internal class func `default`() -> DXURLSessionConfiguration {
        struct Static {
            static let instance = DXURLSessionConfiguration()
        }
        
        return Static.instance
    }
    
    override init() {
        self.isSwizzle = false
        super.init()
    }
    
    internal func load() {
        var cls = NSClassFromString("__NSCFURLSessionConfiguration")
        if cls == nil {
            cls = NSClassFromString("NSURLSessionConfiguration")
        }
        if let cls = cls {
            self.swizzle(selector: #selector(protocolClasses), fromClass: cls, toClass: type(of: self))
            
            self.isSwizzle = true
        }
    }
    
    internal func unload() {
        var cls = NSClassFromString("__NSCFURLSessionConfiguration")
        if cls == nil {
            cls = NSClassFromString("NSURLSessionConfiguration")
        }
        if let cls = cls {
            self.swizzle(selector: #selector(protocolClasses), fromClass: cls, toClass: type(of: self))
            
            self.isSwizzle = false
        }
    }
    
    dynamic func protocolClasses() -> NSArray {
        return [DXURLProtocol.self]
    }
    
    private func swizzle(selector: Selector, fromClass: AnyClass, toClass: AnyClass) {
        guard let originalMethod = class_getInstanceMethod(fromClass, selector)
            , let stubMethod = class_getInstanceMethod(toClass, selector) else {
            return
        }
        
        method_exchangeImplementations(originalMethod, stubMethod)
    }
}
