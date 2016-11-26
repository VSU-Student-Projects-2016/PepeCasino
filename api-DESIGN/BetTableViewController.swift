//
//  BetTableViewController.swift
//  api-DESIGN
//
//  Created by Admin on 12.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON

class BetTableViewController: UITableViewController {
    
    @IBOutlet var segmentedCont: UISegmentedControl!
    
    
    let realm = try! Realm()
    lazy var bets: Results<SingleBet> = { self.realm.objects(SingleBet) }()
    
    
    func loadDef()
    {
        let defaulTteamNames = ["Birds", "Mammals", "Flora", "Reptiles", "Arachnids" ]
        
        for tmName in defaulTteamNames { // 4
            let newBet = SingleBet()
            newBet.homeTeamName = tmName
            newBet.awayTeamName = tmName
            newBet.amount = 200
            newBet.status = 2
            self.realm.add(newBet)
        }
        let newBet = SingleBet()
        newBet.homeTeamName = "Cock"
        newBet.awayTeamName = "Cuck"
        newBet.amount = 500
        newBet.status = 2
        newBet.choice = 1
        newBet.coefficient = 2.0
        self.realm.add(newBet)
        
        
    }
    
    //var bets = [SingleBet]()
    func loadBets()
    {
        try! realm.write() {
            
            //realm.deleteAll()
            if bets.count == 0 {
                loadDef()
            }
            bets = realm.objects(SingleBet).sorted(byProperty: "status").sorted(byProperty: "time", ascending: false)
        }
        var i = 0
        //print(bets)
        while(i < 2)//self.bets.count && self.bets[i].status < 2)
        {
            updateStatus(_bet: self.bets[i])
            //print(self.bets[i].league)
            i += 1
        }
        
        //self.tableView.isHidden = true
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadBets()
        segmentedCont.selectedSegmentIndex = 2
        //if bets.status
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        
        loadBets()
    }
    @IBAction func segmentedContChanged(_ sender: AnyObject) {
        //segmentedCont.isHidden = true;
        if (segmentedCont.selectedSegmentIndex==0)
        {
            bets = realm.objects(SingleBet).filter("status < 2").sorted(byProperty: "time", ascending: false)
        }
        else if (segmentedCont.selectedSegmentIndex==1){
            bets = realm.objects(SingleBet).filter("status == 2").sorted(byProperty: "time", ascending: false)
        }
        else {
            bets = realm.objects(SingleBet).sorted(byProperty: "time", ascending: false)
        }
        self.tableView.reloadData()
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SingleBetCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BetTableViewCell
        //try! realm.write() {
        cell.fill(from: bets[indexPath.row])
        //}
        //cell.lbStatus.text = String(Bet.isWon)
        
        return cell
    }
    
    func updateStatus(_bet: SingleBet)
    {
        if (!_bet.isStarted()) {return}
        
        //let url = "https://api.pinnaclesports.com/v1/fixtures/settled?sportid=29&leagueids=" + String(_bet.league)
        //let headers: HTTPHeaders = ["Authorization":"Basic R0s5MDcyOTU6IWpvemVmMjAwMA=="]
        
        
        var result = ""
        alamoRequest(_bet : _bet) { (inner: () throws -> String) -> Void in
            do {
                result = try inner()
                
                if result != "" {
                    var ResArr = result.characters.split{$0 == " "}.map(String.init)
                    
                    try! _bet.realm?.write {
                        _bet.firstScore = Int(ResArr[0])!
                        _bet.secondScore = Int(ResArr[1])!
                    }
                }
                
            } catch let error {
                print(error)
            }
        }
        
        try! realm.write() {
            _bet.status = 1
            if (_bet.isEnded()) {_bet.status = 2}
        }
    }
    
    func alamoRequest(_bet : SingleBet, completion: @escaping (_ inner: () throws -> String) -> ())
    {
        
        var jsonValue : JSON?
        var jsonString : String = String()
        
        
        //Alamofire.request(.GET, URL, parameters: requestParameters).validate().responseJSON {
        
        let url = "https://api.pinnaclesports.com/v1/fixtures/settled?sportid=29&leagueids=" + String(_bet.league)
        let headers: HTTPHeaders = ["Authorization":"Basic R0s5MDcyOTU6IWpvemVmMjAwMA=="]
        
        Alamofire.request(url,headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                if let value = response.result.value {
                    jsonValue = JSON(value)
                    jsonString = jsonValue!["error"].stringValue
                    print("Value in implementation is: \(jsonString)")
                    let json = JSON(value)
                    var i: Int = 0, periods_num: Int = 0
                    print(json)
                    print(self)
                    while json["leagues"][0]["events"][i]["id"].intValue != 0 && json["leagues"][0]["events"][i]["id"].intValue != _bet.id{
                        i += 1
                    }
                    var firScore = 0
                    var secScore = 0
                    if json["leagues"][0]["events"][i]["id"].intValue != 0 {
                        firScore = json["leagues"][0]["events"][i]["id"][0]["team1Score"].intValue
                        secScore = json["leagues"][0]["events"][i]["id"][0]["team2Score"].intValue
                    }
                    var Res = String(firScore) + " " + String(secScore)
                    completion({return Res})
                }
            case .failure(let error):
                completion({ return String(describing: error) })
            }
        }
    }
    
    
    
}
