//
//  ViewController.swift
//  iTunes-Demo
//
//  Created by Zachary Khan on 10/31/16.
//  Copyright © 2016 ZacharyKhan. All rights reserved.
//

import UIKit
import AVFoundation

class SearchViewController: UIViewController {
    
    let TrackCellIdentifier = "TrackTableViewCell"
    let ArtistCellIdentifier = "ArtistTableViewCell"
    
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    
    var player : AVAudioPlayer? = nil
    
    var searchArtistResults : [Artist] = []
    var searchTrackResults : [Track] = []
    
    let entityArray = ["musicArtist", "song"]

    lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.dimsBackgroundDuringPresentation = true
        controller.searchBar.placeholder = "Search Artist"
        controller.searchBar.delegate = self
        controller.searchBar.sizeToFit()
        controller.hidesNavigationBarDuringPresentation = false
        controller.definesPresentationContext = false
        controller.searchBar.scopeButtonTitles = ["Artist", "Song"]
        return controller
    }()
    
    lazy var tableView : UITableView = {
        let tv = UITableView(frame: .zero)
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .clear
        tv.estimatedRowHeight = 60
        tv.register(TrackTableViewCell.self, forCellReuseIdentifier: self.TrackCellIdentifier)
        tv.register(ArtistTableViewCell.self, forCellReuseIdentifier: self.ArtistCellIdentifier)
        tv.separatorStyle = .none
        tv.tableHeaderView = self.searchController.searchBar
        return tv
    }()

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if self.player != nil {
            self.player?.stop()
        }
        
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    
    // Setup view
    
    func setupView() {
        
        self.view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        self.title = "Search"
        
        
        self.view.addSubview(self.tableView)
        self.view.addConstraintsWithFormat("H:|[v0]|", views: tableView)
        self.view.addConstraintsWithFormat("V:|[v0]|", views: tableView)
    }
    
    // COLLECTION VIEW
    // ----------------------------------------
    
    // DELEGATE METHOD
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.searchController.searchBar.selectedScopeButtonIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.ArtistCellIdentifier, for: indexPath) as! ArtistTableViewCell
            if let artist : Artist = self.searchArtistResults[indexPath.row] {
                if let name = artist.name, let genre = artist.genre {
                    cell.nameLabel.text = name
                    cell.genreLabel.text = genre
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.TrackCellIdentifier, for: indexPath) as! TrackTableViewCell
            if let track : Track = self.searchTrackResults[indexPath.row] {
                if let name = track.name, let artist = track.artist, let imageURL = track.imageURL {
                    cell.nameLabel.text = name
                    cell.artistLabel.text = artist
                    cell.imageURL = imageURL
                }
            }
            return cell
        }
    }
    
    // DATASOURCE
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.searchBar.selectedScopeButtonIndex == 0 {
            return self.searchArtistResults.count
        } else {
            return self.searchTrackResults.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.searchController.searchBar.selectedScopeButtonIndex != 0 {
            
            if self.player != nil {
                self.player?.stop()
            }
            
            do {
                let fileURL = NSURL(string: self.searchTrackResults[indexPath.row].previewUrl!)
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
    
    // SEARCH RESULTS UPDATING
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if !searchController.searchBar.text!.isEmpty, (searchController.searchBar.text?.characters.count)! >= 2 {
            
            let searchTerm = searchController.searchBar.text!.replacingOccurrences(of: " ", with: "")
            
            if let url : NSURL = NSURL(string: "https://itunes.apple.com/search?media=music&entity=\(entityArray[searchController.searchBar.selectedScopeButtonIndex])&term=\(searchTerm)&limit=5") {
                findData(with: url as URL, selectedScopeIndex: searchController.searchBar.selectedScopeButtonIndex)
            }
        }
    }
    
    func findData(with URL: URL?, selectedScopeIndex: Int?) {
        
        if dataTask != nil {
            dataTask?.cancel()
        }
        
        dataTask = defaultSession.dataTask(with: URL!, completionHandler: {
            (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else if (response as? HTTPURLResponse) != nil {
                self.updateSearchResults(data: data!, selectedScopeIndex: selectedScopeIndex)
            }
        })
        // 8
        dataTask?.resume()
    }
    
    func updateSearchResults(data: Data?, selectedScopeIndex: Int?) {
        
        self.searchArtistResults.removeAll()
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
                            
                            if selectedScopeIndex == 0 {
                                if let name = object["artistName"] as? String, let genre = object["primaryGenreName"] as? String {
                                    self.searchArtistResults.append(Artist(name: name, genre: genre))
                                }
                            } else {
                                let trackName = object["trackName"] as? String
                                let artistName = object["artistName"] as? String
                                let previewURL = object["previewUrl"] as? String
                                let primaryGenre = object["primaryGenreName"] as? String
                                let timeInMilli = object["timeInMillis"] as? Double
                                let imageURL = object["artworkUrl100"] as? String
                                self.searchTrackResults.append(Track(name: trackName, artist: artistName, genre: primaryGenre, time: timeInMilli, previewUrl: previewURL, imageURL: imageURL))
                            }
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
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
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        if selectedScope == 0 {
            searchBar.placeholder = "Search Artist"
            self.searchArtistResults.removeAll()
        } else {
            searchBar.placeholder = "Search Song"
            self.searchTrackResults.removeAll()
        }

        
        if let url : NSURL = NSURL(string: "https://itunes.apple.com/search?media=music&entity=\(entityArray[selectedScope])&term=\(searchBar.text!)&limit=5"), !(searchBar.text?.isEmpty)! {
            findData(with: url as URL, selectedScopeIndex: selectedScope)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }

}

