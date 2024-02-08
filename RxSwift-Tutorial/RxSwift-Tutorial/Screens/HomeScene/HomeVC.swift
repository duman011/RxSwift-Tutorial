//
//  HomeVC.swift
//  RxSwift-Tutorial
//
//  Created by Yaşar Duman on 6.02.2024.
//

import UIKit
import RxSwift
import RxCocoa


final class HomeVC: BaseVC {
    //MARK: - Constants
    let viewModel: HomeViewModel = HomeViewModel()
    
    //MARK: - Variables
    private let emptyListView: UIEmptyView = UIEmptyView()
    
    //MARK: - IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetting()
        subscribeIsLoad()
        subscribeList()
        tableViewItemSelected()
        tableViewBind()
        searchBarTextDidChange()
       
    }
    
    // MARK: Register Table View Cell
    private func initialSetting() {
        tableView.register(UINib(nibName: MovieTableViewCell.identifier,
                                      bundle: nil),
                                forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.rowHeight = 150
        searchBar.delegate = self
    }
    
    // MARK: Table View Bind
    /// ViewModel' daki movie listin degerine gore otomatik olarak cell yerlestirir.
    private func tableViewBind() {
        viewModel
            .moviesList
            .asObservable()
            .bind(to: tableView
                .rx
                .items(cellIdentifier: MovieTableViewCell.identifier, cellType: MovieTableViewCell.self)){ (row, movieData, cell) in
                    cell.configureCell(with: movieData)
                }.disposed(by: viewModel.disposeBag)
    }
    
    // MARK: Table View Item Selected
    /// TableView' daki itemların tiklama aksiyonu.
    private func tableViewItemSelected() {
        tableView
            .rx
            .modelSelected(Movie.self)
            .subscribe(onNext: { [weak self] movieData in
                guard let self else { return }
                let vc:MovieDetailVC = .instantiate()
                vc.setInitializeVM(MovieDetailViewModel(movieData: movieData))
                navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: viewModel.disposeBag)
    }
    
    
    // MARK: Subscribe Is Load
    /// Yukleme animasyonuna observe olur.
    func subscribeIsLoad() {
        self.viewModel
            .isLoad
            .subscribe { value in
                if (value.element ?? false) {
                    self.loadingState(true)
                } else {
                    self.loadingState(false)
                }
            }.disposed(by: self.viewModel.disposeBag)
    }
    
    
    // MARK: List Subscribe
    private func subscribeList() {
        viewModel
            .moviesList
            .subscribe(onNext: { [weak self] list in
                guard let self else { return }
                DispatchQueue.main.async {
                    if list.isEmpty && self.searchBar.text == "" {
                        self.emptyListView.configrations(.searchEmpty)
                        self.tableView.backgroundView = self.emptyListView
                    } else {
                        self.emptyListView.configrations(.searchError)
                        self.tableView.backgroundView = self.emptyListView
                    }
                }
            }, onError: { [weak self] error in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.tableView.backgroundView = nil
                }
            }).disposed(by: viewModel.disposeBag)
    }


    
    private func searchBarTextDidChange() {
        // SearchBar'daki metni dinleyin ve RxSwift ile işleyin
             searchBar.rx.text.orEmpty
                 .distinctUntilChanged() // Tekrar eden değerleri filtrele
                 .debounce(.milliseconds(800), scheduler: MainScheduler.instance) // Kullanıcının yazmayı bitirmesini bekleyin
                 .subscribe(onNext: { [weak self] searchText in
                     guard let self else { return }
                     if searchText.count < 4 {
                         viewModel.moviesList.accept([])
                         tableView.reloadData()
                     } else {
                         self.viewModel.getMoviesByName(search: searchText)
                     }
                 })
                 .disposed(by: viewModel.disposeBag)
    }
}


// MARK: Serch Bar Delegate
extension HomeVC: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      
        }
    }



