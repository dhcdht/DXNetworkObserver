//
//  DXHTTPModel.swift
//  Pods
//
//  Created by dhcdht on 2017/2/18.
//
//

import UIKit

public class DXHTTPModel: NSObject {
    public var request: URLRequest
    public var response: HTTPURLResponse?
    public var error: Error?
    
    public var startDate: Date
    public var endDate: Date?
    
    init(request: URLRequest) {
        self.request = request
        self.startDate = Date()
    }
}
