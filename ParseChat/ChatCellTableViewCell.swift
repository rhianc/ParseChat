//
//  ChatCellTableViewCell.swift
//  ParseChat
//
//  Created by Rhian Chavez on 6/26/17.
//  Copyright © 2017 Rhian Chavez. All rights reserved.
//

import UIKit

class ChatCellTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        label.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
