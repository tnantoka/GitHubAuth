//
//  SignInViewController.swift
//  Pods
//
//  Created by Tatsuya Tobioka on 11/14/15.
//
//

import UIKit

class SignInViewController: UIViewController, UIWebViewDelegate {

    let tokenUrl = NSURL(string: "https://github.com/login/oauth/access_token")!

    var callback: (String, NSError?) -> Void = { accessToken in }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = NSLocalizedString("Sign in", comment: "")
        
        guard let webview = view as? UIWebView else { return }
        webview.delegate = self
        
        let params = "client_id=\(GitHubAuth.shared.clientId)&scope=\(GitHubAuth.shared.scopes.joinWithSeparator(","))"
        let urlString = "https://github.com/login/oauth/authorize?\(params)"
        guard let url = NSURL(string: urlString) else { return }

        let req = NSURLRequest(URL: url)
        webview.loadRequest(req)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Actions

    @IBAction func cancelItemDidTap(sender: AnyObject) {
        callback("", GitHubAuthError.Canceled.error)
    }
    
    // MARK: - UIWebViewDelegate
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        guard let url = request.URL where url.host == GitHubAuth.shared.callbackURL.host else { return true }
        guard let code = url.query?.componentsSeparatedByString("code=").last else { return true }

        let req = NSMutableURLRequest(URL: tokenUrl)
        req.HTTPMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        let params = [
            "client_id" : GitHubAuth.shared.clientId,
            "client_secret" : GitHubAuth.shared.clientSecret,
            "code" : code
        ]
        req.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(params, options: [])
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(req) { data, response, error in
            guard let data = data else { return self.callback("", error) }
            
            do {
                let content = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                if let accessToken = content["access_token"] as? String {
                    self.callback(accessToken, nil)
                } else {
                    self.callback("", GitHubAuthError.NoAccessToken.error)
                }
            } catch let error as NSError {
                self.callback("", error)
            }
        }
        task.resume()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        return false
    }
}
