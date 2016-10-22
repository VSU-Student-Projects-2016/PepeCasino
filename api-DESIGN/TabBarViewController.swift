//
//  TabBarViewController.swift
//  api-DESIGN
//
//  Created by xcode on 22.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import UIKit
import RealmSwift

class TabBarViewController: UITabBarController {

    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        if (realm.objects(Balance).count != 0) {
            self.navigationItem.title = "Balance: " + String(realm.objects(Balance)[0].amount) + "$"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
