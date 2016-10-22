//
//  bet.swift
//  api-DESIGN
//
//  Created by xcode on 01.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation
import RealmSwift



class Balance : Object{
    dynamic var amount = 0.0
    init (amount: Double)
    {
        self.amount = amount
    }
    
    required init() {}
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        fatalError("init(realm:schema:) has not been implemented")
    }
}
class SingleEvent : Object {
    
    init(homeTeamName: String, awayTeamName: String, time: Date, id: Int, league: Int, status: Int) {
        self.homeTeamName = homeTeamName
        self.awayTeamName = awayTeamName
        self.id = id
        self.league = league
        self.status = status
        self.time = time
        
    }
    required init() {    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        fatalError("init(realm:schema:) has not been implemented")
    }
    
    
    
    
    var homeTeamName = ""
    var awayTeamName = ""
    
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
    
    
    
    dynamic var coeffs = [Double]() //Coefficients: [0] - on a first team, [1] - on draw, [2] - on a second team
    dynamic var score = Array(repeating: 0, count: 2)
    dynamic var time = Date() //Start time
    dynamic var id = 0 //Match ID
    dynamic var status = 0 //0 - not started , 1 - live), 2 - ended
    dynamic var league = 0
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


class SingleBet : SingleEvent {
    
    override init() {
        super.init()
    }
    
    init( homeTeamName: String, awayTeamName: String, isWon : Bool, amount : Double, coefficient : Double) {
        super.init()
        self.homeTeamName = homeTeamName
        self.awayTeamName = awayTeamName
        self.isWon = isWon
        self.amount = amount
        self.coefficient = coefficient
    }
    init( time: String,  homeTeamName: String, awayTeamName: String, isWon : Bool, amount : Double, coefficient : Double) {
        super.init()
        self.homeTeamName = homeTeamName
        self.awayTeamName = awayTeamName
        self.isWon = isWon
        self.amount = amount
        self.coefficient = coefficient
        self.time = timeFromString(_time: time)
    }
    dynamic var choice = 0 // 0 - first, 1 - draw, 2 - second
    dynamic var coefficient = 0.0
    dynamic var betTime = Date()
    dynamic var amount = 0.0
    dynamic var isWon = false //0 - lost, 1 - won
}
