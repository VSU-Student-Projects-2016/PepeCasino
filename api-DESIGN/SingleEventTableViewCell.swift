//
//  SingleEventTableViewCell.swift
//  api-DESIGN
//
//  Created by xcode on 01.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import UIKit

class SingleEventTableViewCell: UITableViewCell {

    @IBOutlet var EventInfo: UILabel!
    @IBOutlet var EventTimeAndStatus: UILabel!
    var Event = SingleEvent()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
