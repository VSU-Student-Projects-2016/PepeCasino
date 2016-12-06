//
//  SettingsViewController.swift
//  api-DESIGN
//
//  Created by xcode on 15.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import UIKit
import RealmSwift

class SettingsViewController: UIViewController {

    let realm = try! Realm()

    
    @IBOutlet weak var btnResetAll: UIButton!
    
    
    @IBAction func btnResetAll(_ sender: AnyObject) {
        try! realm.write() {
            realm.deleteAll()
            self.navigationItem.title = "Balance: " + String(self.realm.objects(Balance)[0].amount) + " PPS"
        }
    }
    
    @IBAction func btnResetBalance(_ sender: AnyObject) {
        try! realm.write() {
            realm.objects(Balance)[0].amount = 1000
            self.navigationItem.title = "Balance: " + String(self.realm.objects(Balance)[0].amount) + " PPS"

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationItem.rightBarButtonItem = nil

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
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
