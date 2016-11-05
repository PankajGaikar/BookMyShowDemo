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
//    var eventDetails:NSDictionary = [:]
    var eventDetails = Events.init();
    @IBOutlet weak var youtubePlayer: YTPlayerView!
    @IBOutlet weak var genreTextView: UITextView!
    @IBOutlet weak var releaseData: UILabel!
    @IBOutlet weak var runTime: UILabel!
    @IBOutlet weak var director: UILabel!
    @IBOutlet weak var languageTextView: UITextView!
    @IBOutlet weak var castTextView: UITextView!
    @IBOutlet weak var synopsysTextView: UITextView!
    
    override func viewDidLoad() {
        self.title = self.eventDetails.eventName;
        let playbackURI = self.eventDetails.playbackUri;
        let regexString = self.extractYoutubeIdFromLink(link: playbackURI)
        self.youtubePlayer.load(withVideoId: regexString!)
        
        self.releaseData.text = self.eventDetails.releaseDate;
        self.runTime.text = self.eventDetails.length
        self.director.text = self.eventDetails.director
        
        //Remove comas and add new line for good look on detail screen
        let actors = self.eventDetails.actors
        let actorsList = actors.replacingOccurrences(of: ", ", with: "\n")
        self.castTextView.text = actorsList
        
        let genres = self.eventDetails.genres
        let genresList = genres.replacingOccurrences(of: ", ", with: "\n")
        self.genreTextView.text = genresList
        
        self.languageTextView.text = self.eventDetails.langauges
        self.synopsysTextView.text = self.eventDetails.synopsys
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
