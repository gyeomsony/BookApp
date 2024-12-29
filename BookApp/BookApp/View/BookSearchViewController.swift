//  BookSearchViewController.swift
//  BookApp
//
//  Created by 손겸 on 12/24/24.
//

import UIKit
import SnapKit

class BookSearchViewController: UIViewController, UISearchBarDelegate {
    // MARK: - Properties
    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "책 검색해보기"
        searchBar.sizeToFit()
        return searchBar
    }()
    
    private let tableView: UITableView
    private var recentBooks: [String]
    private var searchResults: [String]
    private var books: [String] = []
    
    // MARK: - Initializer
    init(recentBooks: [String], searchResults: [String], books: [String]) {
        self.recentBooks = recentBooks
        self.searchResults = searchResults
        self.books = books
        self.tableView = UITableView()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupNavigationBar()
        searchBar.delegate = self
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        [
            searchBar,
            tableView
        ].forEach { view.addSubview($0) }
        
        setupSearchBarConstraints()
        setupTableViewConstraints()
    }
    
    private func setupSearchBarConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(70)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
    
    private func setupTableViewConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    // MARK: - TableView Setup
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BookCell")
        tableView.rowHeight = 60
    }
    
    // MARK: - Navigation Bar
    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Search Bar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchResults = [] // 검색어가 없으면 결과 비우기
        } else {
            // 검색어가 있을 경우 최근 책을 필터링하여 검색 결과 업데이트
            searchResults = recentBooks.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData() // 검색 결과 변경 후 테이블 뷰 리로드
    }
}

// MARK: - UITableViewDataSource
extension BookSearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return recentBooks.count
        } else {
            return searchResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath)
        let book = indexPath.section == 0 ? recentBooks[indexPath.row] : searchResults[indexPath.row]
        cell.textLabel?.text = book
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "최근 본 책"
        } else {
            return "검색 결과"
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel()
        headerLabel.text = section == 0 ? "최근 본 책" : "검색 결과"
        headerLabel.font = UIFont.boldSystemFont(ofSize: 18)
        headerLabel.backgroundColor = .white
        return headerLabel
    }
}

// MARK: - UITableViewDelegate
extension BookSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedBook = indexPath.section == 0 ? recentBooks[indexPath.row] : searchResults[indexPath.row]
        print("\(selectedBook)을 선택함")
        
        let bookDetailVC = BookDetailViewController()
        bookDetailVC.modalPresentationStyle = .formSheet
        present(bookDetailVC, animated: true, completion: nil)
    }
}
