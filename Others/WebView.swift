//
//  WebView.swift
//  test1
//
//  Created by kagarikoumei on 2022/3/23.
//

import Foundation
import SwiftUI
import UIKit
import WebKit


struct WebContentView : UIViewRepresentable {
    
    private var Controller = WebController()
    
    //实现协议里的makeUIView方法，用来初始化并返回一个WKWebView网页视图对象。
    func makeUIView(context: UIViewRepresentableContext<WebContentView>) -> WKWebView {
        return Controller.webView
    }
    
    //接着实现协议里的updatedUIView方法，用来设置网页视图需要加载的网址参数。
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebContentView>) {
        //初始化一个URLRequest对象，作为网页视图的网址。
        let request = URLRequest(url:URL(string: "https://apple.com")!)
        //通过load方法，使网页视图加载该网址对应的网页。
        uiView.load(request)
    }
}

class WebController: UIViewController, WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if(message.name == "WebViewCallback") {
            print("JavaScript is sending a message \(message.body)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            //当前ViewController销毁前将其移除，否则会造成内存泄漏
             webView.configuration.userContentController.removeScriptMessageHandler(forName: "WebViewCallback")
        }
    
    lazy var webView : WKWebView = {
        /// 自定义配置
        let perf = WKWebpagePreferences()
        perf.allowsContentJavaScript = true
        let conf = WKWebViewConfiguration()
        conf.userContentController = WKUserContentController()
        conf.defaultWebpagePreferences.allowsContentJavaScript = true
        //conf.preferences.javaScriptEnabled = true
        conf.selectionGranularity = WKSelectionGranularity.character
        conf.userContentController.add(self, name: "WebViewCallback")
        let web = WKWebView( frame: CGRect(x:0, y:64,width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.height),configuration:conf)
        /// 设置访问的URL
//        let url = NSURL(string: "http://www.jianshu.com/u/37fe1e005f6c")
//        /// 根据URL创建请求
//        let requst = NSURLRequest(url: url! as URL)
//        /// 设置代理
//        //        web.uiDelegate = self
//        web.navigationDelegate = self
//        /// WKWebView加载请求
//        web.load(requst as URLRequest)
        
        return web
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.progressView.frame = CGRect(x:0,y:64,width:self.view.frame.size.width,height:2)
        self.progressView.isHidden = false
        UIView.animate(withDuration: 1.0) {
            self.progressView.progress = 0.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = "https://www.jianshu.com/u/5ab7d4b14cbe"
        
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        view.addSubview(webView)
        webView.navigationDelegate = self
        let mapwayURL = URL(string: url)!
        let mapwayRequest = URLRequest(url: mapwayURL)
        webView.load(mapwayRequest)
        
        view.addSubview(self.progressView)
    }
    
    
    // 进度条
    lazy var progressView:UIProgressView = {
        let progress = UIProgressView()
        progress.progressTintColor = UIColor.orange
        progress.trackTintColor = .clear
        return progress
    }()
    
}

extension WebController:WKNavigationDelegate{
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        self.navigationItem.title = "加载中..."
        /// 获取网页的progress
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = Float(self.webView.estimatedProgress)
        }
    }
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
        
    }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        /// 获取网页title
        self.title = self.webView.title
        
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = 1.0
            self.progressView.isHidden = true
        }
    }
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = 0.0
            self.progressView.isHidden = true
        }
        /// 弹出提示框点击确定返回
        let alertView = UIAlertController.init(title: "提示", message: "加载失败", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title:"确定", style: .default) { okAction in
            _=self.navigationController?.popViewController(animated: true)
        }
        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)
        
    }
    
}
