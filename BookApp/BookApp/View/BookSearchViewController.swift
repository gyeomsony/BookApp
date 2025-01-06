//  BookSearchViewController.swift
//  BookApp
//
//  Created by 손겸 on 12/24/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BookSearchViewController: UIViewController {
    // MARK: - Properties
    var viewModel: BookSearchViewModel
    var coreDataManager: CoreDataManager
    private let disposeBag = DisposeBag()

    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "책 검색해보기"
        return searchBar
    }()
    
    private var tableView = UITableView()

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
        setupBindings()
        searchBar.becomeFirstResponder()
        searchBar.autocapitalizationType = .none
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("TableView Frame: \(tableView.frame)") // 레이아웃 디버깅
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(tableView)

        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BookCell")
        tableView.rowHeight = 60
    }

    private func setupBindings() {
        // 검색 결과 바인딩
        viewModel.searchResults
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "BookCell")) { index, book, cell in
                cell.textLabel?.text = book.title
                cell.detailTextLabel?.text = book.authors.joined(separator: ", ")
            }
            .disposed(by: disposeBag)

        // 셀 선택 이벤트 처리
        tableView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
                let selectedBook = self.viewModel.searchResults.value[indexPath.row]
                let bookDetailVC = BookDetailViewController()
                bookDetailVC.book = selectedBook
                bookDetailVC.modalPresentationStyle = .formSheet
                self.present(bookDetailVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        // 검색어 입력 바인딩
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.searchQuery)
            .disposed(by: disposeBag)
    }
}
