//
//  ViewController.swift
//  MakeSchoolChallenge
//
//  Created by Nikita Pahadia on 30/03/2016.
//  Copyright © 2016 Nikita. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate
{
    //The result from which we populate the UI
    var weatherResult = WeatherResult()
    
    //MARK: ViewLifeCycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Yahoo Weather!"
    }
    
    //MARK: MemoryManagement
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(self.weatherResult.forecastArray == nil)
        {
            return 0
        }
        return (self.weatherResult.forecastArray?.count)! + 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if (indexPath.row == 0)
        {
            //show weather right now
            
            let cell:WeatherHeaderCell = tableView.dequeueReusableCellWithIdentifier("TodayWeatherIdentifier", forIndexPath: indexPath) as! WeatherHeaderCell
            
            cell.descriptionLabel.text = self.weatherResult.weather?.condition?.text
            if let tempUnit = self.weatherResult.weather?.units?.temperature as String!
            {
                cell.temperatureLabel.text = (self.weatherResult.weather?.condition?.temp)! + tempUnit
            }
            if let windDirUnit = self.weatherResult.weather?.units?.distance as String!
            {
                cell.windDirectionLabel.text = (self.weatherResult.weather?.wind?.direction)! + windDirUnit
            }
            if let windSpeedUnit = self.weatherResult.weather?.units?.speed as String!
            {
                cell.windSpeedLabel.text = (self.weatherResult.weather?.wind?.speed)! + windSpeedUnit
            }
            
            return cell
            
        }
        
        //show weather forecast
        
        let cell:WeatherCell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier", forIndexPath: indexPath) as! WeatherCell
        
        let forecast = self.weatherResult.forecastArray![indexPath.row - 1]
        
        cell.dayLabel.text = forecast.day
        cell.dateLabel.text = forecast.date
        cell.descriptionLabel.text = forecast.text
        if let tempUnit = self.weatherResult.weather?.units?.temperature as String!
        {
            if let high = forecast.high as String! {
                cell.highLabel.text = "High: \(high) \(tempUnit)"
            }
            if let low = forecast.low as String! {
                cell.lowLabel.text = "Low: \(low) \(tempUnit)"
            }
        }
        
        return cell
    }
    
    //MARK: UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        
        self.title = searchBar.text
        
        //Request for the data
        NetworkManager.requestWeatherData(searchBar.text!) { data, error in
            if(error != nil)
            {
                //For the purpose of this exercise, we print all the errors. We should usually handle these errors by informing the user
                print(error)
            }
            else
            {
                let parser = WeatherParser()
                parser.parseWithData(data!, completionHandler:
                    {[unowned self] (result) -> Void in
                        if(result != nil)
                        {
                            self.weatherResult = result!
                            
                            dispatch_async(dispatch_get_main_queue(),{[unowned self] in
                                
                                self.title = self.weatherResult.weather?.title
                                self.tableView.reloadData()
                                
                                })
                        }
                        else
                        {
                            //For the purpose of this exercise, we print all the errors. We should usually handle these errors by informing the user
                            print("No Result")
                        }
                    })
            }
        }
    }
}

