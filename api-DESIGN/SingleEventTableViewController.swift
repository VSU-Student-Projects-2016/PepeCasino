import UIKit
import Alamofire
import SwiftyJSON

class SingleEventTableViewController: UITableViewController, UISearchResultsUpdating {

    

    var events = [SingleEvent]()
    var searchController: UISearchController!
    var flag = false
    var searchResultEvents = [SingleEvent]()
    
    
    
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    func loadFromWeb() {
        self.events.removeAll()
         let exception_words = [String](arrayLiteral: "Corners", "corners", "Home Teams", "Away Teams", "PEN", "Bookings")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: +0010)
        let curr_time = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: curr_time), minute = calendar.component(.minute, from: curr_time), day = calendar.component(.day, from: curr_time), month = calendar.component(.month, from: curr_time)
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
                            if home_name.contains(("Spartak Subotica")){
                                print(eventsJson)
                            }
                            let event_status = eventsJson["status"]
                            let event_id = Int(eventsJson["id"].stringValue)
                            var tmpstr = eventsJson["starts"].stringValue
                            let c = tmpstr.characters
                            let timei = c.index(c.startIndex, offsetBy: 11)..<c.index(c.endIndex, offsetBy: -4)
                            let datei = c.index(c.startIndex, offsetBy: 0)..<c.index(c.endIndex, offsetBy: -10)
                            let dstr = String(tmpstr[datei]), tstr = String(tmpstr[timei])
                            let time = dateFormatter.date(from: dstr! + " " + tstr!)
                            if (curr_time + 300) >= time!// && (time! + 300) >= curr_time
                            //let event_hour = calendar.component(.hour, from: time!), event_minute = calendar.component(.minute, from: time!), event_day = calendar.component(.day, from: time!), event_month = calendar.component(.month, from: time!)
                            //if month > event_month || day > event_day || (month == event_month && day == event_day && ((hour == event_hour && minute >= event_minute) || (hour > event_hour && minute >= event_minute)))
                            {
                                continue
                            }
                            else {
                                var index_of_event = 0
                                let events_filtered = self.events.filter({ $0.homeTeamName == home_name && $0.awayTeamName == away_name })
                                if events_filtered.count > 0 {
                                    index_of_event = self.events.index(where: { $0.homeTeamName == home_name && $0.awayTeamName == away_name })!
                                    self.events[index_of_event].id.append(event_id!)
                                    continue
                                }
                                if home_name.contains("Home Teams") || away_name.contains("Home Teams") || home_name.contains("PEN") || away_name.contains("PEN") || home_name.contains("Bookings") || away_name.contains("Bookings") || home_name.contains("Corners") || away_name.contains("Corners") || home_name.contains("(w)") || away_name.contains("(w)") {
                                    continue
                                }
                            let tmpevent = SingleEvent(homeTeamName: home_name, awayTeamName : away_name, time: time!, id: event_id!, league: lg, status: 0)
                            self.events += [tmpevent]
                            }
                    }
                }
                self.events.sort( by: { $0.time < $1.time })
                self.refreshControl?.endRefreshing()
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }		        
    }
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.isNavigationBarHidden = true

        let onboarding = PaperOnboarding(itemsCount: 3)
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
        for attribute: NSLayoutAttribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
        
        


        searchController = UISearchController(searchResultsController: nil)
        //tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Type the name of event..."
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor.darkGray
        
        
        
        //tableView.tableHeaderView?.isHidden = true
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Loading...")
        refreshControl?.addTarget(self, action: "RefreshData", for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl!)
        let userDefaults = UserDefaults.standard
        let wasLaunchedOnce = "WAS_LAUNCHED_ONCE"
        if !userDefaults.bool(forKey: wasLaunchedOnce) {
            userDefaults.set(true, forKey: wasLaunchedOnce)
        }
        RefreshData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        let rightButt = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: "SearchEvs")
        tabBarController?.navigationItem.rightBarButtonItem = rightButt
    }
    func SearchEvs(){//(sender: UIBarButtonItem) {
        
        if flag { tableView.tableHeaderView = nil
        }else{
            tableView.tableHeaderView = searchController.searchBar
        }
        
        flag = !flag

    }
    func RefreshData() {
        DispatchQueue.global().async {
            //sleep(5)
            self.loadFromWeb()
        }
        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResultEvents.count
        }
        return events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SingleEventCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SingleEventTableViewCell

        // willset
        cell._event = (searchController.isActive) ? searchResultEvents[indexPath.row] : events[indexPath.row]
        
        return cell
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        } else {
            return true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DestViewController: SingleEventViewController = segue.destination as! SingleEventViewController
        let path = self.tableView.indexPathForSelectedRow?.row
        let sendingEvent = (searchController.isActive) ? searchResultEvents[path!] : events[path!]

        
	
            //self.tableView.isHidden = true
            //self.loadingView.isHidden = false
        DestViewController._event = sendingEvent
        //DestViewController._event = sendingEvent//events[path!]
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
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(searchText: searchText)
            tableView.reloadData()
        }
    }
    func filterContent(searchText: String)
    {
        searchResultEvents = events.filter({(_ev : SingleEvent) -> Bool in
            let homeMatch = _ev.homeTeamName.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            let awayMatch = _ev.awayTeamName.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            
            return homeMatch != nil || awayMatch != nil
        })
    }
}
extension SingleEventTableViewController: PaperOnboardingDataSource {
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        let titleFont = UIFont(name: "Nunito-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
        let descriptionFont = UIFont(name: "OpenSans-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        return [
            ("pepe_logo", "Hotels", "All hotels and hostels are sorted by hospitality rating", "pepe_logo", UIColor(red:0.40, green:0.56, blue:0.71, alpha:1.00), UIColor.white, UIColor.white, titleFont,descriptionFont),
            ("pepe_logo", "Banks", "We carefully verify all banks before add them into the app", "pepe_logo", UIColor(red:0.40, green:0.69, blue:0.71, alpha:1.00), UIColor.white, UIColor.white, titleFont,descriptionFont),
            ("pepe_logo", "Stores", "All local stores are categorized for your convenience", "pepe_logo", UIColor(red:0.61, green:0.56, blue:0.74, alpha:1.00), UIColor.white, UIColor.white, titleFont,descriptionFont)
            ][index]
    }
    
    func onboardingItemsCount() -> Int {
        return 3
    }
}
