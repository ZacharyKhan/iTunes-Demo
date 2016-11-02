//
//  MenuCellCollectionViewCell.swift
//  iTunes-Demo
//
//  Created by Zachary Khan on 11/2/16.
//  Copyright © 2016 ZacharyKhan. All rights reserved.
//

import UIKit

class MenuCellCollectionViewCell: UICollectionViewCell {
    
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.addSubview(nameLabel)
        self.addConstraintsWithFormat("H:|-[v0]|", views: nameLabel)
        self.addConstraintsWithFormat("V:|[v0]|", views: nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
