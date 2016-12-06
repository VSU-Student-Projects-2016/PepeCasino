//
//  bet.swift
//  api-DESIGN
//
//  Created by xcode on 01.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import SwiftyJSON



class Balance : Object{
    dynamic var amount  = 0.0
    
    
}

//user defaults
//boarding ios cocoacontrols
//https://www.cocoacontrols.com/controls/abcintroview
class SingleEvent {
    
    init(homeTeamName: String, awayTeamName: String, time: Date, id: Int, league: Int, status: Int) {
        self.homeTeamName = homeTeamName
        self.awayTeamName = awayTeamName
        self.id.append(id)
        self.league = league
        self.status = status
        self.time = time
        
    }
    init() {    }
    
    
    var homeTeamName = ""
    var awayTeamName = ""
    
    
    dynamic var coeffs = Array(repeating: 0.0, count: 3) //Coefficients: [0] - on a first team, [1] - on draw, [2] - on a second team
    dynamic var score = Array(repeating: 0, count: 2)
    dynamic var id = Array<Int>()
    dynamic var time = Date() //Start time
    //var id = 0 //Match ID
    dynamic var status = 0 //0 - not started , 1 - live), 2 - ended
    dynamic var league = 0
    


func completeTeamNames() -> String
{
    return homeTeamName + " - " + awayTeamName
}

func timeAsString() -> String
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    return dateFormatter.string(from: time)
}

func timeAsString(format : String) -> String
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: time)
}


func scoreAsString() -> String
{
    return String(score[0]) + ":" + String(score[1])
}
}

func timeFromString(_time : String) -> Date
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    return dateFormatter.date(from: _time)!
}
func timeFromString(_time : String, format: String) -> Date
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.date(from: _time)!
}

func stringFromTime(_time : Date, format : String) -> String
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: _time)
}

func stringFromTime(_time : Date) -> String
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    return dateFormatter.string(from: _time)
}


/*class SingleBet {
    
    init() {
    //    super.init()
    }
    
    init( homeTeamName: String, awayTeamName: String, isWon : Bool, amount : Double, coefficient : Double) {
        //super.init()
        self.homeTeamName = homeTeamName
        self.awayTeamName = awayTeamName
        self.isWon = isWon
        self.amount = amount
        self.coefficient = coefficient
    }
    
    init( time: String,  homeTeamName: String, awayTeamName: String, isWon : Bool, amount : Double, coefficient : Double) {
      //  super.init()
        self.homeTeamName = homeTeamName
        self.awayTeamName = awayTeamName
        self.isWon = isWon
        self.amount = amount
        self.coefficient = coefficient
        self.time = timeFromString(_time: time)
    }
    
    
    func completeTeamNames() -> String
    {
        return homeTeamName + " - " + awayTeamName
    }
    
    func timeAsString() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: time)
    }
    
    func timeAsString(format : String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: time)
    }
    
    
    func scoreAsString() -> String
    {
        return String(score[0]) + ":" + String(score[1])
    }

    
    dynamic var homeTeamName = ""
    dynamic var awayTeamName = ""

    dynamic var score = Array(repeating: 0, count: 2)
    dynamic var time = Date() //Start time
    dynamic var id = 0 //Match ID
    dynamic var status = 0 //0 - not started , 1 - live), 2 - ended
    dynamic var league = 0

    dynamic var choice = 0 // 0 - first, 1 - draw, 2 - second
    dynamic var coefficient = 0.0
    dynamic var betTime = Date()
    dynamic var amount = 0.0
    dynamic var isWon = false //0 - lost, 1 - won
}*/
class SingleBet : Object {
    
    dynamic var homeTeamName = ""
    dynamic var awayTeamName = ""
    
    //dynamic var score = Array(repeating: 0, count: 2)
    dynamic var firstScore = 0
    dynamic var secondScore = 0
    dynamic var time = Date() //Start time
    dynamic var id = 0 //Match ID
    dynamic var status = 0 //0 - not started , 1 - live), 2 - ended
    dynamic var league = 0
    
    dynamic var choice = 0 // 0 - first, 1 - draw, 2 - second
    dynamic var coefficient = 0.0
    dynamic var betTime = Date()
    dynamic var amount = 0.0
    //dynamic var isWon = 0 //0 - lost, 1 - won
    //dynamic var isLoad = false
    func completeTeamNames() -> String
    {
        return homeTeamName + " - " + awayTeamName
    }
    
    func timeAsString() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: time)
    }
    
    func timeAsString(format : String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: time)
    }
    
    func updateStatus()
    {
        /*if (isEnded()) {
            self.status = 2
            return
        }*/
        //let waitGroup = DispatchGroup.init()

        //DispatchQueue.global().async() {
        if (!self.isStarted()) {return}
        
        var isLoad = false
        let url = "https://api.pinnaclesports.com/v1/fixtures/settled?sportid=29&leagueids=" + String(self.league)
        let headers: HTTPHeaders = ["Authorization":"Basic R0s5MDcyOTU6IWpvemVmMjAwMA=="]
        
    //    DispatchQueue.main.async {
        
        //waitGroup.enter()
        Alamofire.request(url,headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                isLoad = true
                let json = JSON(value)
                var i: Int = 0, periods_num: Int = 0
                print(json)
                print(self)
                while json["leagues"][0]["events"][i]["id"].intValue != 0 && json["leagues"][0]["events"][i]["id"].intValue != self.id{
                    i += 1
                }
                if json["leagues"][0]["events"][i]["id"].intValue != 0 {
                    self.firstScore = json["leagues"][0]["events"][i]["id"][0]["team1Score"].intValue
                    self.firstScore = json["leagues"][0]["events"][i]["id"][0]["team2Score"].intValue
                }
            case .failure(let error):
                isLoad = true
                print(error)
            }
        }
        //waitGroup.leave()
        //}
        
        //waitGroup.wait()
        DispatchQueue.main.async {
            self.status = 1
            if (self.isEnded()) {self.status = 2}

        }
    
    }
    
    func isWon() -> Bool
    {
        if (!isEnded()) {return false}
        switch choice{
        case 0:
            return firstScore > secondScore
        case 1:
            return firstScore == secondScore
        case 2:
            return firstScore < secondScore
        default:
            return false
        }
    }
    func isEnded() -> Bool
    {
        if (time + 6900 <= Date()) {
            return true
        }
        return false
    }
    
    func isStarted() -> Bool
    {
        if (time < Date()) {
            return true
        }
        return false
    }
    
    func scoreAsString() -> String
    {
        return String(firstScore) + " : " + String(secondScore)
    }
    
    
}
