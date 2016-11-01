//
//  ArtistTableViewCell.swift
//  iTunes-Demo
//
//  Created by Zachary Khan on 11/1/16.
//  Copyright © 2016 ZacharyKhan. All rights reserved.
//

import UIKit

class ArtistTableViewCell: UITableViewCell {
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "nameLabel"
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addSubview(nameLabel)
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
