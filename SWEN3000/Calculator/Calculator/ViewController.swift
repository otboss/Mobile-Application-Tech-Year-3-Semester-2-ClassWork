//
//  ViewController.swift
//  Calculator
//
//  Created by Administrator on 2019/4/23.
//  Copyright © 2019 sj. All rights reserved.
//

import UIKit;
import WebKit;



class ViewController: UIViewController, WKNavigationDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadHtmlFile();
    }
    
    @IBOutlet var webView: WKWebView!;
    
    
    override func loadView() {
        webView = WKWebView();
        webView.navigationDelegate = self;
        view = webView;
    }
    
    
    func loadHtmlFile() {
        let url = Bundle.main.url(forResource: "calculator", withExtension:"html")
        let request = NSURLRequest(url: url!)
        webView.load(request as URLRequest)
    }
    


}

