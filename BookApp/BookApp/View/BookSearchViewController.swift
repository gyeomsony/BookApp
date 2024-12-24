//
//  BookSearchViewController.swift
//  BookApp
//
//  Created by 손겸 on 12/24/24.
//

import UIKit
import SnapKit

class BookSearchViewController: UIViewController, UISearchBarDelegate {
    
    // searchBar는 이 프로퍼티로 선언되어 직접 초기화
    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "책 검색"
        searchBar.sizeToFit()
        return searchBar
    }()
    
    private let tableView: UITableView
    private var books: [String]
    private var filteredBooks: [String]
    
    // 초기화
    init(books: [String]) {
        self.books = books
        self.filteredBooks = books
        
        self.tableView = UITableView()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupNavigationBar()
        searchBar.delegate = self
    }
    
    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "책 검색"
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        [searchBar, tableView].forEach { view.addSubview($0) }
        
        // 서치바 제약 조건
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        // 테이블 뷰 제약 조건
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BookCell")
        tableView.rowHeight = 60
    }
    
    // 서치바의 텍스트 변경에 따라 책 목록 필터링
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredBooks = books
        } else {
            filteredBooks = books.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension BookSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath)
        cell.textLabel?.text = filteredBooks[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension BookSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedBook = filteredBooks[indexPath.row]
        print("\(selectedBook)을 선택함")
    }
}
