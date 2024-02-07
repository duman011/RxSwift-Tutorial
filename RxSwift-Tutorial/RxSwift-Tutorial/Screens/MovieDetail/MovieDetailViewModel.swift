//
//  MovieDetailViewModel.swift
//  RxSwift-Tutorial
//
//  Created by Yaşar Duman on 7.02.2024.
//

import Foundation

final class MovieDetailViewModel: BaseViewModel {
    
    let movieData: Movie
    
    init(movieData: Movie) {
        self.movieData = movieData
    }
}
