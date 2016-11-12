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
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM \nHH:mm"
            //dateFormatter.timeZone = TimeZone(secondsFromGMT: +0010)

        lbTime.text = dateFormatter.string(from: _bet.betTime)//stringFromTime(_time: _bet.betTime, format: "yyyy-MM-dd HH:mm")
        lbPlaced.text = "Placed: " + String(_bet.amount)
        if (_bet.status == 0)
        {
            self.backgroundColor = UIColor.white
            lbPaid.text = "Paid: ..."
        }
        else
        {
            if (_bet.isWon())
            {
                self.backgroundColor = UIColor.green.withAlphaComponent(0.15)
                lbPaid.text = "Paid: " + String(_bet.amount * _bet.coefficient)
            }
            else
            {
                self.backgroundColor = UIColor.red.withAlphaComponent(0.15)
                lbPaid.text = "Paid: 0"

            }
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
