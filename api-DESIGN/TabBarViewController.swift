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

    let realmm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        if (realmm.objects(Balance).count == 0)
        {
            try! realmm.write() {
                let new_bal = Balance()
                new_bal.amount = 1000.0;
                self.realmm.add(new_bal)
            }
            self.navigationItem.title = "Balance: " + String(realmm.objects(Balance)[0].amount) + " PPS"

        }
        else
        {
            self.navigationItem.title = "Balance: " + String(realmm.objects(Balance)[0].amount) + " PPS"
            
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        self.navigationItem.title = "Balance: " + String(realmm.objects(Balance)[0].amount) + " PPS"
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
