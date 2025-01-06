//
//  SearchBookViewController.swift
//  BookApp2
//
//  Created by 손겸 on 1/6/25.
//

import UIKit
import SnapKit

class SearchBookViewController: UIViewController {
    
    private var resultItems: [Book] = []
    
    private let searchBar = UISearchBar()
    
    private(set) lazy var searchListCollectionView = UICollectionView(frame: .zero,
                                                                      collectionViewLayout: self.createLayout())
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.tabBarItem = UITabBarItem(title: "Search",
                                       image: UIImage(systemName: "magnifyingglass"),
                                       tag: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.makeConstraints()
    }
    
    private func configureUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(searchBar)
        self.view.addSubview(searchListCollectionView)
        
        searchBar.delegate = self
        
        searchListCollectionView.dataSource = self
        
        searchListCollectionView.register(SearchResultItemCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultItemCollectionViewCell.reuseIdentifier)
        
        searchListCollectionView.register(SearchResultCollectionReusableView.self,
                                          forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                          withReuseIdentifier: SearchResultCollectionReusableView.reuseIdentifier)
    }
    
    private func makeConstraints() {
        self.searchBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.searchListCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

extension SearchBookViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.resultItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultItemCollectionViewCell.reuseIdentifier, for: indexPath) as! SearchResultItemCollectionViewCell
        
        let book = self.resultItems[indexPath.row]
        
        cell.setLabelText(title: book.title,
                          authors: book.authors,
                          price: book.price)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                               withReuseIdentifier: SearchResultCollectionReusableView.reuseIdentifier,
                                                               for: indexPath)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}

extension SearchBookViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        let keyword = searchBar.text ?? ""
        
        var components = URLComponents(string: "https://dapi.kakao.com/v3/search/book")
        
        components?.queryItems = [
            URLQueryItem(name: "query", value: keyword),
            URLQueryItem(name: "size", value: "20"),
        ]
        
        guard let url = components?.url else { return }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.allHTTPHeaderFields = [
            "Authorization" : "Authorization: KakaoAK 3a4facecbe99c3bf5eab0a5480368bd5"
        ]
    }
}
