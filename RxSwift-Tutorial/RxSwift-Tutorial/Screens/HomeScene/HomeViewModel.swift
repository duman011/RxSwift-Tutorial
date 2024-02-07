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
            .subscribe(onNext: { [weak self] (result: WsResult<MovieResponse>) in
                switch result {
                case .success(let response):
                    let getUpcomingMovies = response.results
                    self?.moviesList.accept(getUpcomingMovies)
                    self?.isLoad.accept(false)
                    
                    // Güncellenmiş moviesList değerini kontrol et
                    print("2dönen response Count: \(self?.moviesList.value.count ?? 0)")
                case .failure(_):
                    self?.isLoad.accept(false)
                }
            }, onError: { [weak self] (error) in
                self?.isLoad.accept(false)
            })
            .disposed(by: disposeBag)
    }

}
