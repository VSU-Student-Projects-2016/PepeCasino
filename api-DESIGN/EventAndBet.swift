//
//  bet.swift
//  api-DESIGN
//
//  Created by xcode on 01.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation




class SingleEvent {
    
    init(homeTeamName: String, awayTeamName: String, time: Date, coeffs : [Double]) {
        self.homeTeamName = homeTeamName
        self.awayTeamName = awayTeamName
        self.coeffs = coeffs
        self.time = time
        
    }
    init() {    }
    
    
    
    
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
    
    func scoreAsString() -> String
    {
        return String(score[0]) + ":" + String(score[1])
    }
    
    var coeffs = [Double]() //Coefficients: [0] - on a first team, [1] - on draw, [2] - on a second team
    var score = Array(repeating: 0, count: 2)
    var time = Date() //Start time
    var id = 0 //Match ID
    var status = 0 //0 - not started , 1 - live), 2 - ended
}


class SingleBet : SingleEvent {
    
    var choice = 0 // 0 - first, 1 - draw, 2 - second
    var coefficient = 0
    var betTime = Date()
    var amount = 0
}
