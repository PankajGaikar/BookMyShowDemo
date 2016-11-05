//
//  ViewController.swift
//  BookMyShowClone
//
//  Created by Pankaj Gaikar on 15/09/16.
//  Copyright © 2016 Tricks Machine. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadImageFrom(link:String, contentMode: UIViewContentMode) {
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var eventList:NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        activityIndicator.startAnimating()
        BookMyShowManager.sharedInstance.getMovieList(completionHandler: { (movies) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
                self.activityIndicator.isHidden = true
                self.tableView.isHidden = false
            }
            self.eventList = movies
            DispatchQueue.main.sync {
                self.tableView.reloadData()
            }
        });
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        NSLog("Memory warning received");
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "MovieListCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MoviePosterCell
        
        // Fetches the appropriate event for the data source layout.
        let eventDictionary:Events = self.eventList.object(at: indexPath.row) as! Events

        //Custom Attributes
        let movieNameAttribute = [NSFontAttributeName: UIFont.systemFont(ofSize: 18)]
        let languageAttribute = [NSFontAttributeName: UIFont.systemFont(ofSize: 12) ]
        let movieHeaderName = NSMutableAttributedString()
        
        movieHeaderName.append( NSAttributedString(string: eventDictionary.eventName, attributes: movieNameAttribute) )
        movieHeaderName.append( NSAttributedString(string: ", ", attributes: languageAttribute) )
        movieHeaderName.append( NSAttributedString(string: eventDictionary.langauges, attributes: languageAttribute) )
        
        cell.movieName.attributedText = movieHeaderName
        cell.movieGenre.text = eventDictionary.genres
        cell.posterImage.downloadImageFrom(link: eventDictionary.bannerUrl, contentMode: UIViewContentMode.scaleAspectFill )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailsViewController") as! EventDetailsViewController
        vc.eventDetails = self.eventList.object(at: indexPath.row) as! Events
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

