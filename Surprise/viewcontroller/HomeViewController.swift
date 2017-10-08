//
//  HomeViewController.swift
//  Surprise
//
//  Created by zhengperry on 2017/9/24.
//  Copyright © 2017年 mmoaay. All rights reserved.
//

import UIKit
import SceneKit

extension HomeViewController: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController) {
        searchedRoutes =  RouteCacheService.shared.routes(prefix: searchController.searchBar.text!)
    }
}

extension HomeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if ("from_home_to_search" == segue.identifier) {
            if let destination = segue.destination as? SearchSceneViewController, let item = sender as? Route {
                destination.route = item
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item = Route()
        if searchController.isActive {
            item = searchedRoutes[indexPath.row];
        } else {
            item = routes[indexPath.row]
        }
        performSegue(withIdentifier: "from_home_to_search", sender: item)
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
            return "Searched surprises"
        } else {
            return "All the surprises"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var item = Route()
        if searchController.isActive {
            item = searchedRoutes[indexPath.row];
        } else {
            item = routes[indexPath.row]
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCellIdentifier", for: indexPath)
        cell.textLabel?.text = item.name
        
        let timeInterval:TimeInterval = TimeInterval(item.identity)
        let date = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        cell.detailTextLabel?.text = "Created at " + formatter.string(from: date)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var item = Route()
            if searchController.isActive {
                item = searchedRoutes[indexPath.row];
            } else {
                item = routes[indexPath.row]
            }
            RouteCacheService.shared.delRoute(route: item)
            self.routes = RouteCacheService.shared.allRoutes()
            self.tableView.reloadData()
        }
    }
}

class HomeViewController: UITableViewController {
    
    lazy var searchController = ({ () -> UISearchController in
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.searchBar.tintColor = UIColor.white
        controller.hidesNavigationBarDuringPresentation = false
        controller.dimsBackgroundDuringPresentation = false

        if let searchField = controller.searchBar.value(forKey: "_searchField") as? UITextField {
            searchField.tintColor = UIColor.white
            searchField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
        }
        return controller
    })()
    
    lazy var routes: [Route] = RouteCacheService.shared.allRoutes()
    
    var searchedRoutes: [Route] = [Route](){
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        routes = RouteCacheService.shared.allRoutes()
        self.tableView.reloadData()
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
