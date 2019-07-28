//
//  TableViewViewCellTableViewCell.swift
//  MemeMe
//
//  Created by Mahesh Chauhan on 27/7/19.
//  Copyright © 2019 Mahesh Chauhan. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    @IBOutlet weak var memeText: UILabel!
    @IBOutlet weak var memeImage: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
