//
//  ViewController.swift
//  Project4 - EasyBrowser
//
//  Created by Travis Brigman on 5/4/21.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView = WKWebView()
    var progressView = UIProgressView()
//    var websites = ["apple.com", "hackingwithswift.com"]
    var selectedSite: String?
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        let url = URL(string: "https://" + websites[0])!
        if let selectedSite = selectedSite {
            let url = URL(string: "https://" + selectedSite)!
            webView.load(URLRequest(url: url))
        }
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        let forward = UIBarButtonItem(barButtonSystemItem: .play, target: webView, action: #selector(webView.goForward))
        let backward = UIBarButtonItem(barButtonSystemItem: .rewind, target: webView, action: #selector(webView.goBack))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        toolbarItems = [progressButton, spacer,forward, backward, refresh]
        navigationController?.isToolbarHidden = false
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page???", message: nil, preferredStyle: .actionSheet)
//        for site in websites {
            ac.addAction(UIAlertAction(title: selectedSite, style: .default, handler: openPage))
//        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            if let selectedSite = selectedSite {
//            for website in websites {
                if host.contains(selectedSite) {
                    decisionHandler(.allow)
                    return
                }
//            }
            }
            let invalid = UIAlertController(title: "invalid site", message: "navigation to site isn't allowed", preferredStyle: .alert)
            invalid.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: .none))
            present(invalid, animated: true)
        }

        decisionHandler(.cancel)
    }
    
    
    func openPage(action: UIAlertAction) {
        guard let url = URL(string: "https://" + action.title!) else { return }
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
}

