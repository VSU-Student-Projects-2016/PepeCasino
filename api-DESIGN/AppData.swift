//
//  AppData.swift
//  api-DESIGN
//
//  Created by xcode on 10.12.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import Foundation

public class AppData {
    public static let shared = AppData()
    
    public var balance: Int = 0 {
        didSet {
            // update realm
            // post notification
            NotificationCenter.default.post(<#T##notification: Notification##Notification#>)
        }
    }
    private init () {
        
    }
}
