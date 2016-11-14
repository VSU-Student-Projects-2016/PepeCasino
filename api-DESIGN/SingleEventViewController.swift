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
import RealmSwift
    
class SingleEventViewController: UIViewController, UITextFieldDelegate {

    
    let realm = try! Realm()

    
    @IBOutlet weak var evStatus: UILabel!
    @IBOutlet weak var evTeams: UILabel!
    @IBOutlet weak var evTime: UILabel!
    @IBOutlet weak var firstCoeff: UIButton!
    @IBOutlet weak var drawCoeff: UIButton!
    @IBOutlet weak var secondCoeff: UIButton!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var actind: UIActivityIndicatorView!
    @IBOutlet weak var errView: UIView!
    @IBOutlet weak var betDescr: UILabel!
    @IBOutlet weak var betAmount: UITextField!
    @IBOutlet weak var betTeam: UILabel!
    @IBOutlet weak var betEstWin: UILabel!
    @IBOutlet weak var betConfirm: UIButton!
    @IBOutlet weak var betErrorAmount: UILabel!
    @IBOutlet weak var betConfirmSureLabel: UILabel!
    @IBOutlet weak var betConfirmYes: UIButton!
    @IBOutlet weak var betConfirmCancel: UIButton!
    
    let button = UIButton(type: UIButtonType.custom)

    var coeff = Double()
    var _event = SingleEvent()
    
    
    
    override func viewDidLoad() {
        
        //self.addDoneButtonOnKeyboard()

        
        self.navigationItem.title = "Balance: " + String(realm.objects(Balance)[0].amount) + " PPS"
        let url = "https://api.pinnaclesports.com/v1/odds?sportid=29&leagueids=" + String(_event.league) + "&oddsFormat=DECIMAL"
        //let tmpstr = String(_event.timeAsString()[_event.timeAsString().index(_event.timeAsString().startIndex, offsetBy: 0)..<_event.timeAsString().index(_event.timeAsString().endIndex, offsetBy: -12)])
        //let datei = c.index(c.startIndex, offsetBy: 0)..<c.index(c.endIndex, offsetBy: -10)
        //let url = "https://api.football-data.org/v1/fixtures/?timeFrame=p1" + String(_event.league)//tmpstr!
        //let url = "https://api.pinnaclesports.com/v1/fixtures/settled?sportid=29&leagueids=" + String(_event.league)
        let headers: HTTPHeaders = ["Authorization":"Basic R0s5MDcyOTU6IWpvemVmMjAwMA=="]
        //let headers: HTTPHeaders = ["X-Auth-Token":"5d3db3e16bf84ae1b4a6db7ea11b38b5"]
        loadingView.isHidden = false
        actind.startAnimating()
        DispatchQueue.global().async {
           /* Alamofire.request(url,headers: headers).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    self.loadingView.isHidden = true
                    let json = JSON(value)
                    print(json)
                case .failure(let error):
                    self.errView.isHidden = false
                    self.loadingView.isHidden = true
                    print(error)
                }
            }*/
            Alamofire.request(url,headers: headers).validate().responseJSON { response in
                switch response.result {
                    
                case .success(let value):
                    self.loadingView.isHidden = true
                    let json = JSON(value)
                    var i: Int = 0, periods_num: Int = 0, curr_id: Int = 0
                    print(json)
                    while json["leagues"][0]["events"][i]["id"].intValue != 0 {
                        while curr_id < self._event.id.count && json["leagues"][0]["events"][i]["id"].intValue != self._event.id[curr_id] {
                            curr_id += 1
                        }
                        if curr_id < self._event.id.count && json["leagues"][0]["events"][i]["id"].intValue == self._event.id[curr_id] {
                            break
                        }
                        curr_id = 0
                        i += 1
                    }
                    if json["leagues"][0]["events"][i]["periods"][periods_num]["moneyline"] == nil {
                        periods_num = 1
                        if json["leagues"][0]["events"][i]["periods"][periods_num]["moneyline"] == nil {
                            self.errView.isHidden = false
                            self.loadingView.isHidden = true
                        }
                        else {
                            self._event.coeffs[0] = Double(json["leagues"][0]["events"][i]["periods"][periods_num]["moneyline"]["home"].stringValue)!
                            self._event.coeffs[1] = Double(json["leagues"][0]["events"][i]["periods"][periods_num]["moneyline"]["draw"].stringValue)!
                            self._event.coeffs[2] = Double(json["leagues"][0]["events"][i]["periods"][periods_num]["moneyline"]["away"].stringValue)!
                        }
                    }
                    else {
                        self._event.coeffs[0] = Double(json["leagues"][0]["events"][i]["periods"][periods_num]["moneyline"]["home"].stringValue)!
                        self._event.coeffs[1] = Double(json["leagues"][0]["events"][i]["periods"][periods_num]["moneyline"]["draw"].stringValue)!
                        self._event.coeffs[2] = Double(json["leagues"][0]["events"][i]["periods"][periods_num]["moneyline"]["away"].stringValue)!
                    }
                    self.firstCoeff.setTitle(String(self._event.coeffs[0]), for: UIControlState.normal)
                    self.drawCoeff.setTitle(String(self._event.coeffs[1]), for : UIControlState.normal)
                    self.secondCoeff.setTitle(String(self._event.coeffs[2]), for: UIControlState.normal)
                    self.reloadInputViews();
                    
                case .failure(let error):
                    self.errView.isHidden = false
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
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.betAmount.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x:0, y:0, width:320, height:50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Accept", style: UIBarButtonItemStyle.done, target: self, action: Selector("doneButtonAction"))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.betAmount.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
        self.betAmount.resignFirstResponder()
    }*/

    

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
    func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        betAmount.resignFirstResponder()
    }


    
    func HideButtons(isHid: Bool)
    {
        betTeam.isHidden = isHid
        betDescr.isHidden = isHid
        betAmount.isHidden = isHid
        betEstWin.isHidden = isHid
        betConfirm.isHidden = isHid
        
    }
    func HideConfirmationButtons(isHid: Bool)
    {
        betConfirmSureLabel.isHidden = isHid
        betConfirmYes.isHidden = isHid
        betConfirmCancel.isHidden = isHid
    }

    @IBAction func amountTextChanged(_ sender: AnyObject) {
        HideConfirmationButtons(isHid: true)
        if (betAmount.text! != "")
        {
            betEstWin.text! = "Your estimated win: " + String(Double(betAmount.text!)!*coeff)
        } else {
            betEstWin.text! = "Your estimate win: 0"
        }
    }

    @IBAction func placeBetAct(_ sender: AnyObject) {
        switch sender.tag {
        case 0:
            betTeam.text! = "On the " +  _event.homeTeamName
            coeff = _event.coeffs[0]
        case 1:
            betTeam.text! = "On draw"
            coeff = _event.coeffs[1]
        case 2:
            betTeam.text! = "On the " + _event.awayTeamName
            coeff = _event.coeffs[2]
        default:
            print("kuk")
        }
        if betAmount.text! == "" {
            betEstWin.text! = "Your estimate win: 0"
        } else {
            betEstWin.text! = "Your estimated win: " + String(Double(betAmount.text!)!*coeff)
        }
        HideButtons(isHid: false)

        
    }
    @IBAction func placeBetConfirm(_ sender: AnyObject) {
        if (realm.objects(Balance)[0].amount < Double(betAmount.text!)!) {
            betErrorAmount.isHidden = false
        } else {
            betConfirmSureLabel.text = "Are you sure to place this bet?"
            HideConfirmationButtons(isHid: false)
            betErrorAmount.isHidden = true
        }
    }
    
    @IBAction func placeBetConfirmAction(_ sender: AnyObject) {
        let amount = Double(betAmount.text!)!
        try! realm.write() {
            
            let newBet = SingleBet()
            newBet.homeTeamName = _event.homeTeamName
            newBet.awayTeamName = _event.awayTeamName
            newBet.time = _event.time
            newBet.status = 0
            newBet.amount = amount
            newBet.coefficient = coeff
            newBet.betTime = Date()
            self.realm.add(newBet)
            
            realm.objects(Balance)[0].amount -= amount
            self.navigationItem.title = "Balance: " + String(realm.objects(Balance)[0].amount) + " PPS"

            HideConfirmationButtons(isHid: true)
            let alert = UIAlertController(title: "Success", message: "Your bet is accepted!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", 	style: UIAlertActionStyle.default, handler:placeBetHandler))
            self.present(alert, animated:true, completion:nil)
            betAmount.text = "";
        }
    }
    @IBAction func placeBetCancelAction(_ sender: AnyObject) {
        HideConfirmationButtons(isHid: true)
    }
    
    func placeBetHandler(alert: UIAlertAction){
        //dismiss(animated: true, completion: nil)

        //print("You tapped: \(alert.title)")
        /*let amount = Double(betAmount.text!)!
        try! realm.write() { // 2
                
            let newBet = SingleBet()
            newBet.homeTeamName = _event.homeTeamName
            newBet.awayTeamName = _event.awayTeamName
            newBet.time = _event.time
            newBet.status = 0
            newBet.amount = amount
            newBet.coefficient = coeff
            newBet.betTime = Date()
            self.realm.add(newBet)
            
            HideConfirmationButtons(isHid: true)
            
            realm.objects(Balance)[0].amount -= amount
            self.navigationItem.title = "Balance: " + String(realm.objects(Balance)[0].amount) + " PPS"
        */
    }
    

}
