//
//  MovieDetailVC.swift
//  RxSwift-Tutorial
//
//  Created by Yaşar Duman on 7.02.2024.
//

import UIKit
import Kingfisher

final class MovieDetailVC: UIViewController {
    
    // MARK: - Constants
    var movieDetailViewModel: MovieDetailViewModel?
    
    //MARK: - IBOutlet
    @IBOutlet private weak var movieImage: UIImageView!
    
    //MARK: - Initializers
    func setInitializeVM(_ movieDetailViewModel: MovieDetailViewModel) {
        self.movieDetailViewModel = movieDetailViewModel
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        setData()
        
    }
    
    // MARK: Set Title
    private func setTitle() {
        self.title = self.movieDetailViewModel?.movieData.original_title ?? "Film Detayları"
    }

    // MARK: Set Data
    private func setData() {
        if let imageURL = movieDetailViewModel?.movieData.backdrop_path ?? movieDetailViewModel?.movieData.poster_path{
            self.movieImage.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500/"+imageURL))
        }
    }
}
