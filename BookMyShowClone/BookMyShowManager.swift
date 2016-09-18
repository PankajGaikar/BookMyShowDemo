//
//  BookMyShowManager.swift
//  BookMyShowClone
//
//  Created by Pankaj Gaikar on 17/09/16.
//  Copyright © 2016 Tricks Machine. All rights reserved.
//

import Foundation
typealias CompletionHandler = (NSArray) -> Void

protocol Singleton: class {
    static var sharedInstance: Self { get }
}

class BookMyShowManager : NSObject
{

    // MARK: Singlton Object
    
    class var sharedInstance: BookMyShowManager {
        //2
        struct Singleton {
            //3
            static let instance = BookMyShowManager()
        }
        //4
        return Singleton.instance
    }

    
    // MARK: Fetch Records
    
    func getMovieList(completionHandler: @escaping CompletionHandler)    {
        var movies:NSArray = NSArray.init(array: []);
        
        let task = URLSession.shared.dataTask(with: URL.init(string: "http://data.in.bookmyshow.com/getData.aspx?cc=&cmd=GETEVENTLIST&dt=&et=MT&f=json&lg=72.842588&lt=19.114186&rc=MUMBAI&sr=&t=a54a7b3aba576256614a")!)
        { (data, response, error) in
            print(data)
            
            if (data != nil)
            {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as? NSDictionary
                    let bookMyShow = json?.object(forKey: "BookMyShow") as! NSDictionary
                    movies = bookMyShow.object(forKey: "arrEvent") as! NSArray
                    //                movies = arrEvent.object(forKey: "arrEvent") as! NSArray
                    print(movies)
                    completionHandler(movies)
                    
                } catch {
                    print(error)
                }
            }
        };
        task.resume()
    }
}
