//
//  SingleEventViewController.swift
//  api-DESIGN
//
//  Created by Admin on 05.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SingleEventViewController: UIViewController {

    
    @IBOutlet weak var evStatus: UILabel!
    @IBOutlet weak var evTeams: UILabel!
    @IBOutlet weak var evTime: UILabel!
    @IBOutlet weak var evScore: UILabel!
    @IBOutlet weak var firstCoeff: UIButton!
    @IBOutlet weak var drawCoeff: UIButton!
    @IBOutlet weak var secondCoeff: UIButton!

    var _event = SingleEvent()
    func GetOdds() {
        let url = "https://api.pinnaclesports.com/v1/fixtures?sportid=29&leagueIds=" + String(_event.league) + "&oddsFormat=DECIMAL"
        let headers: HTTPHeaders = ["Authorization":"Basic R0s5MDcyOTU6IWpvemVmMjAwMA=="]
        Alamofire.request(url,headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    override func viewDidLoad() {
        let url = "https://api.pinnaclesports.com/v1/odds?sportid=29&leagueIds=" + String(_event.league) + "&oddsFormat=DECIMAL"
        let headers: HTTPHeaders = ["Authorization":"Basic R0s5MDcyOTU6IWpvemVmMjAwMA=="]
        sleep(6)
        Alamofire.request(url,headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for (_,leagueJson) in json["league"] {
                    for (_,eventsJson) in leagueJson["events"] {
                        
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
        if _event.status == 0 {
            evStatus.text = "Event hasn't started yet" }
        else
            if _event.status == 1 {
                evStatus.text = "LIVE!" }
            else {
                evStatus.text = "The event is over"}
        
        evTeams.text = _event.completeTeamNames()
        evTime.text = _event.timeAsString()
        evScore.text = _event.scoreAsString()
        firstCoeff.setTitle(String(_event.coeffs[0]), for: UIControlState.normal)
        drawCoeff.setTitle(String(_event.coeffs[1]), for : UIControlState.normal)
        secondCoeff.setTitle(String(_event.coeffs[2]), for: UIControlState.normal)
        
        
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
