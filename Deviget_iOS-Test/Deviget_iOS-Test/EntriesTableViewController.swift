//
//  EntriesTableViewController.swift
//  Deviget_iOS-Test
//
//  Created by Augusto Collerone on 30/08/2019.
//  Copyright © 2019 Augusto Collerone. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    
    var entries: [EntryData] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        //Get service data
        getData()
    }
    
    func getData() {
        RedditService.requestData(success: { (entries) in
            self.entries = entries
        }) { (error) in
            print("Error")
        }
    }
    
    func setupUI() {
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .gray
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as? EntryTableViewCell else {
            return UITableViewCell()
        }
        cell.loadData(entry: entries[indexPath.row])
        return cell
    }
}
