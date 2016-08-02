//
//  WeatherParser.swift
//  MakeSchoolChallenge
//
//  Created by Nikita Pahadia on 31/03/2016.
//  Copyright © 2016 Nikita. All rights reserved.
//

import Foundation

class WeatherParser: NSObject
{
    //MARK: ParseData
    
    func parseWithData(data:NSData, completionHandler:(result:WeatherResult?) -> Void)
    {
        let rootObject = serializeJSONWithData(data);
        
        let result = parse(rootObject);
        
        completionHandler(result: result);
    }
    
    //MARK: Serialization
    
    private func serializeJSONWithData(data:NSData) -> AnyObject?
    {
        //JSON Serialization
        do {
            return try NSJSONSerialization.JSONObjectWithData(data, options:.MutableContainers)
        } catch let jsonError {
            print(jsonError)
        }
        
        return nil
    }
    
    //MARK: Parsing
    
    private func parse(rootObject:AnyObject?) -> WeatherResult
    {
        let weather = Weather()
        let result = WeatherResult()
        
        if ((rootObject?.isKindOfClass(NSDictionary)) == true)
        {
            let dictionary = rootObject as! NSDictionary
            let queryDictionary = dictionary.objectForKey("query") as? NSDictionary
            
            result.count = queryDictionary?.objectForKey("count") as? NSNumber
            
            let resultsDictionary = queryDictionary?.objectForKey("results") as? NSDictionary
            
            if((resultsDictionary?.isKindOfClass(NSNull)) == false)
            {
                let channelDictionary = resultsDictionary?.objectForKey("channel") as? NSDictionary
                
                result.resultDescription = channelDictionary?.objectForKey("description") as? String
                
                let unitsDictionary = channelDictionary?.objectForKey("units") as? NSDictionary
                
                weather.units = parseUnits(unitsDictionary);
                
                
                let windDictionary = channelDictionary?.objectForKey("wind") as? NSDictionary
                weather.wind = parseWind(windDictionary)
                
                
                let imageDictionary = channelDictionary?.objectForKey("image") as? NSDictionary
                weather.imageURL = imageDictionary?.objectForKey("url") as? String
                
                
                let itemDictionary = channelDictionary?.objectForKey("item") as? NSDictionary
                
                weather.title = itemDictionary?.objectForKey("title") as? String
                
                weather.weatherDescription = itemDictionary?.objectForKey("description") as? String
                
                let conditionDictionary = itemDictionary?.objectForKey("condition") as? NSDictionary
                weather.condition = parseCondition(conditionDictionary)
                
                
                let forecastArray = itemDictionary?.objectForKey("forecast") as? Array<NSDictionary>
                result.forecastArray = parseForecasts(forecastArray)
                
            }
        }
        result.weather = weather
        
        return result
    }
    
    private func parseUnits(unitsDictionary:NSDictionary?) -> Units
    {
        let units = Units()
        units.distance = unitsDictionary?.objectForKey("distance") as? String
        units.pressure = unitsDictionary?.objectForKey("pressure") as? String
        units.speed = unitsDictionary?.objectForKey("speed") as? String
        units.temperature = unitsDictionary?.objectForKey("temperature") as? String
        
        return units
    }
    
    private func parseWind(windDictionary:NSDictionary?) -> Wind
    {
        let wind = Wind()
        
        wind.chill = windDictionary?.objectForKey("chill") as? String
        wind.direction = windDictionary?.objectForKey("direction") as? String
        wind.speed = windDictionary?.objectForKey("speed") as? String
        
        return wind
    }
    
    private func parseCondition(conditionDictionary:NSDictionary?) -> Condition
    {
        let condition = Condition()
        
        condition.code = conditionDictionary?.objectForKey("code") as? String
        condition.date = conditionDictionary?.objectForKey("date") as? String
        condition.temp = conditionDictionary?.objectForKey("temp") as? String
        condition.text = conditionDictionary?.objectForKey("text") as? String
        
        return condition
    }
    
    private func parseForecasts(forecasts:Array<NSDictionary>?) -> Array<Forecast>?
    {
        let parsedForecasts = NSMutableArray()
        if(forecasts == nil)
        {
            return nil
        }
        for forecastDictionary:NSDictionary in forecasts!
        {
            let forecast = Forecast()
            
            forecast.code = forecastDictionary.objectForKey("code") as? String
            forecast.date = forecastDictionary.objectForKey("date") as? String
            forecast.day = forecastDictionary.objectForKey("day") as? String
            forecast.high = forecastDictionary.objectForKey("high") as? String
            forecast.low = forecastDictionary.objectForKey("low") as? String
            forecast.text = forecastDictionary.objectForKey("text") as? String
            
            parsedForecasts.addObject(forecast)
        }
        
        return parsedForecasts as AnyObject as? Array<Forecast>;
    }
    
}

