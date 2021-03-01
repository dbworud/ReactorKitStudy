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
import SafariServices

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
        // Action in UI
        searchController.searchBar.rx.text
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { GithubSearchReactor.Action.updateQuery($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.contentOffset
            .filter { [weak self] offset in
                guard let `self` = self else { return false }
                guard self.tableView.frame.height > 0 else { return false }
                
                return offset.y + self.tableView.frame.height >= self.tableView.contentSize.height - 100
            }
            .map { _ in GithubSearchReactor.Action.loadNextPage}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.repos }
            .bind(to: tableView.rx.items(cellIdentifier: GithubSearchCell.identifier)) { indexPath, repo, cell in
                cell.textLabel?.text = repo
            }
            .disposed(by: disposeBag)
        
        // View
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self, weak reactor] indexPath in
                guard let `self` = self else { return }
                self.view.endEditing(true)
                self.tableView.deselectRow(at: indexPath, animated: false)
                guard let repo = reactor?.currentState.repos[indexPath.row] else { return }
                guard let url = URL(string: "https://github.com/\(repo)") else { return }
                let viewController = SFSafariViewController(url: url)
                self.searchController.present(viewController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

