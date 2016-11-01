//
//  ArtistTableViewCell.swift
//  iTunes-Demo
//
//  Created by Zachary Khan on 11/1/16.
//  Copyright © 2016 ZacharyKhan. All rights reserved.
//

import UIKit

class ArtistTableViewCell: UITableViewCell {
    
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var genreLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(nameLabel)
        self.addConstraintsWithFormat("H:|-[v0]|", views: nameLabel)
        self.addConstraintsWithFormat("V:|[v0]-25-|", views: nameLabel)
        
        self.addSubview(genreLabel)
        self.addConstraintsWithFormat("H:|-[v0]|", views: genreLabel)
        self.addConstraintsWithFormat("V:[v1][v0]-5-|", views: genreLabel, nameLabel)
        
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}

class TrackTableViewCell: UITableViewCell {
    
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var artistLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(nameLabel)
        self.addConstraintsWithFormat("H:|-[v0]|", views: nameLabel)
        self.addConstraintsWithFormat("V:|[v0]-25-|", views: nameLabel)
        
        self.addSubview(artistLabel)
        self.addConstraintsWithFormat("H:|-[v0]|", views: artistLabel)
        self.addConstraintsWithFormat("V:[v1][v0]-5-|", views: artistLabel, nameLabel)
        
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
