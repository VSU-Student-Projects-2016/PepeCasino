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
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var actind: UIActivityIndicatorView!
    
    var _event = SingleEvent()
    override func viewDidLoad() {
        let url = "https://api.pinnaclesports.com/v1/odds?sportid=29&leagueids=" + String(_event.league) + "&oddsFormat=DECIMAL"
        let headers: HTTPHeaders = ["Authorization":"Basic R0s5MDcyOTU6IWpvemVmMjAwMA=="]
        loadingView.isHidden = false
        actind.startAnimating()
        DispatchQueue.global().async {
            sleep(6)
            Alamofire.request(url,headers: headers).validate().responseJSON { response in
                switch response.result {
                    
                case .success(let value):
                    self.loadingView.isHidden = true
                    let json = JSON(value)
                    var i: Int = 0, periods_num: Int = 0
                    print(json)
                    while json["leagues"][0]["events"][i]["id"].intValue != self._event.id {
                        i += 1
                    }
                    if json["leagues"][0]["events"][i]["periods"][0]["moneyline"] == nil {
                        periods_num = 1
                    }
                    self._event.coeffs[0] = Double(json["leagues"][0]["events"][i]["periods"][periods_num]["moneyline"]["home"].stringValue)!
                    self._event.coeffs[1] = Double(json["leagues"][0]["events"][i]["periods"][periods_num]["moneyline"]["draw"].stringValue)!
                    self._event.coeffs[2] = Double(json["leagues"][0]["events"][i]["periods"][periods_num]["moneyline"]["away"].stringValue)!
                    self.firstCoeff.setTitle(String(self._event.coeffs[0]), for: UIControlState.normal)
                    self.drawCoeff.setTitle(String(self._event.coeffs[1]), for : UIControlState.normal)
                    self.secondCoeff.setTitle(String(self._event.coeffs[2]), for: UIControlState.normal)
                case .failure(let error):
                    self.loadingView.isHidden = true
                    print(error)
                }
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
