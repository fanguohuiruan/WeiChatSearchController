//
//  ViewController.swift
//  CustomWeiChatSearchController
//
//  Created by 范国徽 on 2018/4/8.
//  Copyright © 2018年 范国徽. All rights reserved.
//

import UIKit
extension UIDevice {

    static var isIPhoneX: Bool {
        return UIScreen.main.bounds.width == 375 && UIScreen.main.bounds.height == 812
    }

}
let statusBarHeight = UIApplication.shared.statusBarFrame.height
class ViewController: UIViewController {

    lazy var tableView: UITableView = {

        let table = UITableView.init(frame: self.view.bounds, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return table
    }()

    lazy var searchVC: WeiChatSearchViewController = {
        let searchResultVC = WeiChatSearchResultVC.init(nibName: nil, bundle: nil)
        let searchVC = WeiChatSearchViewController.init(searchResultVC: searchResultVC)
        searchVC.searchControllerDelegate = self
        let cancleAction: cancelHandler = {
            [weak self] in
            guard let strong = self else {
                return
            }
            strong.searchVC.view.removeFromSuperview()
            strong.searchVC.removeFromParentViewController()
            CATransaction.begin()
            strong.searchBar.setShowsCancelButton(true, animated: false)
            CATransaction.setDisableActions(true)
            CATransaction.commit()
            CATransaction.setCompletionBlock({

                UIView.animate(withDuration: 0.28, animations: {

                    var navigatonBarFrame = strong.customNavigationBar.frame
                    navigatonBarFrame.origin.y += 44
                    strong.customNavigationBar.frame = navigatonBarFrame

                    var tableViewFrame = strong.tableView.frame
                    tableViewFrame.origin.y += 44
                    strong.tableView.frame = tableViewFrame
                    strong.searchBar.setShowsCancelButton(false, animated: true)

                }, completion: {
                    [weak self](_) in
                })
            })

        }
        searchVC.cancelBlock = cancleAction
        return searchVC
    }()

    lazy var searchBar: CustomSearchBar = {
        let bar = CustomSearchBar.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        bar.searchIconOffset = true
        bar.delegate = self
        
        return bar
    }()

    lazy var customNavigationBar: CustomNavigationView = {

        let navigationView = CustomNavigationView.init(frame: .zero)
        navigationView.title = "微信"
        return navigationView
    }()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    var statusBarStyle: Bool = true
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return  .lightContent
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    var filterResult: [String] = []

    var dataArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        print(UIApplication.shared.statusBarFrame)
        dataArray = CountryManagerModel.share.countryList
        self.filterResult = dataArray

        self.view.addSubview(customNavigationBar)
        self.view.addSubview(self.tableView)

        self.tableView.tableHeaderView = self.searchBar
        var navigationViewHeight: CGFloat = statusBarHeight + 44
//        if UIDevice.isIPhoneX {
//            navigationViewHeight = statusBarHeight + 44
//        }
        customNavigationBar.frame = CGRect.init(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: navigationViewHeight)

        self.tableView.frame = CGRect.init(x: 0.0, y: navigationViewHeight, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.height-navigationViewHeight)


        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {

    }
    var sourceArray: [String] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
}

extension ViewController {

    func showSearchBarAnimating() {
        CATransaction.begin()
        addChildViewController(self.searchVC)
        self.view.addSubview(self.searchVC.view)
        self.searchVC.view.alpha = 0
        CATransaction.disableActions()
        CATransaction.commit()
        UIView.animate(withDuration: 0.2, animations: {
         [weak self] in
            guard let strong = self else {
                return
            }
            var navigatonBarFrame = strong.customNavigationBar.frame
            navigatonBarFrame.origin.y -= 44
            strong.customNavigationBar.frame = navigatonBarFrame

            var tableViewFrame = strong.tableView.frame
            tableViewFrame.origin.y -= 44
            strong.tableView.frame = tableViewFrame
            strong.searchVC.searchBar.setShowsCancelButton(true, animated: true)

            strong.customNavigationBar.backgroundColor = UIColor.groupTableViewBackground

            strong.searchBar.setShowsCancelButton(true, animated: true)


        }) { [weak self](_) in
            guard let strong = self else {
                return
            }
            strong.searchVC.view.alpha = 1
            self?.customNavigationBar.backgroundColor = UIColor.black
            strong.searchBar.showsCancelButton = false
        }
    }
}

extension ViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        showSearchBarAnimating()
        return false
    }
}

extension ViewController: WeiChatSerachViewControllerDelegate {

    func willPresentSearchController(_ searchController: WeiChatSearchViewController) {
        searchVC.addChildViewController(searchVC.searchResultViewController)
        searchVC.view.addSubview(searchVC.searchResultViewController.view)
    }

    func willDismissSearchController(_ searchController: WeiChatSearchViewController) {
        searchVC.searchResultViewController.view.removeFromSuperview()
        searchVC.searchResultViewController.removeFromParentViewController()
    }

    func updateSearchResults(for searchController: WeiChatSearchViewController) {

        let searchContent = self.searchVC.searchBar.text ?? ""
        let predicate = NSPredicate.init(format: "(SELF CONTAINS %@)", searchContent)
        let filterArray = (dataArray as NSArray).filtered(using: predicate) as! [String]
        self.filterResult = searchContent.count > 0 ? filterArray : dataArray
        let searchResult = self.searchVC.searchResultViewController!
        searchResult.sourceArray = self.filterResult
    }
}
extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{

        return 30
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.statusBarStyle = (indexPath.row % 2 == 0) ? true:false
        setNeedsStatusBarAppearanceUpdate()
    }

}

extension ViewController: UITableViewDataSource{


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}

