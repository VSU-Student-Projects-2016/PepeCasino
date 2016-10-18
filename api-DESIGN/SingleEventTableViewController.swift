import UIKit
import Alamofire
import SwiftyJSON

class SingleEventTableViewController: UITableViewController {

    
    
    var events = [SingleEvent]()
    
    func loadFromWeb() {
        let url = "https://api.pinnaclesports.com/v1/fixtures?sportid=29"
        let headers: HTTPHeaders = ["Authorization":"Basic R0s5MDcyOTU6IWpvemVmMjAwMA=="]
        /*Alamofire.request(url,headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                print(json[0])
            case .failure(let error):
                print(error)
            }
        }
        Alamofire.request(url,headers: headers).responseJSON { response in
            let json = JSON(response.result)
            debugPrint(json["last"])
        }*/
        
    }
    func loadSampleEvents() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        var EventDate = dateFormatter.date(from: "2016-10-04 12:30")
        var coefficients : [Double] = [1.75, 1.26, 2.31]
        let Event1 = SingleEvent(homeTeamName: "Real Madrid", awayTeamName: "Manchester United", time: EventDate!, coeffs : coefficients)
        coefficients = [1.23, 1.39, 3.56 ]
        EventDate = dateFormatter.date(from: "2016-10-06 19:00")

        let Event2 = SingleEvent(homeTeamName: "Зенит", awayTeamName : "Амкар", time: EventDate!, coeffs : coefficients)
        
        events += [Event1, Event2]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFromWeb()
        loadSampleEvents()
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
        return events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SingleEventCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SingleEventTableViewCell

        // willset
        cell._event  = events[indexPath.row]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DestViewController: SingleEventViewController = segue.destination as! SingleEventViewController
        let path = self.tableView.indexPathForSelectedRow?.row
        DestViewController.Event = events[path!]
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
