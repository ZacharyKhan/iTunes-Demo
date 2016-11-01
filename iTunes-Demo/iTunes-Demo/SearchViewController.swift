//
//  ViewController.swift
//  iTunes-Demo
//
//  Created by Zachary Khan on 10/31/16.
//  Copyright © 2016 ZacharyKhan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    let TrackCellIdentifier = "TrackTableViewCell"
    let ArtistCellIdentifier = "ArtistTableViewCell"
    
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    
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

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    
    // Setup view
    
    func setupView() {
        
        self.view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        self.title = "iTunes"
        
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
                if let name = track.name, let artist = track.artist {
                    cell.nameLabel.text = name
                    cell.artistLabel.text = artist
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
    
    // SEARCH RESULTS UPDATING
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if !searchController.searchBar.text!.isEmpty {
            
            let searchTerm = searchController.searchBar.text!
            
            if let url : NSURL = NSURL(string: "https://itunes.apple.com/search?media=music&entity=\(entityArray[searchController.searchBar.selectedScopeButtonIndex])&term=\(searchTerm)&limit=15") {
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

        if selectedScopeIndex == 0 {
            self.searchArtistResults.removeAll()
        } else {
            self.searchTrackResults.removeAll()
        }
        
        do {
            if let data = data, let response = try JSONSerialization.jsonObject(with: data as Data, options:JSONSerialization.ReadingOptions(rawValue:0)) as? [String: AnyObject] {
                
                // Get the results array
                if let array: AnyObject = response["results"] {
                    for dictionary in array as! [AnyObject] {
                        if let object = dictionary as? [String: AnyObject] {
                            // Parse the search result
                            //let name = trackDictonary["trackName"] as? String
                            
                            if selectedScopeIndex == 0 {
                                let name = object["artistName"] as? String
                                let genre = object["primaryGenreName"] as? String
                                self.searchArtistResults.append(Artist(name: name, genre: genre))
                            } else {
                                let trackName = object["trackName"] as? String
                                let artistName = object["artistName"] as? String
                                let previewURL = object["previewURL"] as? String
                                self.searchTrackResults.append(Track(name: trackName, artist: artistName, previewUrl: previewURL, imageURL: nil))
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
        
        tableView.reloadData()
        
        if let url : NSURL = NSURL(string: "https://itunes.apple.com/search?media=music&entity=\(entityArray[selectedScope])&term=\(searchBar.text!)&limit=15"), !(searchBar.text?.isEmpty)! {
            
            findData(with: url as URL, selectedScopeIndex: selectedScope)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }

}

