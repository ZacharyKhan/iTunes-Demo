//
//  CollectionViewCells.swift
//  iTunes-Demo
//
//  Created by Zachary Khan on 11/1/16.
//  Copyright © 2016 ZacharyKhan. All rights reserved.
//

import UIKit

class Top40CollectionViewCell: UICollectionViewCell {
    
    var imageURL : String? {
        didSet {
            self.getImage(for: imageURL)
        }
    }
    
    private let artistLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()
    
    private let trackLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .white
        return label
    }()
    
    private let imageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var overlay : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.alpha = 0
        
        view.addSubview(self.artistLabel)
        view.addConstraintsWithFormat("H:|[v0]|", views: self.artistLabel)
        view.addConstraintsWithFormat("V:[v0(30)-|]", views: self.artistLabel)
        
        view.addSubview(self.trackLabel)
        view.addConstraintsWithFormat("H:|[v0]|", views: self.trackLabel)
        view.addConstraintsWithFormat("V:[v0(35)][v1]", views: self.trackLabel, self.artistLabel)
        
        return view
    }()
    
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
        
        self.addSubview(imageView)
        self.addConstraintsWithFormat("H:|[v0]|", views: imageView)
        self.addConstraintsWithFormat("V:|[v0]|", views: imageView)
        
        imageView.addSubview(overlay)
        imageView.addConstraintsWithFormat("H:|[v0]|", views: overlay)
        imageView.addConstraintsWithFormat("V:|[v0]|", views: overlay)
        
    }
    
    private func getImage(for string: String?) {
        let url = URL(string: string!)
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url!) {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }
        }

    }
}
