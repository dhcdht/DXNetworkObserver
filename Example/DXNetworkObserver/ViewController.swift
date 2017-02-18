//
//  ViewController.swift
//  DXNetworkObserver
//
//  Created by dhcdht on 02/17/2017.
//  Copyright (c) 2017 dhcdht. All rights reserved.
//

import UIKit
import DXNetworkObserver

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        DXNetworkObserver.setEnable(enable: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRequestComplete(notification:)), name: kDXNetworkObserverRequestCompleteNotification, object: nil)
        
        let webview = UIWebView(frame: self.view.bounds)
        self.view.addSubview(webview)
        
        if let url = URL(string: "https://www.baidu.com") {
            let urlRequest = URLRequest(url: url)
            webview.loadRequest(urlRequest)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleRequestComplete(notification: NSNotification) {
        print(notification)
    }
}

