//
//  GithubSearchViewController.swift
//  ReactorKitStudy
//
//  Created by jaekyung you on 2021/02/28.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa


class GithubSearchViewController: UIViewController {
    
    // MARK: Properties
    let disposeBag = DisposeBag()
    let reactor = GithubSearchReactor()
    
    lazy var tableView: UITableView = {
       let tb = UITableView()
        tb.register(GithubSearchCell.self, forCellReuseIdentifier: GithubSearchCell.identifier)
        return tb
    }()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind(reactor: reactor)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.setAnimationsEnabled(false)
        searchController.isActive = true
        searchController.isActive = false
        UIView.setAnimationsEnabled(true)
    }
    
    // MARK: Method
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        
        ])
        
        tableView.scrollIndicatorInsets.top = tableView.contentInset.top
        
        searchController.dimsBackgroundDuringPresentation = false
        
        self.navigationItem.title = "Github Search"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
    }
    
    func bind(reactor: GithubSearchReactor) {
        
    }
}

