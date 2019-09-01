//
//  EntriesTableViewController.swift
//  Deviget_iOS-Test
//
//  Created by Augusto Collerone on 30/08/2019.
//  Copyright © 2019 Augusto Collerone. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    
    var entries: [EntryData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        //Get service data
        getData()
    }
    
    @objc func getData() {
        RedditService.requestData(success: { (entries) in
            self.entries = entries
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }) { (error) in
            self.refreshControl?.endRefreshing()
            print("Error")
        }
    }
    
    func setupUI() {
        self.title = "Reddit"
        
        //Table view
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .gray
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        
        //Refresh control
        let refreshControl = UIRefreshControl()
        self.refreshControl = refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(getData), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            entries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as? EntryTableViewCell else {
            return UITableViewCell()
        }
        cell.loadData(entry: entries[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}
