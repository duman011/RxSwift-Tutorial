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
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var imdbLabel: UILabel!
    
  
    override func layoutSubviews() {
        super.layoutSubviews()

        selectionStyle = .none        
        configureMovieImage()
        configureContainerView()
    }

    
    private func configureContainerView(){
        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = 15
        containerView.layer.shadowColor = UIColor.label.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowOpacity = 0.6
        containerView.layer.shadowRadius = 4
        containerView.layer.masksToBounds = false
    }
    
    private func configureMovieImage(){
        movieImage.contentMode = .scaleAspectFill
        movieImage.layer.masksToBounds = true
        movieImage.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMinXMaxYCorner
        ]
        movieImage.layer.cornerRadius = 15
    }
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
