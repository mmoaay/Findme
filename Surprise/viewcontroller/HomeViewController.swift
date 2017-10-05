//
//  HomeViewController.swift
//  Surprise
//
//  Created by zhengperry on 2017/9/24.
//  Copyright © 2017年 mmoaay. All rights reserved.
//

import UIKit

extension HomeViewController: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController) {
        searchedRoutes = self.routes.filter { (name, time) -> Bool in
            return name.contains(searchController.searchBar.text!)
        }
    }
}

extension HomeViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "from_home_to_search", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchedRoutes.count
        } else {
            return routes.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive {
            return "Searched Objects"
        } else {
            return "Stored Objects"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var item = (name: "", time: "")
        if searchController.isActive {
            item = searchedRoutes[indexPath.row];
        } else {
            item = routes[indexPath.row]
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCellIdentifier", for: indexPath)
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.time
        
        return cell
    }
}

class HomeViewController: UITableViewController {
    
    lazy var searchController = ({ () -> UISearchController in
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.searchBar.tintColor = UIColor.white
        controller.hidesNavigationBarDuringPresentation = false
        controller.dimsBackgroundDuringPresentation = false
        return controller
    })()
    
    lazy var routes: [(name: String, time: String)] = [("Camera", "Sony, Added at 2017.07.15"),("Mobile", "Apple, Added at 2017.07.15"),("Watch", "Apple, Added at 2017.07.15"),("Charge", "China, Added at 2017.07.15")]
    
    var searchedRoutes: [(name: String, time: String)] = [(name: String, time: String)](){
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = true
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

}
