//
//  Track.swift
//  HalfTunes
//
//  Created by Ken Toh on 13/7/15.
//  Copyright (c) 2015 Ken Toh. All rights reserved.
//

class Track {
    var name: String?
    var artist: String?
    var previewUrl: String?
    var imageURL: String?
    var genre : String?
    var time : Double?
  
    init(name: String?, artist: String?, genre: String?, time: Double?, previewUrl: String?, imageURL : String?) {
        self.name = name
        self.artist = artist
        self.previewUrl = previewUrl
        self.imageURL = imageURL
        self.genre = genre
        self.time = time
    }
}
