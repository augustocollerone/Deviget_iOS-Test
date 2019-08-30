//
//  EntryTableViewCell.swift
//  Deviget_iOS-Test
//
//  Created by Augusto Collerone on 30/08/2019.
//  Copyright © 2019 Augusto Collerone. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    //Views outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var commentsLabel: UILabel!
    
    //Constraints outlets
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
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
        
        guard let entry = entry else {
            return
        }
        
        //Title label
        titleLabel.text = entry.title
        titleLabel.numberOfLines = 0

        //Stack views configuration
        topStackView.distribution = .fillEqually
        bottomStackView.distribution = .fillEqually
        
        //Author name label
        authorLabel.text = entry.authorName
        
        //Time delta label
        let entryTime = Double(entry.timeCreated)
        let cal = Calendar.current
        let d1 = Date()
        let d2 = Date(timeIntervalSince1970: entryTime)
        let components = cal.dateComponents([.hour], from: d2, to: d1)
        if let timeDelta = components.hour {
            timeLabel.text = "\(timeDelta) hours ago"
        }
        
        //Thumbnail image view
        if let entryURLString = entry.thumbnailURL, entryURLString != "default", let entryURL = URL(string: entryURLString) {
            //Get image
            RedditService.getData(from: entryURL) { (data, response, error) in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    let image = UIImage(data: data)
                    self.imageViewHeightConstraint.constant = CGFloat(entry.thumbnailHeight ?? 140)
                    self.thumbnailImageView.image = image
                }
            }
        } else {
            imageViewHeightConstraint.constant = 0
        }

        //Comments label
        let imageAttachment =  NSTextAttachment()
        imageAttachment.image = UIImage(named:"comment")
        let imageOffsetY:CGFloat = -5.0;
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        let  textAfterIcon = NSMutableAttributedString(string: " \(entry.commentsAmount)")
        completeText.append(textAfterIcon)
        commentsLabel.textAlignment = .center;
        commentsLabel.attributedText = completeText;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
