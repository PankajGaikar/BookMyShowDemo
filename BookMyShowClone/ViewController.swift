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

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var eventList:NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BookMyShowManager.sharedInstance.getMovieList(completionHandler: { (movies) in
            print(movies.count);
            self.eventList = movies
            DispatchQueue.main.sync {
                self.tableView.reloadData()
            }
        });
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

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
        
        // Fetches the appropriate meal for the data source layout.
        let eventDictionary:NSDictionary = self.eventList.object(at: indexPath.row) as! NSDictionary

        //Custom Attributes
        
        let movieNameAttribute = [NSFontAttributeName: UIFont.systemFont(ofSize: 18)]
        let languageAttribute = [NSFontAttributeName: UIFont.systemFont(ofSize: 12) ]
        
        let movieHeaderName = NSMutableAttributedString()
        
        movieHeaderName.append( NSAttributedString(string: (eventDictionary.value(forKey: "EventTitle") as! String?)!, attributes: movieNameAttribute) )
        movieHeaderName.append( NSAttributedString(string: ", ", attributes: languageAttribute) )
        movieHeaderName.append( NSAttributedString(string: (eventDictionary.value(forKey: "Language") as! String?)!, attributes: languageAttribute) )
        
        cell.movieName.attributedText = movieHeaderName
        cell.movieGenre.text = eventDictionary.value(forKey: "Genre") as! String?
        
        cell.posterImage.downloadImageFrom(link: eventDictionary.value(forKey: "BannerURL") as! String, contentMode: UIViewContentMode.scaleAspectFill )
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailsViewController") as! EventDetailsViewController
        vc.eventDetails = self.eventList.object(at: indexPath.row) as! NSDictionary
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

