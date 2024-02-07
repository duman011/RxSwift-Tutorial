//
//  MovieTableViewCell.swift
//  RxSwift-Tutorial
//
//  Created by Yaşar Duman on 7.02.2024.
//


import UIKit
import Kingfisher

final class MovieTableViewCell: UITableViewCell {
    
    //MARK: - Cell's Identifier
    static let identifier = "MovieTableViewCell"
    
    //MARK: - IBOutlet
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var imdbLabel: UILabel!
    
}


extension MovieTableViewCell {
    
    // MARK: - Public Methods
    func configureCell(with movies: Movie) {
        if let imageURL = movies.poster_path {
            movieImage.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500/\(imageURL)"))
        }
        
        movieName.text = movies.original_title
        movieReleaseDate.text = movies.release_date
        
        if let voteAverage = movies.vote_average {
            let formattedValue = String(format: "%.1f", voteAverage)
            self.imdbLabel.text = formattedValue
        }
    }
}
