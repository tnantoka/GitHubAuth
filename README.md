# GitHubAuth

[![Version](https://img.shields.io/cocoapods/v/GitHubAuth.svg?style=flat)](http://cocoapods.org/pods/GitHubAuth)
[![License](https://img.shields.io/cocoapods/l/GitHubAuth.svg?style=flat)](http://cocoapods.org/pods/GitHubAuth)
[![Platform](https://img.shields.io/cocoapods/p/GitHubAuth.svg?style=flat)](http://cocoapods.org/pods/GitHubAuth)

## Usage

```swift
GitHubAuth.shared.configure(
    clientId: "CLINET_ID",
    clientSecret: "CLIENT_SECRET"
)

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
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

GitHubAuth is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "GitHubAuth"
```

## Author

tnantoka, tnantoka@bornneet.com

## License

GitHubAuth is available under the MIT license. See the LICENSE file for more info.
