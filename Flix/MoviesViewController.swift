//
//  MoviesViewController.swift
//  Flix
//
//  Created by Surbhi  Hajela on 9/25/20.
//  Copyright © 2020 Surbhi  Hajela. All rights reserved.
//

import UIKit
import AlamofireImage


class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var moviesList = [[String:Any]]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Make request to fetch the data in json format
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
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
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        moviesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        //fetch movie from
        let movie = moviesList[indexPath.row]
        
        // Grab and set title, description, and image url.
        let title = movie["title"] as! String
        cell.titleLabel!.text  = title
        
        let description = movie["overview"] as! String
        cell.descriptionLabel.text = description
        
        // Create Url for to grab image
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        // Set image
        cell.posterView.af_setImage(withURL: posterUrl!)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // get the new view controller using segue.destination
        
        // pass the selected objext to new view controller
        
        // find the selected movie
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = moviesList[indexPath.row]
        
        let descViewController =  segue.destination as! DescriptionViewController
        descViewController.movie = movie
        print("moving")
        tableView.deselectRow(at: indexPath, animated:true)
        
    }

}
