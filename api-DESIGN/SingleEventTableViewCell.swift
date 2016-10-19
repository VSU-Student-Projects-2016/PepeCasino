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
    var _event = SingleEvent() {
        didSet {
            EventInfo.text = _event.completeTeamNames()
            EventTimeAndStatus.text = _event.timeAsString()
        }
        
        willSet {
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
