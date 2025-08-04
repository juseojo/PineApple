//
//  ItunesAPI.swift
//  PineApple
//
//  Created by seongjun cho on 7/30/25.
//

enum ItunesAPI {
    case popularSongs
    case popularMovie
    case popularPodcast
    case search(title: String, offset: Int, media: MediaType)
}
