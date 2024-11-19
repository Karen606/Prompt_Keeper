//
//  TabBarViewController.swift
//  Prompt_Keeper
//
//  Created by Karen Khachatryan on 19.11.24.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    private let selectedTabBorder = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setValue(CustomTabBar(), forKey: "tabBar")
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        homeVC.tabBarItem = UITabBarItem(title: "HOME", image: .homeTab.withRenderingMode(.alwaysOriginal), tag: 0)

        let promptrVC = PromptViewController(nibName: "PromptViewController", bundle: nil)
        promptrVC.tabBarItem = UITabBarItem(title: "PROMPT", image: .promptTab.withRenderingMode(.alwaysOriginal), tag: 1)

        let favoritesVC = FavoritesViewController(nibName: "FavoritesViewController", bundle: nil)
        favoritesVC.tabBarItem = UITabBarItem(title: "FAVORITES", image: .favoritesTab.withRenderingMode(.alwaysOriginal), tag: 2)

        let settingsVC = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        settingsVC.tabBarItem = UITabBarItem(title: "SETTINGS", image: .settingsTab.withRenderingMode(.alwaysOriginal), tag: 3)

        self.viewControllers = [homeVC, promptrVC, favoritesVC, settingsVC]
        self.delegate = self

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .button
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.bold(size: 14) ?? .systemFont(ofSize: 14),
            .foregroundColor: UIColor.white
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.bold(size: 14) ?? .systemFont(ofSize: 14),
            .foregroundColor: UIColor.white
        ]
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.addTopBorder(color: #colorLiteral(red: 0.3450980392, green: 0.3450980392, blue: 0.3450980392, alpha: 1), thickness: 2)
        configureTabBorder()
    }

    private func configureTabBorder() {
        selectedTabBorder.translatesAutoresizingMaskIntoConstraints = false
        tabBar.addSubview(selectedTabBorder)
        selectedTabBorder.backgroundColor = .systemBlue
        updateBorderPosition(for: self.selectedIndex)
    }

    private func updateBorderPosition(for index: Int) {
        guard let tabBarItems = tabBar.items, index < tabBarItems.count else { return }
        
        let tabBarWidth = tabBar.bounds.width / CGFloat(tabBarItems.count)
        let borderHeight: CGFloat = 2
        let xPosition = CGFloat(index) * tabBarWidth

        UIView.animate(withDuration: 0.3) {
            self.selectedTabBorder.frame = CGRect(
                x: xPosition,
                y: 0,
                width: tabBarWidth,
                height: borderHeight
            )
        }
        
        selectedTabBorder.backgroundColor = .selectedTab
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let index = viewControllers?.firstIndex(of: viewController) else { return }
        updateBorderPosition(for: index)
    }
}

class CustomTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 100
        return sizeThatFits
    }
}

