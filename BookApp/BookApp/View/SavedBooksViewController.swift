//
//  SavedBooksViewController.swift
//  BookApp
//
//  Created by 손겸 on 12/24/24.
//

import UIKit
import SnapKit
import RxSwift

class SavedBooksViewController: UIViewController {
    
    private let tableView = UITableView()
    private let disposeBag = DisposeBag()
    private let viewModel = SavedBooksViewModel(coreDataManager: CoreDataManager.shared,
                                                apiManager: APIManager.shared)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "담은책"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    private let deleteAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("전체삭제", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitleColor(.systemRed, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
    }
    
    private func setupUI() {
        // 네비게이션 바 숨기기
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // UI 요소 추가
        [
            titleLabel,
            deleteAllButton,
            tableView
        ].forEach { view.addSubview($0) }
        
        // 레이아웃 설정
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(70)
            $0.centerX.equalToSuperview()
        }
        
        deleteAllButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(73)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(deleteAllButton.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        // 테이블뷰 설정
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BookCell")
        
        // 버튼 액션
        deleteAllButton.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.deleteAllBooks()
        }), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        viewModel.savedBooks
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] books in
                self?.tableView.reloadData()
            })
            .disposed(by: DisposeBag())
    }
}
    
    extension SavedBooksViewController: UITableViewDataSource, UITableViewDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.savedBooks.value.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath)
            let book = viewModel.savedBooks.value[indexPath.row]
            cell.textLabel?.text = book.title
            return cell
        }
    }

