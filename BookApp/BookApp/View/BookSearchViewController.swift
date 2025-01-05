//  BookSearchViewController.swift
//  BookApp
//
//  Created by 손겸 on 12/24/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

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
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BookCell")
        tableView.rowHeight = 60
    }
    
    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupBindings() {
        // 셀 선택 이벤트 처리
        tableView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                
                // 선택된 셀을 비활성화
                self.tableView.deselectRow(at: indexPath, animated: true)

                // 선택된 책 가져오기
                let searchResults = self.viewModel.searchResults.value
                guard indexPath.row < searchResults.count else {
                    print("Error: Index out of bounds for searchResults")
                    return
                }

                let selectedBook = searchResults[indexPath.row]
                print("Selected Book: \(selectedBook.title)") // 디버깅 로그

                // BookDetailViewController에 데이터 전달
                let bookDetailVC = BookDetailViewController()
                bookDetailVC.book = selectedBook
                bookDetailVC.modalPresentationStyle = .formSheet

                // 모달 표시
                self.present(bookDetailVC, animated: true) {
                    print("Presented BookDetailViewController for: \(selectedBook.title)")
                }
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

