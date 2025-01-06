//
//  SearchResultCollectionReusableView.swift
//  BookApp2
//
//  Created by 손겸 on 1/6/25.
//

import UIKit
import Then

class SearchResultCollectionReusableView: UICollectionReusableView {
        
    static let reuseIdentifier = "SearchResultCollectionReusableView"
    
    private let titleLabel = UILabel().then {
        $0.text = "검색 결과"
        $0.font = .systemFont(ofSize: 30, weight: .black)
        $0.textAlignment = .left
    }
    
    private func configureUI() {
        self.backgroundColor = .white
        self.addSubview(titleLabel)
    }
    
    private func makeConstraints() {
        
        self.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        self.titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview()        }
    }
}
