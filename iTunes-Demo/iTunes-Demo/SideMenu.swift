//
//  SideMenu.swift
//  iTunes-Demo
//
//  Created by Zachary Khan on 11/1/16.
//  Copyright © 2016 ZacharyKhan. All rights reserved.
//

import UIKit

class SideMenu: UIView {
    
    var isShown : Bool?
    
    private var currentWindow : UIWindow?

    private lazy var collectionView : UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.isScrollEnabled = false
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .clear
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "menuCell")
        cv.contentInset.top = 64
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        currentWindow = UIApplication.shared.keyWindow
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        self.addSubview(collectionView)
        self.addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        self.addConstraintsWithFormat("V:|[v0]|", views: collectionView)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hide))
        collectionView.addGestureRecognizer(gesture)
    }
    
    func show() {
        currentWindow?.addSubview(self)
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin.x += self.bounds.width
        }) { (value) in
            self.isShown = true
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.25, animations: {
            self.frame.origin.x -= self.bounds.width
        }) { (val) in
            self.removeFromSuperview()
            self.isShown = false
        }
    }
}

extension SideMenu : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath)
        cell.backgroundColor = .orange
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.bounds.width, height: 50)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
}
