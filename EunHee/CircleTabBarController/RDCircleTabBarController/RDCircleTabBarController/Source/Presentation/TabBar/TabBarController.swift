//
//  TabBarController.swift
//  RDCircleTabBarController
//
//  Created by 정은희 on 2022/07/11.
//

import UIKit

import HeeKit
import SnapKit
import Then

class TabBarController: UITabBarController {
    
    private lazy var emptyViewController = UIViewController()
    private lazy var tabs: [UIViewController] = [ ]
    private lazy var plusButton = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "navibar_btn_record"), for: .normal)
        $0.addTarget(self,
                     action: #selector(presentRecordView),
                     for: .touchUpInside
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraint()
        setTabBarItems()
        setTabBarAppearance()
        setTabBarFrame()
    }
}

// MARK: - Extensions
extension TabBarController: Presentable {
    internal func setupView() {
        self.tabBar.addSubview(plusButton)
        self.delegate = self
    }
    
    internal func setupConstraint() {
        self.plusButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(tabBar.snp.top)
        }
    }
    
    @objc
    private func presentRecordView() {
        let recordViewController = WriteViewController.instanceFromNib()
        recordViewController.modalPresentationStyle = .fullScreen
        self.present(recordViewController, animated: true)
    }
    
    private func setTabBarItems() {
        tabs = [
            UINavigationController(rootViewController: HomeViewController()),
            UINavigationController(rootViewController: emptyViewController),
            UINavigationController(rootViewController: ArchieveViewController())
        ]
        TabBarItem.allCases.forEach {
            tabs[$0.rawValue].tabBarItem = $0.asTabBarItem()
            tabs[$0.rawValue].tabBarItem.tag = $0.rawValue
            tabs[$0.rawValue].tabBarItem.imageInsets = UIEdgeInsets(
                top: 0, left: 0, bottom: -4, right: 0
            )
        }
        self.setViewControllers(tabs, animated: false)
    }
    
    private func setTabBarAppearance() {
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().unselectedItemTintColor = .white
    }
    
    private func setTabBarFrame() {
        tabBar.frame.size.height = 96
        tabBar.frame.origin.y = view.frame.height - 9
        let customTabBar = UIImageView(image: UIImage(named: "navibar_bg"))
        customTabBar.frame = self.tabBar.bounds
        tabBar.addSubview(customTabBar)
        tabBar.sendSubviewToBack(customTabBar)
        tabBar.bringSubviewToFront(plusButton)
        tabBar.isTranslucent = true
        tabBar.itemSpacing = 67
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let tabBarItemIndex = viewController.tabBarItem.tag
        switch tabBarItemIndex {
        case 1:
            tabBarItem.isEnabled = false
            return false
        default:
            tabBarItem.isEnabled = true
        }
        return true
    }
}
