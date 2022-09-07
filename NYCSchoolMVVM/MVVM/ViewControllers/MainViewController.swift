//
//  ViewController.swift
//  MVVM
//
//  Created by rasim rifat erken on 30.07.2022.
//

import UIKit
import UserNotifications

class MainViewController: UIViewController , UITableViewDelegate , UITableViewDataSource  {


    var sendData = "School"
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    
    var nycViewModel = NYCViewModel()
    var schoolList = [School]()
    var filtered = [School]()
    var satSchoolList = [SatSchool]()
    var satViewModel = SatViewModel()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupSearchController()
        
        nycViewModel.getALLData { [weak self] in
            self?.schoolList = self!.nycViewModel.schoolModel
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        satViewModel.getALLData2 { [weak self] in
            self?.satSchoolList = self!.satViewModel.satSchoolModel
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: ["text": self.sendData])
        }
        

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return self.filtered.count
        }
        
        return schoolList.count 
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var nycHighSchoolList: School?


        if isFiltering() {
            nycHighSchoolList = filtered[indexPath.row]
        } else {
            nycHighSchoolList = schoolList[indexPath.row]
        }

        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.lineBreakMode = .byWordWrapping
        cell.textLabel!.font = UIFont.systemFont(ofSize: 14.0)

        let schoolname = nycHighSchoolList?.school_name
        cell.textLabel?.text = schoolname
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: ["text": self.sendData])
        }
        
        
        
        return cell
    }
    
    
    func setupSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Schools"
        searchController.searchBar.tintColor = UIColor.white
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filtered = (schoolList.filter({( schools : School) -> Bool in
            return schools.school_name.lowercased().contains(searchText.lowercased())
        }))
        
        tableView.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        let board = UIStoryboard(name: "Main", bundle: nil)
        let detailsVC = board.instantiateViewController(withIdentifier: "ScoreSegue") as! DetailViewController
        
        var nycHighSchoolList: School
        
        if isFiltering() {
            nycHighSchoolList = filtered[indexPath.row]
        } else {
            nycHighSchoolList = self.schoolList[indexPath.row]
        }
        
        detailsVC.satScore = nycHighSchoolList
        
        
        for i in satSchoolList {
            if i.dbn == nycHighSchoolList.dbn {
                detailsVC.schoolScore = i
            }
        }
        
        detailsVC.modalPresentationStyle = .fullScreen
        present(detailsVC, animated: true)
        
    }
    
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


    

