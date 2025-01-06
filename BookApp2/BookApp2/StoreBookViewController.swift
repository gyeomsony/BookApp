//
//  StoreBookViewController.swift
//  BookApp2
//
//  Created by 손겸 on 1/6/25.
//

import UIKit
import Then

class StoreBookViewController: UIViewController {
    
    private let titleLabel = UILabel().then {
        $0.text = "담은 책"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    private let deleteAllbutton = UIButton(type: .system).then {
        $0.setTitle("전체 삭제", for: .normal)
        $0.setTitleColor(.systemGray, for: .normal)
    }
    
    private let addButton = UIButton(type: .system).then {
        $0.setTitle("추가", for: .normal)
        $0.setTitleColor(.systemPink, for: .normal)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.tabBarItem = UITabBarItem(title: "Store",
                                       image: UIImage(systemName: "books.vertical"),
                                       tag: 0)
        self.view.backgroundColor = .white
    }
    
    private lazy var listCollectionView = UICollectionView(frame: .zero,
                                                                      collectionViewLayout: self.createLayout())
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.makeConstraints()
    }
    
    private func configureUI() {
        [
            titleLabel,
            deleteAllbutton,
            addButton,
            listCollectionView
        ].forEach { self.view.addSubview($0) }
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
        }
        deleteAllbutton.snp.makeConstraints {
            $0.top.equalTo(titleLabel)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide).inset(16)
        }
        addButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(16)
        }
        listCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

extension StoreBookViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}
