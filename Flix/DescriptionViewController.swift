//
//  DescriptionViewController.swift
//  Flix
//
//  Created by Surbhi  Hajela on 10/2/20.
//  Copyright © 2020 Surbhi  Hajela. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {

    @IBOutlet weak var backDropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var movie: [String:Any]!
    var movieId : Int!
    var key: String!
    var moviesList = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = movie["title"] as? String
         titleLabel.sizeToFit()
         descriptionLabel.text = movie["overview"] as? String
         descriptionLabel.sizeToFit()
         
         let posterPath = movie["poster_path"] as! String
         let baseUrl = "https://image.tmdb.org/t/p/w185"
         let posterUrl = URL(string: baseUrl + posterPath)
         posterView.af_setImage(withURL: posterUrl!)
        
         
         let backDropPath = movie["backdrop_path"] as! String
         let baseUrlBackDrop = "https://image.tmdb.org/t/p/w780"
         let backDropUrl = URL(string: baseUrlBackDrop + backDropPath)
         backDropView.af_setImage(withURL: backDropUrl!)
         
          movieId = (self.movie["id"] as! Int)
         print("Movie id loaded \(movieId)")
         // Make request to fetch the data in json format
         let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId ?? 299536 )/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US")!
         print(url)
         let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
         let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
         let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                 print(error.localizedDescription)
             } else if let data = data {
                 let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                 
                 // Extract movies data
                 self.moviesList = dataDictionary["results"] as! [[String:Any]]
                 //reload table view
                 print(self.moviesList)
                 self.key = (self.moviesList[0]["key"] as! String)
                 
             }
         }
         task.resume()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

            let destination = segue.destination as! UINavigationController
            let vc = destination.topViewController as! TrailerViewController
            print("Sending Key: \(key)")
            vc.key = key
        }
}
