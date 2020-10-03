//
//  MovieGridViewController.swift
//  Flix
//
//  Created by Surbhi  Hajela on 10/2/20.
//  Copyright © 2020 Surbhi  Hajela. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    var moviesList = [[String:Any]]()

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
           super.viewDidLoad()
           
           collectionView.delegate = self
           collectionView.dataSource = self
           
           let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
           layout.minimumLineSpacing = 4
           layout.minimumInteritemSpacing = 4
           
           let width = ( view.frame.size.width - layout.minimumInteritemSpacing * 1) / 2
           layout.itemSize = CGSize(width: width, height: width * 3/2)
          
           // Make request to fetch the data in json format
           let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
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
                   //reload collection view
                   self.collectionView.reloadData()
                   
               }
           }
           task.resume()
       }
       
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return moviesList.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"MovieGridCell",for: indexPath) as! MovieGridCell
           
           //fetch movie from
           let movie = moviesList[indexPath.item]
           print(movie)
           // Grab title, description and image url
           let posterPath = movie["poster_path"] as! String
           // Create Url for to grab image
           let baseUrl = "https://image.tmdb.org/t/p/w780"
           let posterUrl = URL(string: baseUrl + posterPath)
           // Set images
           cell.gridImage.af_setImage(withURL: posterUrl!)
           return cell;
           
       }
       

    
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           
           let cell = sender as! UICollectionViewCell
           let indexPath = collectionView.indexPath(for: cell)!
           let movie = moviesList[indexPath.item]
           
           let descViewController =  segue.destination as! DescriptionViewController
           descViewController.movie = movie

       }

}
