//
//  CollectionViewCells.swift
//  iTunes-Demo
//
//  Created by Zachary Khan on 11/1/16.
//  Copyright © 2016 ZacharyKhan. All rights reserved.
//

import UIKit

class Top40CollectionViewCell: UICollectionViewCell {
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        self.backgroundColor = .white
        self.clipsToBounds = true
        
        self.layer.cornerRadius = 5.0
    }
    
}
