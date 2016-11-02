//
//  Top40DetailViewController.swift
//  iTunes-Demo
//
//  Created by Zachary Khan on 11/1/16.
//  Copyright © 2016 ZacharyKhan. All rights reserved.
//

import UIKit
import AVFoundation

class Top40DetailViewController: UIViewController {
    
    let detailCellId = "DetailCollectionViewCellIdentifier"
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    var player : AVAudioPlayer? = nil
    var fileURL : URL?
    var artistName : String?
    
    var searchTrackResults : [Track] = []

    lazy var collectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TrackCollectionViewCell.self, forCellWithReuseIdentifier: self.detailCellId)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.contentInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        return collectionView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if self.fileURL != nil {
            self.playPreview(fileURL: fileURL)
        }
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if self.player != nil, (self.player?.isPlaying)! {
            self.player?.stop()
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        self.view.addSubview(collectionView)
        self.view.addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        self.view.addConstraintsWithFormat("V:|[v0]|", views: collectionView)
        
        if let url : NSURL = NSURL(string: "https://itunes.apple.com/search?media=music&entity=song&term=\(self.artistName!)&limit=12") {
            findData(with: url as URL)
        }

    }
    
    func playPreview(fileURL : URL?) {
        
        if self.player != nil, (self.player?.isPlaying)! {
            self.player?.stop()
        }
        
        do {
            
            let soundData = NSData(contentsOf: fileURL! as URL)
            self.player = try AVAudioPlayer(data: soundData! as Data)
            self.player?.prepareToPlay()
            self.player?.volume = 1.0
            self.player?.play()
            
        } catch {
            print("Error getting the audio file")
        }
    }
    

}

extension Top40DetailViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.detailCellId, for: indexPath) as! TrackCollectionViewCell
        cell.artistLabel.text = self.searchTrackResults[indexPath.item].artist
        cell.imageURL = self.searchTrackResults[indexPath.item].imageURL
        cell.trackLabel.text = self.searchTrackResults[indexPath.item].name
        cell.previewURL = self.searchTrackResults[indexPath.item].previewUrl
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchTrackResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: (collectionView.bounds.width/2)-4, height: (collectionView.bounds.height/3)-19)
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
            self.playPreview(fileURL: NSURL(string: cell.previewURL)! as URL)
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
        
        dataTask?.resume()
    }
    
    func updateSearchResults(data: Data?) {
        
        self.searchTrackResults.removeAll()
        
        do {
            if let data = data, let response = try JSONSerialization.jsonObject(with: data as Data, options:JSONSerialization.ReadingOptions(rawValue:0)) as? [String: AnyObject] {
                // Get the results array
                if let array: AnyObject = response["results"] {
                    
                    //each result is a dictionary
                    for dictionary in array as! [AnyObject] {
                        
                        // objects are nested dictionaries
                        if let object = dictionary as? [String: AnyObject] {
                            
                            // Parse the search result
                            
                            let trackName = object["trackName"] as? String
                            let artistName = object["artistName"] as? String
                            let previewURL = object["previewUrl"] as? String
                            let primaryGenre = object["primaryGenreName"] as? String
                            let imageURL = object["artworkUrl100"] as? String
                            self.searchTrackResults.append(Track(name: trackName, artist: artistName, genre: primaryGenre, time: nil, previewUrl: previewURL, imageURL: imageURL))
                            
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        } else {
                            print("Not a dictionary")
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

