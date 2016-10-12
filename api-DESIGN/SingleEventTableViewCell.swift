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

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        EventInfo.text = Event.completeTeamNames()
        EventTimeAndStatus.text = Event.timeAsString()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
