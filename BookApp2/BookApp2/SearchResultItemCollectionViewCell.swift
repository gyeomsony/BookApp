//
//  SearchResultItemCollectionViewCell.swift
//  BookApp2
//
//  Created by 손겸 on 1/6/25.
//

import UIKit

class SearchResultItemCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "SearchResultItemCollectionViewCell"
    
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let priceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
        self.makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabelText(title: String,
                      authors: [String],
                      price: Int) {
        self.titleLabel.text = title
        self.authorLabel.text = authors.joined(separator: ",")
        self.priceLabel.text = "\(price)원"
    }
    
    private func configureUI() {
        [
            titleLabel,
            authorLabel,
            priceLabel
        ].forEach { self.contentView.addSubview($0) }
        
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        
        authorLabel.font = .systemFont(ofSize: 16)
        authorLabel.textColor = .systemGray
        
        priceLabel.font = .systemFont(ofSize: 16)
        priceLabel.textColor = .red
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(10)
        }
        
        authorLabel.snp.makeConstraints {
            $0.verticalEdges.equalTo(titleLabel)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(5)
        }
        
        priceLabel.snp.makeConstraints {
            $0.verticalEdges.equalTo(authorLabel)
            $0.leading.equalTo(authorLabel.snp.trailing).offset(5)
            $0.trailing.equalToSuperview().inset(15)
        }
    }
}
