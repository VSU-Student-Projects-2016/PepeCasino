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
            let new_bal = Balance()
            new_bal.amount = 1000.0;
            self.realm.add(new_bal)

            self.navigationItem.title = "Balance: " + String(self.realm.objects(Balance)[0].amount) + " PPS"
        }
        let alert = UIAlertController(title: "Success", message: "Your data has been reset to stock.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", 	style: UIAlertActionStyle.default, handler:nil))
        self.present(alert, animated:true, completion:nil)

    }
    
    @IBAction func btnResetBalance(_ sender: AnyObject) {
        try! realm.write() {
            realm.objects(Balance)[0].amount = 1000
            self.navigationItem.title = "Balance: " + String(self.realm.objects(Balance)[0].amount) + " PPS"
        }
        let alert = UIAlertController(title: "Success", message: "Your balance has updated to 1000PPS!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", 	style: UIAlertActionStyle.default, handler:nil))
        self.present(alert, animated:true, completion:nil)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        // Do any additional setup after loading the view.
    }
    
        func onboardingConfigurationItem(item: OnboardingContentViewItem, index: Int) {
        
        //item.titleLabel?.backgroundColor = .redColor()
        //item.descriptionLabel?.backgroundColor = .redColor()
        //item.imageView = UIImageView.init(image: #imageLiteral(resourceName: "pepe_logo"))
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


