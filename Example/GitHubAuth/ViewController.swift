//
//  ViewController.swift
//  GitHubAuth
//
//  Created by tnantoka on 11/14/2015.
//  Copyright (c) 2015 tnantoka. All rights reserved.
//

import UIKit

import GitHubAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        GitHubAuth.shared.configure(
            clientId: "CLINET_ID",
            clientSecret: "CLIENT_SECRET"
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signIn(sender: AnyObject) {
        GitHubAuth.shared.signIn { error in
            print(error) // nil
            
            print(GitHubAuth.shared.accessToken) // Access Token
            print(GitHubAuth.shared.isSignedIn) // True
            
            let req = NSMutableURLRequest(URL: NSURL(string: "https://api.github.com/user")!)

            GitHubAuth.shared.authorize(req)
            print(req.allHTTPHeaderFields) // Authorization: token ACCESS_TOKEN
            
            if let data = try? NSURLConnection.sendSynchronousRequest(req, returningResponse: nil) {
                if let content = String(data: data, encoding: NSUTF8StringEncoding) {
                    print(content) // {"login":"tnantoka"...
                }
            }
            
            GitHubAuth.shared.signOut()
            print(GitHubAuth.shared.isSignedIn) // False
        }
    }
}

