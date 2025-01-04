//  BookSearchViewController.swift
//  BookApp
//
//  Created by 손겸 on 12/24/24.
//

import UIKit
import SnapKit
import RxSwift

class BookSearchViewController: UIViewController, UISearchBarDelegate {
    // MARK: - Properties
    var viewModel: BookSearchViewModel
    var coreDataManager: CoreDataManager

    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "책 검색해보기"
        searchBar.sizeToFit()
        return searchBar
    }()

    private var tableView = UITableView()
    private var recentBooks: [KakaoBook] = [] // 최근 본 책
    private var searchResults: [KakaoBook] = [] // 검색 결과
    private let disposeBag = DisposeBag()

    // MARK: - Initializer
    init(viewModel: BookSearchViewModel, coreDataManager: CoreDataManager) {
           self.viewModel = viewModel
           self.coreDataManager = coreDataManager
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
        searchBar.delegate = self  // UISearchBarDelegate 설정
        setupBindings()
        
        // searchBar.text = "검색해보자~"
        searchBar.becomeFirstResponder()
        searchBar.autocapitalizationType = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        //navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        [
            searchBar, tableView
        ].forEach { view.addSubview($0) }
        
        setupSearchBarConstraints()
        setupTableViewConstraints()
    }
    
    private func setupSearchBarConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
    
    private func setupTableViewConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BookCell")
        tableView.rowHeight = 60
    }
    
    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupBindings() {
        // Search Bar 텍스트를 ViewModel의 searchQuery에 바인딩
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.searchQuery)
            .disposed(by: disposeBag)
        
        // ViewModel의 searchResults를 TableView와 바인딩
        viewModel.searchResults
            .bind(to: tableView.rx.items(cellIdentifier: "BookCell")) { index, book, cell in
                cell.textLabel?.text = book.title
                cell.detailTextLabel?.text = book.authors.joined(separator: ", ")
            }
            .disposed(by: disposeBag)
        
        // 최근 본 책을 ViewModel의 recentBooks와 바인딩
        viewModel.recentBooks
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Search Bar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search text changed: \(searchText)")
        
        // 텍스트가 비었을 경우
        guard !searchText.isEmpty else {
            searchResults = []
            tableView.reloadData()
            return
        }
        
        // 일정 길이 이상의 텍스트일 경우 API 호출
        if searchText.count >= 2 {
            APIManager.shared.fetchBooks(query: searchText)
                .observe(on: MainScheduler.instance)
                .subscribe(onSuccess: { [weak self] books in
                    guard let self = self else { return }
                    print("Fetched books: \(books)")
                    
                    // 실제 API에서 받은 데이터를 업데이트
                    self.searchResults = books
                    self.tableView.reloadData()
                }, onFailure: { error in
                    print("Error fetching books: \(error.localizedDescription)")
                })
                .disposed(by: disposeBag)
        } else {
            searchResults = []
            tableView.reloadData()
        }
    }
}


// MARK: - UITableViewDataSource
extension BookSearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? recentBooks.count : searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath)
        cell.textLabel?.font = .systemFont(ofSize: 15)
        
        if indexPath.section == 0 {
            // 최근 본 책은 KakaoBook 배열을 사용해야 하므로, title을 표시
            let book = recentBooks[indexPath.row]
            cell.textLabel?.text = book.title
        } else {
            // 검색 결과
            guard indexPath.row < searchResults.count else {
                // 인덱스가 범위를 벗어난 경우
                return cell
            }
            let book = searchResults[indexPath.row]
            cell.textLabel?.text = book.title
            cell.detailTextLabel?.text = book.authors.joined(separator: ", ")
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "최근 본 책" : "검색 결과"
    }
}

// MARK: - UITableViewDelegate
extension BookSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let bookDetailVC = BookDetailViewController()
        
        if indexPath.section == 0 {
            let selectedBook = recentBooks[indexPath.row]
            bookDetailVC.book = selectedBook
        } else {
            let selectedBook = searchResults[indexPath.row]
            bookDetailVC.book = selectedBook
        }
        
        bookDetailVC.modalPresentationStyle = .formSheet
        present(bookDetailVC, animated: true, completion: nil)
    }
}

