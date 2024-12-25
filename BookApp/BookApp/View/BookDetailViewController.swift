//
//  BookDetailViewController.swift
//  BookApp
//
//  Created by 손겸 on 12/24/24.
//

import UIKit
import SnapKit

class BookDetailViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목 없음"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.text = "작가: 알 수 없음"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    private let bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "12,000원"
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 7
        label.text = """
어느 날 갑자기 출현한 정체불명의 식인종 거인들에 의해 인류의 태반이 잡아 먹히며 인류는 절멸 위기에 처한다.
목숨을 부지한 생존자들은 높이 50m의 거대한 삼중의 방벽 월 마리아, 월 로제, 월 시나를 건설하여 그 곳으로 도피, 방벽 내부에서 100여 년에 걸쳐 평화의 시대를 영위하게 된다.
그리고 100여 년이 지난 845년, 대부분 주민들이 오래도록 지속되어 온 평화에 안주하는 반면, 주인공 엘런 예거는 사람들이 거인들에게 둘러싸여 벽 안에서 가축같이 살아가는 세계에 커다란 불만을 느낀다. 그는 벽 밖의 세계로 나가서 세계를 자유롭게 누비며 탐험하는 것을 열망한다. 
"""
        label.font = .systemFont(ofSize: 13)
        label.textColor = .black
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .justified
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("장바구니", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 15
        button.backgroundColor = .systemBlue
        return button
    }()
    // 더보기
    private let moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("더보기", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    private var isExpanded = false // 텍스트 확장 되었는지 확인
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        [
            titleLabel,
            authorLabel,
            bookImageView,
            priceLabel,
            descriptionLabel,
            moreButton,
            addButton
        ].forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        authorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        bookImageView.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(300)
            $0.width.equalTo(200)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(bookImageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        moreButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        addButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(50)
        }
    }
    
    // 액션 설정 함수 만들어서 addAction 편하게 사용하기
    func toggleDescriptionAction(action: UIAction) {
        self.toggleDescription()
    }

    func addBookAction(action: UIAction) {
        self.addBook()
    }
    
    private func setupActions() {
        moreButton.addAction(UIAction(handler: toggleDescriptionAction), for: .touchUpInside)
        addButton.addAction(UIAction(handler: addBookAction), for: .touchUpInside)
    }


    
    @objc private func toggleDescription() {
        isExpanded.toggle()

        // 텍스트가 확장되면, 전체 텍스트를 보여주고 "더보기" 버튼 텍스트를 변경
        if isExpanded {
            descriptionLabel.numberOfLines = 0
            moreButton.setTitle("닫기", for: .normal)
        } else {
            descriptionLabel.numberOfLines = 7
            moreButton.setTitle("더보기", for: .normal)
        }
    }
    
    // 우선 그냥 해놓기
    @objc private func addBook() {
        print("책이 담겼습니다.")
    }
}
