//
//  TermsPolicyViewController.swift
//  ArtStation
//
//  Created by MamooN_ on 7/13/21.
//

import UIKit
import WebKit

class TermsPolicyViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        UIManager.showCustomActivityIndicator(controller: self, withMessage: nil)
        
       
        let url = URL(string: ApiEndpoint.termsAndConditionsUrl.removingPercentEncoding ?? "")
        let urlRequest = URLRequest(url: url!)
        webView.load(urlRequest)
        webView.navigationDelegate = self
            
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIManager.hideCustomActivityIndicator(controller: self)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        UIManager.hideCustomActivityIndicator(controller: self)
        self.showAlert(title: "Error", message: error.localizedDescription)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
