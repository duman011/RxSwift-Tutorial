//
//  Moview.swift
//  RxSwift-Tutorial
//
//  Created by Yaşar Duman on 7.02.2024.
//

struct MovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let original_title: String?
    let overview: String?
    let poster_path: String?
    let backdrop_path: String?
    let release_date: String?
    let vote_average: Double?
}
