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
    @IBOutlet weak var movieImage: UIImageView!
    
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
        if let urlString = self.movieDetailViewModel?.movieData.poster_path,
           let url = URL(string: urlString) {
            self.movieImage.kf.setImage(with: url)
        }
    }
}
