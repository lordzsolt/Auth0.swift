//
//  ViewController.swift
//  OAuth2
//
//  Created by Hernan Zalazar on 5/25/16.
//  Copyright © 2016 Auth0. All rights reserved.
//

import UIKit
import Auth0

class ViewController: UIViewController {

    var onAuth: (Result<Credentials> -> ())!

    @IBOutlet weak var oauth2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.onAuth = { [weak self] in
            switch $0 {
            case .Failure(let cause):
                let alert = UIAlertController(title: "Auth Failed!", message: "\(cause)", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self?.presentViewController(alert, animated: true, completion: nil)
            case .Success(let credentials):
                let alert = UIAlertController(title: "Auth Success!", message: "Authorized and got access_token \(credentials.accessToken)", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self?.presentViewController(alert, animated: true, completion: nil)
            }
            print($0)
        }
    }

    @IBAction func startOAuth2(sender: AnyObject) {
        var auth0 = Auth0.webAuth()
        auth0
            .logging(enabled: true)
            .start(onAuth)
    }

    @IBAction func startGoogleOAuth2(sender: AnyObject) {
        var auth0 = Auth0.webAuth()
        auth0
            .logging(enabled: true)
            .connection("google-oauth2")
            .start(onAuth)
    }
}