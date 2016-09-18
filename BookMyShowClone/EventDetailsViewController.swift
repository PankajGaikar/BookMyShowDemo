//
//  EventDetailsViewController.swift
//  BookMyShowClone
//
//  Created by Pankaj Gaikar on 18/09/16.
//  Copyright © 2016 Tricks Machine. All rights reserved.
//

import Foundation
import UIKit

class EventDetailsViewController : UIViewController
{
    var eventDetails:NSDictionary = [:]
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var genreTextView: UITextView!
    @IBOutlet weak var releaseData: UILabel!
    @IBOutlet weak var runTime: UILabel!
    @IBOutlet weak var director: UILabel!
    @IBOutlet weak var languageTextView: UITextView!
    @IBOutlet weak var castTextView: UITextView!
    @IBOutlet weak var synopsysTextView: UITextView!
    
    override func viewDidLoad() {
        
        self.loadYoutube(videoID: self.eventDetails.object(forKey: "TrailerURL") as! String)
        self.releaseData.text = self.eventDetails.object(forKey: "EventReleaseDate") as? String
        self.runTime.text = self.eventDetails.object(forKey: "Length") as? String
        self.director.text = self.eventDetails.object(forKey: "Director") as? String
        
        
        let actors = self.eventDetails.object(forKey: "Actors") as? String
        let actorsList = actors?.replacingOccurrences(of: ", ", with: "\n")
        
        let genres = self.eventDetails.object(forKey: "Genre") as? String
        let genresList = genres?.replacingOccurrences(of: ", ", with: "\n")
        
        
        self.languageTextView.text = self.eventDetails.object(forKey: "Language") as? String
        self.castTextView.text = actorsList
        self.synopsysTextView.text = self.eventDetails.object(forKey: "EventSynopsis") as? String
        self.genreTextView.text = genresList
        
    }
    
    func loadYoutube(videoID:String) {
        // create a custom youtubeURL with the video ID
        guard
            let youtubeURL = NSURL(string: videoID )
            else { return }
        // load your web request
        self.webView.loadRequest( NSURLRequest(url: youtubeURL as URL) as URLRequest )
    }
}
