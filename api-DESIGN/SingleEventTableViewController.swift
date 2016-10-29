import UIKit
import Alamofire
import SwiftyJSON

class SingleEventTableViewController: UITableViewController {

    
    
    var events = [SingleEvent]()
    
    func loadFromWeb() {
        let dateFormatter = DateFormatter()
        var secondsFromGMT: Int { return NSTimeZone.local.secondsFromGMT() }
        let curr_time = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: curr_time), minute = calendar.component(.minute, from: curr_time), day = calendar.component(.day, from: curr_time), month = calendar.component(.month, from: curr_time)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let url = "https://api.pinnaclesports.com/v1/fixtures?sportid=29"
        let headers: HTTPHeaders = ["Authorization":"Basic R0s5MDcyOTU6IWpvemVmMjAwMA=="]
        Alamofire.request(url,headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for (_,leagueJson) in json["league"] {
                    let lg = leagueJson["id"].intValue
                    for (_,eventsJson) in leagueJson["events"] {
                            let home_name = eventsJson["home"].stringValue, away_name = eventsJson["away"].stringValue
                            let event_id = Int(eventsJson["id"].stringValue)
                            var tmpstr = eventsJson["starts"].stringValue
                            let c = tmpstr.characters
                            let timei = c.index(c.startIndex, offsetBy: 11)..<c.index(c.endIndex, offsetBy: -4)
                            let datei = c.index(c.startIndex, offsetBy: 0)..<c.index(c.endIndex, offsetBy: -10)
                            let dstr = String(tmpstr[datei]), tstr = String(tmpstr[timei])
                            let time = dateFormatter.date(from: dstr! + " " + tstr!)
                            let event_hour = calendar.component(.hour, from: time!), event_minute = calendar.component(.minute, from: time!), event_day = calendar.component(.day, from: time!), event_month = calendar.component(.month, from: time!)
                            if (minute >= event_minute && hour >= event_hour) || day > event_day || month > event_month || day == event_day + 1 || month == event_month + 1
                            {
                                continue
                            }
                            let events_filtered = self.events.filter({ $0.homeTeamName == home_name && $0.awayTeamName == away_name })
                            if home_name.contains("Corners") || away_name.contains("corners") || events_filtered.count > 0 {
                                continue
                            }
                            let tmpevent = SingleEvent(homeTeamName: home_name, awayTeamName : away_name, time: time!, id: event_id!, league: lg, status: 0)
                            self.events += [tmpevent]
                    }
                }
                self.events.sort( by: { $0.time < $1.time })
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }		        
    }
    func loadSampleEvents() {
        /*let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        var EventDate = dateFormatter.date(from: "2016-10-04 12:30")
        var coefficients : [Double] = [1.75, 1.26, 2.31]
        let Event1 = SingleEvent(homeTeamName: "Real Madrid", awayTeamName: "Manchester United", time: EventDate!, coeffs : coefficients)
        coefficients = [1.23, 1.39, 3.56 ]
        EventDate = dateFormatter.date(from: "2016-10-06 19:00")

        let Event2 = SingleEvent(homeTeamName: "Зенит", awayTeamName : "Амкар", time: EventDate!, coeffs : coefficients)
        
        events += [Event1, Event2]*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFromWeb()
        //loadSampleEvents()
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
        DestViewController._event = events[path!]
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
