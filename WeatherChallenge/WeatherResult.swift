//
//  WeatherResult.swift
//  MakeSchoolChallenge
//
//  Created by Nikita Pahadia on 31/03/2016.
//  Copyright © 2016 Nikita. All rights reserved.
//

import Foundation

class WeatherResult:NSObject
{
    var count:NSNumber?
    var resultDescription:String?
    var weather:Weather?
    var forecastArray:Array<Forecast>?
}