//
//  VideosViewController.swift
//  CFA
//
//  Created by Johnny Gu on 9/16/16.
//  Copyright © 2016 Johnny Gu. All rights reserved.
//

import UIKit

class VideosViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var resources: [Resource] = []
    
    var searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
//        searchController.searchBar.scopeButtonTitles = ["1","2"]
        searchController.searchBar.sizeToFit()
        searchController.searchBar.isTranslucent = false
        searchController.searchBar.backgroundColor = UIColor.red
        searchController.searchBar.placeholder = "Search Videos"
        searchController.searchBar.barTintColor = Config.mainBackgroundColor

        tableView.tableHeaderView = searchController.searchBar
        tableView.setNoneDataView(NoDataView(frame: tableView.bounds)) { [weak self] in
            self?.requestForData()
        }
        tableView.showNoneDataView()
        definesPresentationContext = true
        
        tableView.register(ScheduleHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: ScheduleHeaderView.Identifer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestForData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(view.alpha)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addAction(with sender: Any) {
        let vc = UIStoryboard(.Main).initiate(VideoDetailViewController.self)
        vc.mode = .create
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func requestForData() {
        showProgress()
        APIService.default.getAllResources { (result) in
            self.hideAllHUD()
            result.successCallback({ (resours) in
                self.resources = resours
                self.tableView.reloadData()
                if resours.count == 0 {
                    self.tableView.showNoneDataView()
                }
            }).failureCallback({ (error) in
                self.showToast(error.localizedDescription)
            })
        }
    }
}

extension VideosViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
//        let searchString = searchController.searchBar.text
//        [self searchForText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
    }
}

extension VideosViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return resources.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ScheduleHeaderView.Identifer) as? ScheduleHeaderView else {
            return ScheduleHeaderView()
        }
        header.textLabel?.text = "Tuesday, 01:00 China Time"
        header.contentView.backgroundColor = Config.scheduleSectionColor
        return header
    }
    
    // MARK: Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VideosCell.Identifier, for: indexPath) as? VideosCell else { return UITableViewCell() }
        cell.config(with: resources[indexPath.section])
//        cell.textLabel?.text = "Apple Design Awards"
//        cell.detailTextLabel?.text = "2016 - Session 104"
        //        cell.backgroundColor = Config.scheduleCellColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoDetailVC = UIStoryboard(.Main).initiate(VideoDetailViewController.self)
        videoDetailVC.mode = .read
        videoDetailVC.video = resources[indexPath.row]
        videoDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(videoDetailVC, animated: true)
    }
    
}

class VideosCell: UITableViewCell {
    
    static let Identifier = "VideosCellIdentifier"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.setImage(UIImage(named: "video_download"), for: .normal)
        
        accessoryView = button
    }
    
    func config(with resource: Resource) {
        textLabel?.text = resource.name
    }
}
