//
//  RMTabBarController.swift
//  RickAndMorty
//
//  Created by Razumov Pavel on 14.04.2025.
//

import UIKit

final class RMTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpTabs()
    }
    
    private func setUpTabs() {
        let characterVC = RMCharacterViewController()
        let locationVC = RMLocationViewController()
        let episodeVC = RMEpisodeViewController()
        let settingsVC = RMSettingsViewController()
        
        [characterVC, locationVC,
         episodeVC, settingsVC
        ].forEach { $0.navigationItem.largeTitleDisplayMode = .automatic }
          
        let nav1 = UINavigationController(rootViewController: characterVC)
        let nav2 = UINavigationController(rootViewController: locationVC)
        let nav3 = UINavigationController(rootViewController: episodeVC)
        let nav4 = UINavigationController(rootViewController: settingsVC)
        
        nav1.tabBarItem = UITabBarItem(
            title: "Character",
            image: UIImage(systemName: "person"),
            tag: 1)
        nav2.tabBarItem = UITabBarItem(
            title: "Locations",
            image: UIImage(systemName: "globe"),
            tag: 2)
        nav3.tabBarItem = UITabBarItem(
            title: "Episodes",
            image: UIImage(systemName: "tv"),
            tag: 3)
        nav4.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gear"),
            tag: 4)
        
        let controllers = [nav1, nav2, nav3, nav4]
        controllers.forEach { $0.navigationBar.prefersLargeTitles = true }
        viewControllers = controllers
    }
}
