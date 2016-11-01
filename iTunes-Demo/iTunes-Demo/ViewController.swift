//
//  ViewController.swift
//  iTunes-Demo
//
//  Created by Zachary Khan on 10/31/16.
//  Copyright © 2016 ZacharyKhan. All rights reserved.
//

import UIKit

private let cellIdentifier = "CellIdentifier"

class ViewController: UIViewController {
    
    
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
        controller.searchBar.scopeButtonTitles = ["Artist", "Song"]
        return controller
    }()
    
    lazy var tableView : UITableView = {
        let tv = UITableView(frame: .zero)
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .clear
        tv.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tv.separatorStyle = .none
        tv.tableHeaderView = self.searchController.searchBar
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

extension ViewController : UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    
    // Setup view
    
    func setupView() {
        self.view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        self.view.addSubview(self.tableView)
        self.view.addConstraintsWithFormat("H:|[v0]|", views: tableView)
        self.view.addConstraintsWithFormat("V:|-20-[v0]|", views: tableView)
    }
    
    // COLLECTION VIEW
    // ----------------------------------------
    
    // DELEGATE METHOD
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = .white
        
        if self.searchController.searchBar.selectedScopeButtonIndex == 0 {
            if let artist : Artist = self.searchArtistResults[indexPath.row] {
                if let name = artist.name, let genre = artist.genre {
                    cell.textLabel?.text = "\(name) - \(genre)"
                }
            }
        } else {
            if let track : Track = self.searchTrackResults[indexPath.row] {
                if let name = track.name, let artist = track.artist {
                    cell.textLabel?.text = "\(artist) - \(name)"
                }
            }
        }
        
        return cell
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
                                self.searchTrackResults.append(Track(name: trackName, artist: artistName, previewUrl: previewURL))
                                print(trackName!, " - ",artistName!)
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
        } else {
            searchBar.placeholder = "Search Song"
        }
        
        if let url : NSURL = NSURL(string: "https://itunes.apple.com/search?media=music&entity=\(entityArray[selectedScope])&term=\(searchBar.text!)&limit=15"), !(searchBar.text?.isEmpty)! {
            
            findData(with: url as URL, selectedScopeIndex: selectedScope)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }

}

