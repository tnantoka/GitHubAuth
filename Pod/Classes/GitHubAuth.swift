//
//  GitHubAuth.swift
//  Pods
//
//  Created by Tatsuya Tobioka on 11/14/15.
//
//

import UIKit

public class GitHubAuth {
    private static let accessTokenKey = "accessTokenKey"

    public static let shared = GitHubAuth()
    
    private(set) var clientId = ""
    private(set) var clientSecret = ""
    private(set) var scopes = [String]()
    private(set) var callbackURL = NSURL(string: "https://example.com/")!
    private(set) var keychain = true
    
    private var _accessToken: String = ""
    public internal(set) var accessToken: String {
        get {
            if !keychain {
                return _accessToken
            }
            
            let query = [
                (kSecClass as String) : kSecClassGenericPassword,
                (kSecAttrAccount as String) : GitHubAuth.accessTokenKey,
                (kSecReturnData as String) : kCFBooleanTrue,
                (kSecMatchLimit as String) : kSecMatchLimitOne
            ]

            var result: AnyObject?
            let status = withUnsafeMutablePointer(&result) { SecItemCopyMatching(query, UnsafeMutablePointer($0)) }

            if status == errSecSuccess {
                guard let data = result as? NSData else { return "" }
                return String(data: data, encoding: NSUTF8StringEncoding) ?? ""
            }
            
            return ""
        }
        set {
            if !keychain {
                _accessToken = newValue
                return
            }

            guard let data = newValue.dataUsingEncoding(NSUTF8StringEncoding) else { return }

            let query = [
                (kSecClass as String) : kSecClassGenericPassword,
                (kSecAttrAccount as String) : GitHubAuth.accessTokenKey,
                (kSecValueData as String) : data
            ]
            
            SecItemDelete(query as CFDictionaryRef)
            SecItemAdd(query as CFDictionaryRef, nil)
        }
    }
    public var isSignedIn: Bool {
        return !accessToken.isEmpty
    }
    
    public func configure(clientId clientId: String, clientSecret: String, scopes: [String]? = nil, callbackURL: String? = nil, keychain: Bool? = nil) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        if let scopes = scopes {
            self.scopes = scopes
        }
        if let callbackURL = callbackURL {
            if let url = NSURL(string: callbackURL) {
                self.callbackURL = url
            }
        }
        if let keychain = keychain {
            self.keychain = keychain
        }
    }

    public func signIn(callback: NSError? -> Void) {
        guard let rootController = UIApplication.sharedApplication().keyWindow?.rootViewController else { return }
        
        guard let path = NSBundle(forClass: self.dynamicType).pathForResource("GitHubAuth", ofType: "bundle") else { return }
        guard let bundle = NSBundle(path: path) else { return }
        
        let storyboard: UIStoryboard = UIStoryboard(name: "SignInViewController", bundle: bundle)
        guard let navController = storyboard.instantiateInitialViewController() as? UINavigationController else { return }
        guard let signInController = navController.topViewController as? SignInViewController else { return }

        signInController.callback = { accessToken, error in
            rootController.dismissViewControllerAnimated(true, completion: nil)
            self.accessToken = accessToken
            callback(error)
        }
        
        rootController.presentViewController(navController, animated: true, completion: nil)
    }
    
    public func signOut() {
        let query = [
            (kSecClass as String): kSecClassGenericPassword
        ]
        SecItemDelete(query as CFDictionaryRef)
    }
    
    public func authorize(req: NSMutableURLRequest) {
        req.addValue("token \(accessToken)", forHTTPHeaderField: "Authorization")
    }
}
