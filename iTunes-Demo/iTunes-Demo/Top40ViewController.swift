//
//  Top40ViewController.swift
//  iTunes-Demo
//
//  Created by Zachary Khan on 11/1/16.
//  Copyright © 2016 ZacharyKhan. All rights reserved.
//

import UIKit
import AVFoundation

private let top40CellId = "Top40CellIdentifier"

class Top40ViewController: UIViewController {
    
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    var player : AVAudioPlayer? = nil
    var menu : SideMenu?
    var dataSource : [Track] = []
    
    lazy var collectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(TrackCollectionViewCell.self, forCellWithReuseIdentifier: top40CellId)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if self.player != nil {
            self.player?.stop()
        }
        
        if self.menu != nil, (self.menu?.isShown)! {
            self.menu?.hide()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        self.title = "Top 40 Songs"
        
        menu = SideMenu(frame: CGRect(x: -(self.view.bounds.width/2), y: 64, width: self.view.bounds.width/2, height: self.view.bounds.height-64))
        menu?.delegate = self
        
        self.view.addSubview(collectionView)
        self.view.addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        self.view.addConstraintsWithFormat("V:|[v0]|", views: collectionView)
        
        let button = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(self.buttonHandler))
        self.navigationItem.rightBarButtonItem = button
        loadTop40(indexGenre: nil)
    }
    
    func buttonHandler() {
        self.menu?.show()
    }

    func loadTop40(indexGenre: Int?) {
        if indexGenre == nil, let url : NSURL = NSURL(string: "https://itunes.apple.com/us/rss/topsongs/limit=40/explicit=true/json") {
            findData(with: url as URL)
        } else if indexGenre != nil {
            if indexGenre == 0 {
                if let url : NSURL = NSURL(string: "https://itunes.apple.com/us/rss/topsongs/limit=40/explicit=true/json") {
                    findData(with: url as URL)
                }
            } else if indexGenre == 1 {
                if let url : NSURL = NSURL(string: "https://itunes.apple.com/us/rss/topsongs/limit=40/genre=7/json") {
                    findData(with: url as URL)
                }
            } else if indexGenre == 2 {
                if let url : NSURL = NSURL(string: "https://itunes.apple.com/us/rss/topsongs/limit=40/genre=6/json") {
                    findData(with: url as URL)
                }
            } else if indexGenre == 3 {
                if let url : NSURL = NSURL(string: "https://itunes.apple.com/us/rss/topsongs/limit=40/genre=18/json") {
                    findData(with: url as URL)
                }
            } else if indexGenre == 4 {
                if let url : NSURL = NSURL(string: "https://itunes.apple.com/us/rss/topsongs/limit=40/genre=11/json") {
                    findData(with: url as URL)
                }
            } else if indexGenre == 5 {
                if let url : NSURL = NSURL(string: "https://itunes.apple.com/us/rss/topsongs/limit=40/genre=14/json") {
                    findData(with: url as URL)
                }
            } else if indexGenre == 6 {
                if let url : NSURL = NSURL(string: "https://itunes.apple.com/us/rss/topsongs/limit=40/genre=21/json") {
                    findData(with: url as URL)
                }
            } else if indexGenre == 7 {
                if let url : NSURL = NSURL(string: "https://itunes.apple.com/us/rss/topsongs/limit=40/genre=15/json") {
                    findData(with: url as URL)
                }
            } else if indexGenre == 8 {
                if let url : NSURL = NSURL(string: "https://itunes.apple.com/us/rss/topsongs/limit=40/genre=24/json") {
                    findData(with: url as URL)
                }
            } else if indexGenre == 9 {
                if let url : NSURL = NSURL(string: "https://itunes.apple.com/us/rss/topsongs/limit=40/genre=17/json") {
                    findData(with: url as URL)
                }
            } else {
                if let url : NSURL = NSURL(string: "https://itunes.apple.com/us/rss/topsongs/limit=40/genre=20/json") {
                    findData(with: url as URL)
                }
            }
        }
    }
    
    func findData(with URL: URL?) {
        
        if dataTask != nil {
            dataTask?.cancel()
        }
        
        dataTask = defaultSession.dataTask(with: URL!, completionHandler: {
            (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else if (response as? HTTPURLResponse) != nil {
                self.updateSearchResults(data: data!)
            }
        })
        // 8
        dataTask?.resume()
    }
    
    func updateSearchResults(data: Data?) {
        
        self.dataSource.removeAll()
        
        do {
            if let data = data, let response = try JSONSerialization.jsonObject(with: data as Data, options:JSONSerialization.ReadingOptions(rawValue:0)) as? [String: AnyObject] {
                
                // Get the results array
                if let object: AnyObject = response["feed"] {
                    if let entry : [AnyObject] = object["entry"] as? [AnyObject] {
                        for dictionary in entry {
                            
                            if let name = dictionary["im:name"] as? NSDictionary, let artist = dictionary["im:artist"] as? NSDictionary, let preview = dictionary["link"] as? NSArray, let imageURLArray = dictionary["im:image"] as? NSArray, let category = dictionary["category"] as? NSDictionary {
                                
                                if let attributes = (preview.lastObject! as? NSDictionary)?["attributes"] as? NSDictionary, let url = (imageURLArray.lastObject! as? NSDictionary)?["label"] as? String, let nameLabel = name["label"] as? String, let artistLabel = artist["label"] as? String, let genreAttributes = category["attributes"] as? NSDictionary {
                                    
                                    if let previewURL = attributes["href"] as? String, let genreLabel = genreAttributes["label"] as? String {
                                        
                                        if let track : Track = Track(name: nameLabel, artist: artistLabel, genre: genreLabel, time: nil, previewUrl: previewURL, imageURL: url) {
                                            
                                            self.dataSource.append(track)
                                        }
                                    }
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                } else {
                    print("Results key not found in dictionary")
                }
            } else {
                print("JSON Error")
            }
        } catch let error as NSError {
            print("Error parsing results: \(error.localizedDescription)")
        }
    }


}

extension Top40ViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: top40CellId, for: indexPath) as! TrackCollectionViewCell
        cell.imageURL = self.dataSource[indexPath.item].imageURL
        cell.trackLabel.text = self.dataSource[indexPath.item].name
        cell.artistLabel.text = self.dataSource[indexPath.item].artist
        cell.previewURL = self.dataSource[indexPath.item].previewUrl
        cell.rankLabel.text = "#\(indexPath.item+1)"
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: (collectionView.bounds.width/2)-3, height: (collectionView.bounds.height/3))
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? TrackCollectionViewCell {
            
            if self.player != nil {
                self.player?.stop()
            }
            
            let vc = Top40DetailViewController()
            vc.title = cell.artistLabel.text
            
            let fileURL = NSURL(string: cell.previewURL!) as! URL
            vc.fileURL = fileURL
            vc.artistName = cell.artistLabel.text?.replacingOccurrences(of: " ", with: "")
            self.show(vc, sender: self)
        }
    }
    
}

extension Top40ViewController : SideMenuDelegate {
    
    func didSelectItem(at index: Int, withTitle: String) {
        if index == 0 {
            self.title = "Top 40 Songs"
        } else {
            self.title = "Top \(withTitle) Songs"
        }
        self.loadTop40(indexGenre: index)
        self.collectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: .top, animated: true)
    }
}
