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
        print(bets)
        while(i < self.bets.count && self.bets[i].status < 2)
        {
            //self.bets[i].updateStatus()
            updateStatus1(_bet: self.bets[i])
            //print(self.bets[i].league)
            i += 1
        }
        
        //self.tableView.isHidden = true
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedCont.selectedSegmentIndex = 2
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        
        loadBets()
        
        if (ifLoseAll())
        {
            let alert = UIAlertController(title: "Loser Warning", message: "You lose all the bets and all the funds from your wallet. Please, reset the data in 'Settings' menu!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Mkay", 	style: UIAlertActionStyle.default, handler:nil))
            self.present(alert, animated:true, completion:nil)
        }
    }
    func ifLoseAll() -> Bool {
        return bets[0].status==2 && self.realm.objects(Balance)[0].amount < 1
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
        /*if (isEnded()) {
         self.status = 2
         return
         }*/
        //let waitGroup = DispatchGroup.init()
        
        //DispatchQueue.global().async() {
        if (!_bet.isStarted()) {return}
        
        
        var isLoad = false
        let url = "https://api.pinnaclesports.com/v1/fixtures/settled?sportid=29&leagueids=" + String(_bet.league)
        let headers: HTTPHeaders = ["Authorization":"Basic R0s5MDcyOTU6IWpvemVmMjAwMA=="]
        
        //    DispatchQueue.main.async {
        
        //waitGroup.enter()
        Alamofire.request(url,headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                isLoad = true
                let json = JSON(value)
                var i: Int = 0, periods_num: Int = 0
                print(json)
                print(self)
                while json["leagues"][0]["events"][i]["id"].intValue != 0 && json["leagues"][0]["events"][i]["id"].intValue != _bet.id{
                    i += 1
                }
                if json["leagues"][0]["events"][i]["id"].intValue != 0 {
                    try! self.realm.write{
                        _bet.firstScore = json["leagues"][0]["events"][i]["id"][0]["team1Score"].intValue
                        _bet.firstScore = json["leagues"][0]["events"][i]["id"][0]["team2Score"].intValue
                    }
                }
            case .failure(let error):
                isLoad = true
                print(error)
            }
        }
        //waitGroup.leave()
        //}
        
        //waitGroup.wait()
        DispatchQueue.main.async {
            try! self.realm.write{
                _bet.status = 1
                
                if (_bet.isEnded()) {_bet.status = 2}
                self.tableView.reloadData()
            }
            
        }
        
    }

    func updateStatus1(_bet: SingleBet)
    {
        print(_bet)
        if (!_bet.isStarted()) {return}
        
        //let url = "https://api.pinnaclesports.com/v1/fixtures/settled?sportid=29&leagueids=" + String(_bet.league)
        //let headers: HTTPHeaders = ["Authorization":"Basic R0s5MDcyOTU6IWpvemVmMjAwMA=="]
        
        
        var result = ""
        alamoRequest(_bet : _bet)
        { (inner: () throws -> String) -> Void in
            do {
                result = try inner()
                
                if result != "" {
                    var ResArr = result.characters.split{$0 == " "}.map(String.init)
                    if (_bet.isEnded() && Int(ResArr[0]) != -1 && Int(ResArr[1]) != -1) {
                        try! _bet.realm?.write {
                            _bet.firstScore = Int(ResArr[0])!
                            _bet.secondScore = Int(ResArr[1])!
                            self.tableView.reloadData()
                            if _bet.isWon() {
                            self.realm.objects(Balance)[0].amount += _bet.amount * _bet.coefficient
                                self.navigationItem.title = "Balance: " + String(self.realm.objects(Balance)[0].amount) + " PPS"
                                self.tableView.reloadData()
                            }
                        }

                    }
                }
                
            } catch let error {
                print(error)
            }
        }
        
        try! realm.write() {
            _bet.status = 1
            if (_bet.isEnded())
            {
                _bet.status = 2
                //if _bet.isWon() {
                //    realm.objects(Balance)[0].amount += _bet.amount*_bet.coefficient
                //}
                
            }
        }
    }
    
    func alamoRequest(_bet : SingleBet, completion: @escaping (_ inner: () throws -> String) -> ())
    {
        print(_bet)
        let url = "https://api.pinnaclesports.com/v1/fixtures/settled?sportid=29&leagueids=" + String(_bet.league)
        let headers: HTTPHeaders = ["Authorization":"Basic R0s5MDcyOTU6IWpvemVmMjAwMA=="]
        
        Alamofire.request(url,headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                    let json = JSON(value)
                    var i: Int = 0, periods_num: Int = 0
                    print(json)
                    print(self)
                    while json["leagues"][0]["events"][i]["id"].intValue != 0 && json["leagues"][0]["events"][i]["id"].intValue != _bet.id{
                        i += 1
                    }
                    var firScore = -1
                    var secScore = -1
                    if json["leagues"][0]["events"][i]["id"].intValue != 0 {
                        print(json["leagues"][0]["events"][i]["periods"][0]["team1Score"].intValue)
                        print(json["leagues"][0]["events"][i]["periods"][0]["team2Score"].intValue)
                        firScore = json["leagues"][0]["events"][i]["periods"][0]["team1Score"].intValue
                        secScore = json["leagues"][0]["events"][i]["periods"][0]["team2Score"].intValue
                       // try! _bet.realm?.write {
                            //_bet.firstScore = json["leagues"][0]["events"][i]["id"][0]["team1Score"].intValue
                           // _bet.secondScore = json["leagues"][0]["events"][i]["id"][0]["team2Score"].intValue
                       // }
                    }

                    var Res = String(firScore) + " " + String(secScore)
                    completion({return Res})
            case .failure(let error):
                print(error)
                completion({ return String(describing: error) })
            }
        }
    }
    
    
    
}
