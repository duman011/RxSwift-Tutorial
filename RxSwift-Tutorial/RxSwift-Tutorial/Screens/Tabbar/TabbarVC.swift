//
//  TabbarVC.swift
//  RxSwift-Tutorial
//
//  Created by Yaşar Duman on 18.02.2024.
//

import UIKit

final class TabbarVC : UITabBarController {
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Tab bar arka plan rengi
        tabBar.backgroundColor = .tertiarySystemBackground
        
        // Seçili olan öğelerin rengi
        tabBar.tintColor = .label
        
        // Seçilmeyen öğelerin rengi
        tabBar.unselectedItemTintColor = .systemGray
        
        viewControllers = [
            createHomeNC(),
            createFavoriteNC()
        ]
    }
}

extension TabbarVC {
    // MARK: - Home Navigation Controller 🏠
    private func createHomeNC() -> UINavigationController {
        let homeVC = HomeVC()
        
        homeVC.tabBarItem = UITabBarItem(title: "Home",
                                         image: UIImage(systemName: "house"),
                                         selectedImage: UIImage(systemName: "house.fill"))
        
        return UINavigationController(rootViewController: homeVC)
    }
    
    // MARK: - Search Navigation Controller 🔍
    private func createFavoriteNC() -> UINavigationController {
        let favoriteVC = FavoriteVC()
        
        favoriteVC.tabBarItem = UITabBarItem(title: "Search",
                                          image: UIImage(systemName: "magnifyingglass"),
                                          selectedImage: UIImage(systemName: "magnifyingglass"))
        
        return UINavigationController(rootViewController: favoriteVC)
    }
    
}
