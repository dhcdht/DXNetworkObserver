//
//  DXURLProtocol.swift
//  Pods
//
//  Created by dhcdht on 2017/2/18.
//
//

import UIKit

private let kProtocolPropertyKey = "DXURLProtocol.kProtocolPropertyKey"

internal class DXURLProtocol: URLProtocol, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    private var startDate: Date?
    private var connection: NSURLConnection?
    private var httpModel: DXHTTPModel?
    private var response: URLResponse?
    
    override init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
        super.init(request: request, cachedResponse: cachedResponse, client: client)
    }
    
    // MARK: - URLProtocol
    
    override class func canInit(with request: URLRequest) -> Bool {
        if request.url?.scheme != "http"
        && request.url?.scheme != "https" {
            return false
        }
        
        // 已经生成过的请求不再重复
        if URLProtocol.property(forKey: kProtocolPropertyKey, in: request) != nil {
            return false
        }
        
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        guard let req = request as? NSMutableURLRequest else {
            return request
        }
        
        URLProtocol.setProperty(kProtocolPropertyKey, forKey: kProtocolPropertyKey, in: req)
        
        if let ret = req as? URLRequest {
            return ret
        } else {
            return request
        }
    }
    
    override func startLoading() {
        self.startDate = Date()
        
        self.connection = NSURLConnection(request: DXURLProtocol.canonicalRequest(for: self.request), delegate: self, startImmediately: true)
        
        self.httpModel = DXHTTPModel(request: self.request)
    }
    
    override func stopLoading() {
        self.connection?.cancel()
        
        if let httpURLResponse = self.response as? HTTPURLResponse {
            self.httpModel?.response = httpURLResponse
        }
        
        self.httpModel?.endDate = Date()
        NotificationCenter.default.post(name: kDXNetworkObserverRequestCompleteNotification, object: self.httpModel)
    }
    
    // MARK: - NSURLConnectionDelegate
    
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        self.httpModel?.error = error;
        
        self.client?.urlProtocol(self, didFailWithError: error)
    }
    
    func connectionShouldUseCredentialStorage(_ connection: NSURLConnection) -> Bool {
        return true
    }
    
    func connection(_ connection: NSURLConnection, willSendRequestFor challenge: URLAuthenticationChallenge) {
        challenge.sender?.performDefaultHandling?(for: challenge)
    }
    
    // MARK: - NSURLConnectionDataDelegate
    
    func connection(_ connection: NSURLConnection, willSend request: URLRequest, redirectResponse response: URLResponse?) -> URLRequest? {
        if let response = response {
            self.response = response
            
            self.client?.urlProtocol(self, wasRedirectedTo: request, redirectResponse: response)
        }
        
        return request
    }
    
    func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
        self.response = response
    }
    
    func connection(_ connection: NSURLConnection, didReceive data: Data) {
        self.client?.urlProtocol(self, didLoad: data)
    }
    
    func connection(_ connection: NSURLConnection, willCacheResponse cachedResponse: CachedURLResponse) -> CachedURLResponse? {
        return cachedResponse
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        self.client?.urlProtocolDidFinishLoading(self)
    }
}
