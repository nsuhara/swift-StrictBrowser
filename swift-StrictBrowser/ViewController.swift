//
//  ViewController.swift
//  swift-StrictBrowser
//
//  Created by nsuhara on 2018/11/19.
//  Copyright © 2018 nsuhara. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UITextFieldDelegate, WKNavigationDelegate {
    
    var objUserDefaults = UserDefaults.standard
    var lstAllowedUrls = [String]()
    
    @IBOutlet weak var objUiTextField: UITextField!
    @IBOutlet weak var objWkWebView: WKWebView!
    @IBOutlet weak var objUiActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var objBackButton: UIBarButtonItem!
    @IBOutlet weak var objForwardButton: UIBarButtonItem!
    @IBOutlet weak var objReloadButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Init Objects.
        self.objUiTextField.delegate = self
        self.objWkWebView.navigationDelegate = self
        self.objUiActivityIndicatorView.hidesWhenStopped = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Load list data.
        if self.objUserDefaults.object(forKey: "com.nsuhara.swift-StrictBrowser") != nil {
            self.lstAllowedUrls = self.objUserDefaults.stringArray(forKey: "com.nsuhara.swift-StrictBrowser")!
        }
        // Load default page.
        let strUrl = "https://www.google.co.jp/"
        // Default settings.
        self.loadUrl(strUrl: strUrl)
        self.addBorder()
        self.objBackButton.isEnabled = false
        self.objForwardButton.isEnabled = false
        self.objReloadButton.isEnabled = false
    }
    
    func addBorder() {
        let objTopBorder = CALayer()
        objTopBorder.frame = CGRect(
            x: 0.0,
            y: 0.0,
            width: self.objWkWebView.frame.size.width,
            height: 1.0)
        objTopBorder.backgroundColor = UIColor.lightGray.cgColor
        self.objWkWebView.layer.addSublayer(objTopBorder)
    }
    
    func loadUrl(strUrl: String) {
        if let objUrl = self.validateUrl(strUrl: strUrl) {
            if !isAllowedUrl(objUrl) {
                self.alertDeniedUrl(objUrl.absoluteString)
                return
            }
            let objUrlRquest = URLRequest(url: objUrl)
            self.objWkWebView.load(objUrlRquest)
        }
    }
    
    func validateUrl(strUrl: String) -> URL? {
        // Trim white spaces.
        let strTrimmedUrl = strUrl.trimmingCharacters(in: NSCharacterSet.whitespaces)
        // Validate URL.
        if URL(string: strTrimmedUrl) == nil {
            self.alert(message: "Invalid URL")
            return nil
        }
        // Append Http protocol if omitted.
        return URL(string: self.appendScheme(strTrimmedUrl))
    }
    
    func isAllowedUrl(_ objUrl: URL) -> Bool {
        for strPattern in self.lstAllowedUrls {
            guard let regex = try? NSRegularExpression(pattern: strPattern) else {
                return false
            }
            let matches = regex.matches(in: objUrl.absoluteString, range: NSRange(location: 0, length: objUrl.absoluteString.count))
            for match in matches {
                if match.range.length == objUrl.absoluteString.count {
                    return true
                }
            }
        }
        return false
    }
    
    func alertDeniedUrl(_ message: String) {
        let title = [
            "おにさん",
            "かっぱさん",
            "くまさん",
            "ライオンさん",
            "激おこママ"
        ]
        let random = Int(arc4random_uniform(UInt32(title.count)))
        self.alert(title: "\(title[random])がでるからやめとこね!", message: message)
    }
    
    func alert(title: String = "Error", message: String) {
        let objUiAlertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        let objUiDefaultAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil)
        objUiAlertController.addAction(objUiDefaultAction)
        self.present(objUiAlertController, animated: true, completion: nil)
    }
    
    func appendScheme(_ strUrl: String) -> String {
        if URL(string: strUrl)?.scheme == nil {
            return "http://" + strUrl
        }
        return strUrl
    }
    
    // Called when link is clicked on web site.
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let objUrl = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        if !isAllowedUrl(objUrl) {
            self.alertDeniedUrl(objUrl.absoluteString)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
    
    // Start loading URL.
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.objUiActivityIndicatorView.startAnimating()
    }
    
    // Finish loading URL.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let strUrl = self.objWkWebView.url?.absoluteString {
            self.objUiTextField.text = strUrl
        }
        self.objUiActivityIndicatorView.stopAnimating()
        self.objBackButton.isEnabled = self.objWkWebView.canGoBack
        self.objForwardButton.isEnabled = self.objWkWebView.canGoForward
        self.objReloadButton.isEnabled = true
    }
    
    // Set cursor selection on edit.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if objUiTextField != self.objUiTextField {
            return
        }
        objUiTextField.selectedTextRange = objUiTextField.textRange(from: objUiTextField.beginningOfDocument, to: objUiTextField.endOfDocument)
    }
    
    // Return processing of text field.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if objUiTextField != self.objUiTextField {
            return true
        }
        if let strUrl = objUiTextField.text {
            self.loadUrl(strUrl: strUrl)
            self.objUiTextField.resignFirstResponder()
        }
        return true
    }
    
    // Process when back is pressed.
    @IBAction func goBack(_ sender: Any) {
        self.objWkWebView.goBack()
    }
    
    // Process when forward is pressed.
    @IBAction func goForward(_ sender: Any) {
        self.objWkWebView.goForward()
    }
    
    // Process when reload is pressed.
    @IBAction func reload(_ sender: Any) {
        self.objWkWebView.reload()
    }
    
}
