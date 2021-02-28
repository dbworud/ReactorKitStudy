//
//  CounterViewController.swift
//  ReactorKitStudy
//
//  Created by jaekyung you on 2021/02/28.
//

import UIKit
import ReactorKit
import RxCocoa


class CounterViewController: UIViewController {
    
    lazy var decreaseButton: UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(systemName: "minus"), for: .normal)
        btn.scalesLargeContentImage = true
        return btn
    }()
    
    lazy var increaseButton: UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(systemName: "plus"), for: .normal)
        btn.scalesLargeContentImage = true
        return btn
    }()
    
    lazy var valueLabel: UILabel = {
       let label = UILabel()
        label.text = "..."
        return label
    }()
    
    
    lazy var activityIndicator: UIActivityIndicatorView = {
       let ai = UIActivityIndicatorView()
        ai.style = .medium
        return ai
    }()
    
    let disposeBag = DisposeBag()
    let reactor = CounterReactor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind(reactor: reactor)
    }
    
    // MARK: ConfigureUI
    func configureUI() {
        
        view.backgroundColor = .systemBackground
        
        let stackView = UIStackView(arrangedSubviews: [decreaseButton, valueLabel, increaseButton])
        
        stackView.distribution = .fillEqually
        stackView.spacing = 80
        stackView.axis = .horizontal
        
        [stackView, activityIndicator].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            activityIndicator.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        
        ])
    }
    
    
    // MARK: Bind
    func bind(reactor: CounterReactor) {
        
        // Action
        decreaseButton.rx.tap
            .map { CounterReactor.Action.decrease }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        increaseButton.rx.tap
            .map { CounterReactor.Action.increase }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.value } // Int
            .distinctUntilChanged()
            .map{ "\($0)" } // String
            .bind(to: self.valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}
