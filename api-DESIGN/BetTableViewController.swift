//
//  BetTableViewController.swift
//  api-DESIGN
//
//  Created by Admin on 12.10.16.
//  Copyright © 2016 VSU. All rights reserved.
//

import UIKit

class BetTableViewController: UITableViewController {

    
    var bets = [SingleBet]()
    
    func loadDSampleEvents() {
        let bet1 = SingleBet(homeTeamName: "Real Madrid", awayTeamName: "Barselona", isWon: true, amount: 100, coefficient: 1.75)
        let bet2 = SingleBet(homeTeamName: "MiDERY", awayTeamName: "Egor", isWon: false, amount: 200, coefficient: 2.50)
        let bet3 = SingleBet(homeTeamName: "Bavaria", awayTeamName: "Liverpool", isWon: false, amount: 150, coefficient: 1.23)
        bets.append(bet1)
        bets.append(bet2)
        bets.append(bet3)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDSampleEvents()
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
        
        let Bet  = bets[indexPath.row]
        
        let str = Bet.completeTeamNames()
        cell.lbTeamNames.text = str
        cell.lbPlaced.text = cell.lbPlaced.text! + String(Bet.amount)
        if Bet.isWon {
            
            cell.lbStatus.textColor = UIColor.green
            cell.lbStatus.text = "WIN"
            cell.lbPaid.text = cell.lbPaid.text! + String(Bet.amount * Bet.coefficient)
            
        }
        else {
            cell.lbStatus.textColor = UIColor.red
            cell.lbStatus.text = "LOSE"
            cell.lbPaid.text = cell.lbPaid.text! +  "0"
        }
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
