//
//  Book.swift
//  BookApp
//
//  Created by 손겸 on 12/24/24.
//

import UIKit

class BookCell: UICollectionViewCell {
    
    public var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .lightGray
        
        // titleLabel을 contentView에 추가해야 함
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

