//
//  bet.swift
//  api-DESIGN
//
//  Created by xcode on 01.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation

class SingleOneBet {
    var coeff = 0.0
    var choice = 0
    let id = 0
    let time = NSDate()
}


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
    
    var coeffs = [Double]() //Коэффициенты на матч: [0] - на первую, [1] - на ничью, [2] - на вторую
    var score = Array(repeating: 0, count: 2)
    var time = Date() //Время проведения матча
    var id = 0 //ID матча
    var status = 0 //0 - , 1 - идет, 2 - закончился
}
