//
//  BetTableViewController.swift
//  api-DESIGN
//
//  Created by Admin on 12.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import UIKit
import RealmSwift

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
                newBet.status = 2;
                self.realm.add(newBet)
            }
    }

    //var bets = [SingleBet]()
    func loadBets()
    {
        try! realm.write() {

        if bets.count == 0 {
            loadDef()
        }
        bets = realm.objects(SingleBet).sorted(byProperty: "status").sorted(byProperty: "time", ascending: false)
            var i = 0
            while(i < bets.count && bets[i].status < 2)
            {
                bets[i].updateStatus()
                i += 1
            }
        }
    }
    
        override func viewDidLoad() {
        super.viewDidLoad()
        //loadBets()
        segmentedCont.selectedSegmentIndex = 2
        //if bets.status
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        loadBets()
    }
    @IBAction func segmentedContChanged(_ sender: AnyObject) {
        //segmentedCont.isHidden = true;
        if (segmentedCont.selectedSegmentIndex==0)
        {
            bets = realm.objects(SingleBet).filter("status == 0").sorted(byProperty: "time", ascending: false)
        }
        else if (segmentedCont.selectedSegmentIndex==1){
            bets = realm.objects(SingleBet).filter("status > 0").sorted(byProperty: "time", ascending: false)
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
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
