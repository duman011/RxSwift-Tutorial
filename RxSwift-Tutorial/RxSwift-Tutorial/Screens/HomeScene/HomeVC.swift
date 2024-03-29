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
    private let viewModel: HomeViewModel = HomeViewModel()
    
    //MARK: - Variables
    private let emptyListView: UIEmptyView = UIEmptyView()
    
    //MARK: - IBOutlet
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        initialSetting()
        subscribeIsLoad()
        tableViewItemSelected()
        subscribeList()
        tableViewBind()
        subscribeLogoutButton()
    }
    
    // MARK: Register Table View Cell
    private func initialSetting() {
        tableView.registerCell(MovieTableViewCell.self)
        tableView.rowHeight = 150
        searchBar.delegate = self
    }
    
    func configureNavigationBar() {
       let titleLabel = UILabel()
       titleLabel.text = "Movie Search"
       
       if let customFont = UIFont(name: "Agbalumo-Regular", size: 30) {
           titleLabel.font = customFont
           navigationItem.titleView = titleLabel
           titleLabel.textColor = .label
       }
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
            }.disposed(by: viewModel.disposeBag)
    }
    
    // MARK: List Subscribe
    /// ViewModel' daki moviesList'e observe olur ve boş olması durumunda empy Viewı Degiştir
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
                        self.tableView.backgroundView = nil
                    }
                }
            }, onError: { [weak self] error in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.tableView.backgroundView = nil
                }
            }).disposed(by: viewModel.disposeBag)
    }
    
    private func subscribeLogoutButton(){
        logoutButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self else { return }
                viewModel.logout{
                    let loginVC: LoginVC = .instantiate()
                    let nav = UINavigationController(rootViewController: loginVC)
                    self.view.window?.rootViewController = nav
                }
            })
            .disposed(by: viewModel.disposeBag)
    }
}


// MARK: Serch Bar Delegate
extension HomeVC: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.moviesList.accept([])
        }
    }
  
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            if viewModel.moviesList.value.isEmpty && searchBar.text != "" {
                emptyListView.configrations(.searchError)
                tableView.backgroundView = self.emptyListView
            }
        }
    }
 
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchedText: String = searchBar.text ?? ""
        if searchedText.count < 4 {
            viewModel.moviesList.accept([])
            tableView.reloadData()
        } else {
            viewModel.getMoviesByName(search: searchedText)
        }
        
       view.endEditing(true)
    }
}



