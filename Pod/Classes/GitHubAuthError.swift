//
//  GitHubAuthError.swift
//  Pods
//
//  Created by Tatsuya Tobioka on 11/15/15.
//
//

enum GitHubAuthError: Int {
    case Canceled, NoAccessToken
    
    var description: String {
        switch self {
        case Canceled:
            return "Sign in process was canceled by user."
        case NoAccessToken:
            return "Can't parse access token from response."
        }
    }
    
    var error: NSError {
        let info = [
            NSLocalizedDescriptionKey: description
        ]
        return NSError(domain: "com.tnantoka.GitHubAuth", code: rawValue, userInfo: info)
    }
}
