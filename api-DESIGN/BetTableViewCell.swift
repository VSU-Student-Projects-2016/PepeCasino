//
//  BetTableViewCell.swift
//  api-DESIGN
//
//  Created by Admin on 12.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import UIKit

class BetTableViewCell: UITableViewCell {

    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet var lbTeamNames: UILabel!
    @IBOutlet var lbPlaced: UILabel!
    @IBOutlet var lbPaid: UILabel!
    
    /*var _bet = SingleBet() {
        didSet {
            let str = _bet.completeTeamNames()
            lbTeamNames.text = str
            lbTime.text = stringFromTime(_time: _bet.time, format: "MM/dd")
            lbPlaced.text = lbPlaced.text! + String(_bet.amount)
            if _bet.isWon {
                
                lbStatus.textColor = UIColor.green
                lbStatus.text = "WIN"
                lbPaid.text = lbPaid.text! + String(_bet.amount * _bet.coefficient)
                
            }
            else {
                lbStatus.textColor = UIColor.red
                lbStatus.text = "LOSE"
                lbPaid.text = lbPaid.text! +  "0"
            }

        }
    }*/
    func fill(from _bet: SingleBet) {
        let str = _bet.completeTeamNames()
        lbTeamNames.text = str
        //_bet.updateStatus()
        /*if (_bet.status != 2)
        {
            let currTime = Date()
            if currTime > _bet.time
            {
                _bet.status = 1
            }
            if (_bet.isEnded()) {_bet.status = 2}
        }*/


        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM \nHH:mm"
            //dateFormatter.timeZone = TimeZone(secondsFromGMT: +0010)

        lbTime.text = dateFormatter.string(from: _bet.time)//stringFromTime(_time: _bet.betTime, format: "yyyy-MM-dd HH:mm")
        lbPlaced.text = "Placed: " + String(_bet.amount)
        switch _bet.status {
        case 0:
            self.backgroundColor = UIColor.white
            lbPaid.backgroundColor = UIColor.gray
            lbPaid.textColor = UIColor.white
            lbPaid.font = UIFont.systemFont(ofSize: 16.0)
            lbPaid.textAlignment = .center
            lbPaid.text = "Not started"
        case 1:
            self.backgroundColor = UIColor.cyan.withAlphaComponent(0.10)
            lbPaid.backgroundColor = UIColor.red
            lbPaid.textColor = UIColor.white
            lbPaid.font = UIFont.boldSystemFont(ofSize: 18.0)
            lbPaid.textAlignment = .center
            lbPaid.text = "LIVE!"

        case 2:
            if (_bet.isWon())
            {
                lbPaid.textColor = UIColor.black
                lbPaid.font = UIFont.systemFont(ofSize: 16.0)
                lbPaid.textAlignment = .left

                lbPaid.backgroundColor = UIColor.green.withAlphaComponent(0.25)
                self.backgroundColor = UIColor.green.withAlphaComponent(0.10)
                lbPaid.text = "Paid: " + String(_bet.amount * _bet.coefficient)
            } else {
                lbPaid.textColor = UIColor.black
                lbPaid.font = UIFont.systemFont(ofSize: 16.0)
                lbPaid.textAlignment = .left

                
                lbPaid.backgroundColor = UIColor.red.withAlphaComponent(0.25)
                self.backgroundColor = UIColor.red.withAlphaComponent(0.10)
                lbPaid.text = "Paid: 0"

            }
        default:
            print("kuk")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
