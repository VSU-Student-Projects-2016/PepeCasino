//
//  BetTableViewCell.swift
//  api-DESIGN
//
//  Created by Admin on 12.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import UIKit

class BetTableViewCell: UITableViewCell {

    @IBOutlet var lbTeamNames: UILabel!
    @IBOutlet var lbStatus: UILabel!
    @IBOutlet var lbPlaced: UILabel!
    @IBOutlet var lbPaid: UILabel!
    
    var _bet = SingleBet() {
        didSet {
            let str = _bet.completeTeamNames()
            lbTeamNames.text = str
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
