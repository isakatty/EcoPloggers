//
//  PloggerTabBarController.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 8/17/24.
//

import UIKit

final class PloggerTabBarController: UITabBarController {
    
    private enum TabBarCase: Int, CaseIterable {
        case home = 0
        case search
        case myPage
        
        var tabItem: UITabBarItem {
            switch self {
            case .home:
                return UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: rawValue)
            case .search:
                return UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: rawValue)
            case .myPage:
                return UITabBarItem(title: "내 정보", image: UIImage(systemName: "person"), tag: rawValue)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabbar()
    }
    
    private func configureTabbar() {
        let vcs = [
            PloggersViewController(),
            SearchViewController(),
            MyPageViewController()
        ]
        
        setViewControllers(
            configureTabs(vcGroup: vcs),
            animated: true
        )
    }
    private func configureTabs(vcGroup: [UIViewController]) -> [UINavigationController] {
        return vcGroup.enumerated().compactMap { (index, vc) in
            guard let tabBarItemCase = TabBarCase(rawValue: index) else { return nil }
            let navController = UINavigationController(rootViewController: vc)
            navController.tabBarItem = tabBarItemCase.tabItem
            return navController
        }
    }
}
