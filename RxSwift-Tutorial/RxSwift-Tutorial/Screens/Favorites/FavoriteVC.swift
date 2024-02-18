//
//  FavoriteVC.swift
//  RxSwift-Tutorial
//
//  Created by Yaşar Duman on 18.02.2024.
//

import UIKit

final class FavoriteVC: BaseVC {
    
    //MARK: - Constants
    private let viewModel: FavotireViewModel = FavotireViewModel()
    
    //MARK: - Variables
    private let emptyListView: UIEmptyView = UIEmptyView()
    
    //MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        initialSetting()
    }
    
    // MARK: Register Table View Cell
    private func initialSetting() {
        tableView.registerCell(MovieTableViewCell.self)
        tableView.rowHeight = 150
    }
    
    func configureNavigationBar() {
       let titleLabel = UILabel()
       titleLabel.text = "Favorite Movies"
       
       if let customFont = UIFont(name: "Agbalumo-Regular", size: 30) {
           titleLabel.font = customFont
           navigationItem.titleView = titleLabel
           titleLabel.textColor = .label
       }
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


}
