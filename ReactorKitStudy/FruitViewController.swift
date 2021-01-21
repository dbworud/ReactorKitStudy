//
//  FruitViewController.swift
//  ReactorKitStudy
//
//  Created by jaekyung you on 2021/01/21.
//

import UIKit
import ReactorKit
import RxCocoa

class FruitViewController: UIViewController {
    
    // MARK: Properties
    private lazy var appleButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("사과", for: .normal)
        return btn
    }()
    
    private lazy var bananaButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("바나나", for: .normal)
        return btn
    }()
    
    private lazy var grapesButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("포도", for: .normal)
        return btn
    }()
    
    private lazy var selecteLabel: UILabel = {
       let label = UILabel()
        label.text = "선택되어진 과일 없음"
        return label
    }()

    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [appleButton, bananaButton, grapesButton, selecteLabel])
        stack.axis = .vertical
        stack.spacing = 20
        return stack
        
    }()
    
    // MARK: Binding Properties
    let disposeBag = DisposeBag()
    let fruitReactor = FruitReactor()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        bind(reactor: fruitReactor)
    }
    
    // MARK: Configure UI
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: Helpers
    func bind(reactor: FruitReactor) {
        appleButton.rx.tap.map { // Whenever appleButton tapped
            FruitReactor.Action.apple // get value from stream
        }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        bananaButton.rx.tap.map { // Whenever appleButton tapped
            FruitReactor.Action.banana // get value from stream
        }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        grapesButton.rx.tap.map { // Whenever appleButton tapped
            FruitReactor.Action.grapes // get value from stream
        }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        
        reactor.state.map { $0.fruitName }
            .distinctUntilChanged()
            .map { $0 }
            .subscribe(onNext: { val in
                self.selecteLabel.text = val
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isLoading }
            .distinctUntilChanged()
            .map{ $0 }
            .subscribe(onNext: { val in
                if val == true {
                    self.selecteLabel.text = "로딩중입니다"
                }
            })
            .disposed(by: disposeBag)
    }
}
