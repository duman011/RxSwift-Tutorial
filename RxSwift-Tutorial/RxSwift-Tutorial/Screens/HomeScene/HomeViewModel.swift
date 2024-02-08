//
//  HomeViewModel.swift
//  RxSwift-Tutorial
//
//  Created by Yaşar Duman on 6.02.2024.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel:BaseViewModel {
    
    let moviesList = BehaviorRelay<[Movie]>.init(value: [])

    // MARK: Get Movies By Name
    func getMoviesByName(search: String) {
        isLoad.accept(true)
        moviesList.accept([])
        
        NetworkService.shared.search(with: search)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let response):
                    let getUpcomingMovies = response.results.filter({$0.poster_path != nil})
                    self?.moviesList.accept(getUpcomingMovies)
                    self?.isLoad.accept(false)
                case .failure(_):
                    self?.isLoad.accept(false)
                }
            }, onError: { [weak self] (error) in
                self?.isLoad.accept(false)
            })
            .disposed(by: disposeBag)
    }

}
