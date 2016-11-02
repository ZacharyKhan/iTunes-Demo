//
//  SideMenu.swift
//  iTunes-Demo
//
//  Created by Zachary Khan on 11/1/16.
//  Copyright © 2016 ZacharyKhan. All rights reserved.
//

import UIKit

class SideMenu: UIView {
    
    var delegate : SideMenuDelegate?
    let genreArray = ["All", "Electronic", "Country", "Hip-Hop/Rap", "Jazz", "Pop", "Rock", "Soul", "Reggae", "Dance", "Alternative"]
    var isShown : Bool? = false
    private var currentWindow : UIWindow?

    private lazy var collectionView : UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.isScrollEnabled = false
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .clear
        cv.register(MenuCellCollectionViewCell.self, forCellWithReuseIdentifier: "menuCell")
        cv.contentInset.top = 2
        cv.isOpaque = true
        return cv
    }()
    
    lazy var dimView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.alpha = 0
        view.isOpaque = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        return view
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
    }
    
    func show() {
        if self.isShown != true {
            self.isShown = true
            
            
            currentWindow?.addSubview(dimView)
            currentWindow?.addConstraintsWithFormat("H:|[v0]|", views: dimView)
            currentWindow?.addConstraintsWithFormat("V:|-64-[v0]|", views: dimView)
            
            dimView.addSubview(self)
            
            UIView.animate(withDuration: 0.2, animations: {
                self.dimView.alpha = 1.0
            }) { (value) in
                UIView.animate(withDuration: 0.25, animations: {
                    self.frame.origin.x += self.bounds.width
                }, completion: { (value) in
                    
                })
            }
        } else {
            self.hide()
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.2, animations: {
            self.frame.origin.x -= self.bounds.width
        }) { (val) in
            UIView.animate(withDuration: 0.25, animations: {
                self.dimView.alpha = 0
            }, completion: { (value) in
                self.isShown = false
                self.dimView.removeFromSuperview()
            })
        }
    }
}

extension SideMenu : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.genreArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuCellCollectionViewCell
        cell.nameLabel.text = self.genreArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.bounds.width, height: 50)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.delegate?.didSelectItem(at: indexPath.item, withTitle: self.genreArray[indexPath.item])
        
        hide()
    }
}

extension SideMenu : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if (touch.view == self.dimView) {
            return true
        }
        
        return false
    }
}
