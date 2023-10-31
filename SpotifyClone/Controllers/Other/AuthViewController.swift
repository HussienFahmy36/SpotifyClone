//
//  AuthViewController.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 16/10/2023.
//

import UIKit
import WebKit
class AuthViewController: UIViewController, WKNavigationDelegate {

    private let webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let prefs = WKPreferences()
        prefs.javaScriptCanOpenWindowsAutomatically = true
        config.preferences = prefs
        let webView = WKWebView(frame: .zero,
                                configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    public var completion: ((Bool) -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign in"
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        webView.navigationDelegate = self
        
        guard let url = AuthManager.shared.signInURL else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url?.absoluteString else {
            return
        }
        guard let components = URLComponents(string: url),
              let code = components.queryItems?.first(where: { $0.name == "code" })?.value else {
            return
        }
        webView.isHidden = true

        AuthManager.shared.exchangeCodeForToken(code: code) {[weak self] success in
            guard let self else { return }
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                self.completion?(success)
                
            }
        }

        
    }
}
