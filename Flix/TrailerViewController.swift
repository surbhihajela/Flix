//
//  TrailerViewController.swift
//  Flix
//
//  Created by Surbhi  Hajela on 10/2/20.
//  Copyright © 2020 Surbhi  Hajela. All rights reserved.
//

import UIKit
import WebKit

class TrailerViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var movieId: Int!
    var moviesList = [[String:Any]]()
    var key: String!
           
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print(key)
        let youtubeUrl = "https://www.youtube.com/watch?v=\(self.key ?? "6dSKUoV0SNI")"
        let urlStr = URL(string: youtubeUrl)
        let requestN = URLRequest(url: urlStr!)
        self.webView.load(requestN)
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
