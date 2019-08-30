//
//  EntryTableViewCell.swift
//  Deviget_iOS-Test
//
//  Created by Augusto Collerone on 30/08/2019.
//  Copyright © 2019 Augusto Collerone. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    var entry: EntryData? {
        didSet {
            render()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func loadData(entry: EntryData) {
        self.entry = entry
    }
    
    func render() {
        textLabel?.text = entry?.authorName
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
