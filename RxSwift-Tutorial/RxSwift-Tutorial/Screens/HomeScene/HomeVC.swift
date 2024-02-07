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
        print("Home VC Açıldı")
        initialSetting()
        setTitle()
        subscribeIsLoad()
        subscribeList()
        tableViewItemSelected()
        tableViewBind()
    }
    
    // MARK: Set Title
    private func setTitle() {
        self.title = "Ana Sayfa"
        self.searchBar.placeholder = "Film Arayın..."
    }
    
    // MARK: Register Table View Cell
    private func initialSetting() {
        self.tableView.register(UINib(nibName: MovieTableViewCell.identifier,
                                      bundle: nil),
                                forCellReuseIdentifier: MovieTableViewCell.identifier)
        self.tableView.rowHeight = 150
        self.searchBar.delegate = self
    }
    
    // MARK: Table View Bind
    /// ViewModel' daki movie listin degerine gore otomatik olarak cell yerlestirir.
    private func tableViewBind() {
        viewModel
            .moviesList
            .asObservable()
            .bind(to: self.tableView
                .rx
                .items(cellIdentifier: MovieTableViewCell.identifier, cellType: MovieTableViewCell.self)){ (row, movieData, cell) in
                    cell.configureCell(with: movieData)
                    
                }.disposed(by: self.viewModel.disposeBag)
    }
    
    // MARK: Table View Item Selected
    /// TableView' daki itemların tiklama aksiyonu.
    private func tableViewItemSelected() {
        tableView
            .rx
            .modelSelected(Movie.self)
            .subscribe(onNext: { [weak self] movieData in
                let vc:MovieDetailVC = .instantiate()
                vc.setInitializeVM(MovieDetailViewModel(movieData: movieData))
                self?.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: self.viewModel.disposeBag)
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
                if(list.isEmpty) {
                    self?.emptyListView.configrations(.searchEmpty)
                    self?.tableView.backgroundView = self?.emptyListView
                } else {
                    DispatchQueue.main.async {
                        self?.tableView.backgroundView = nil
                    }
                }
            }, onError: { [weak self] error in
                self?.tableView.backgroundView = nil
            }).disposed(by: self.viewModel.disposeBag)
    }
    
}


// MARK: Serch Bar Delegate
extension HomeVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchedText: String = searchBar.text ?? ""
        self.viewModel.getMoviesByName(search: searchedText)
        self.view.endEditing(true)
    }
    
}
