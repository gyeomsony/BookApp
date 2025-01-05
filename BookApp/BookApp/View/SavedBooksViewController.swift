//
//  SavedBooksViewController.swift
//  BookApp
//
//  Created by 손겸 on 12/24/24.
//

import UIKit
import SnapKit

class SavedBooksViewController: UIViewController {

    private let tableView = UITableView()
    private let viewModel: SavedBooksViewModel
    
    init(viewModel: SavedBooksViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        setupTableView()
        viewModel.loadBooks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadBooks()
        tableView.reloadData() // 데이터 리로드
    }
    
    private func setupUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        [
            titleLabel,
            deleteAllButton,
            tableView
        ].forEach { view.addSubview($0) }
        
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
        
        deleteAllButton.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.deleteAllBooks()
            self?.tableView.reloadData()
        }), for: .touchUpInside)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BookCell")
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // BookEntity → KakaoBook 변환
        let selectedBookEntity = viewModel.savedBooks.value[indexPath.row]
        let selectedBook = KakaoBook(entity: selectedBookEntity)
        
        // BookDetailViewController로 전달
        let bookDetailVC = BookDetailViewController()
        bookDetailVC.book = selectedBook
        bookDetailVC.modalPresentationStyle = .formSheet
        present(bookDetailVC, animated: true, completion: nil)
    }

}
