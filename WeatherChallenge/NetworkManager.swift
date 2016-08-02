//
//  NetworkManager.swift
//  WeatherChallenge
//
//  Created by Nikita Pahadia on 31/03/2016.
//  Copyright © 2016 Nikita. All rights reserved.
//

import Foundation

class NetworkManager: NSObject
{
    class func requestWeatherData(city: String, completion: (NSData?, NSError?)->Void) -> Void
    {
        let session = NSURLSession.sharedSession()
        
        //Using Yahoo Weather APIs
        let urlString = "https://query.yahooapis.com/v1/public/yql?q=select * from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"\(city)\")&format=json&env=store://datatables.org/alltableswithkeys"
        
        let url = NSURL(string: urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!);
        
        let dataTask = session.dataTaskWithURL(url!) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            completion(data, error)
        }
        
        dataTask.resume()
    }
}