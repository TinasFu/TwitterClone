//
//  TweetCell.swift
//  TwitterClone
//
//  Created by Shiquan Fu on 10/7/14.
//  Copyright (c) 2014 Tina Fu. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

   
    @IBOutlet weak var userImageView: UIImageView!

    
    @IBOutlet weak var textView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
