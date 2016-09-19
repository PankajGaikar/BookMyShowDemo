//
//  EventDetailsViewController.swift
//  BookMyShowClone
//
//  Created by Pankaj Gaikar on 18/09/16.
//  Copyright © 2016 Tricks Machine. All rights reserved.
//

import Foundation
import UIKit
import youtube_ios_player_helper

class EventDetailsViewController : UIViewController
{
    var eventDetails:NSDictionary = [:]
    
    @IBOutlet weak var youtubePlayer: YTPlayerView!
    @IBOutlet weak var genreTextView: UITextView!
    @IBOutlet weak var releaseData: UILabel!
    @IBOutlet weak var runTime: UILabel!
    @IBOutlet weak var director: UILabel!
    @IBOutlet weak var languageTextView: UITextView!
    @IBOutlet weak var castTextView: UITextView!
    @IBOutlet weak var synopsysTextView: UITextView!
    
    override func viewDidLoad() {
        let playbackURI = self.eventDetails.object(forKey: "TrailerURL") as! String
        
        let regexString = self.extractYoutubeIdFromLink(link: playbackURI)
        
        self.youtubePlayer.load(withVideoId: regexString!)
        
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
    
    func extractYoutubeIdFromLink(link: String) -> String? {
        
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        guard let regExp = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return nil
        }
        let nsLink = link as NSString
        let options = NSRegularExpression.MatchingOptions(rawValue: 0)
        let range = NSRange(location: 0,length: nsLink.length)
        let matches = regExp.matches(in: link as String, options:options, range:range)
        if let firstMatch = matches.first {
            print(firstMatch)
            
            return nsLink.substring(with: firstMatch.range)
        }
        return nil
    }
    
}
