//
//  SingleEventViewController.swift
//  api-DESIGN
//
//  Created by Admin on 05.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import UIKit

class SingleEventViewController: UIViewController {

    
    @IBOutlet weak var evStatus: UILabel!
    @IBOutlet weak var evTeams: UILabel!
    @IBOutlet weak var evTime: UILabel!
    @IBOutlet weak var evScore: UILabel!

    var Event = SingleEvent()
    override func viewDidLoad() {
        if Event.status == 0 {
            evStatus.text = "Event hasn't started yet" }
        else
            if Event.status == 1 {
                evStatus.text = "LIVE!" }
            else {
                evStatus.text = "The event is over"}
        
        evTeams.text = Event.completeTeamNames()
        evTime.text = Event.timeAsString()
        evScore.text = Event.scoreAsString()
        
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
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
    @IBAction func cancel(_ sender: AnyObject) {
        //dismissViewControllerAnimated(true, completion: nil)
        dismiss(animated: true, completion: nil)
    }

}
