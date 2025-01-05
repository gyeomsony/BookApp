//
//  BookDetailViewController.swift
//  BookApp
//
//  Created by 손겸 on 12/24/24.
//

import UIKit
import SnapKit

class BookDetailViewController: UIViewController {
    
    var book: KakaoBook?
    
    private var viewModel: BookDetailViewModel!
    private let scrollView = UIScrollView() // 스크롤 뷰
    private let contentView = UIView()
    
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
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
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
        label.text = "설명 없음"
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
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("X", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 15
        button.backgroundColor = .lightGray
        return button
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("더보기", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    private var isExpanded = false // 텍스트 확장 여부 확인
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViewModel()
        setupUI()
        setupActions()
        populateUI() // 실제 데이터
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.showsVerticalScrollIndicator = false
        
        // 콘텐츠뷰에 서브뷰 추가
        [
            titleLabel,
            authorLabel,
            bookImageView,
            priceLabel,
            descriptionLabel,
            moreButton,
            addButton,
            closeButton,
            buttonStackView
        ].forEach { contentView.addSubview($0) }
        
        // 스택뷰
        [
            closeButton,
            addButton
        ].forEach { buttonStackView.addArrangedSubview($0) }
        
        // 콘텐츠뷰 내부 레이아웃 설정
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(30)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        authorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        bookImageView.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(420)
            $0.width.equalTo(300)
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
            $0.width.equalTo(270)
            $0.height.equalTo(50)
        }
        
        closeButton.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(50)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(moreButton.snp.bottom).offset(60)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalTo(contentView.snp.bottom).inset(40)
            $0.height.equalTo(50)
        }
        
        // 스크롤뷰와 콘텐츠뷰 레이아웃
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    private func setupActions() {
        moreButton.addAction(UIAction(handler: { [weak self] _ in
            self?.toggleDescription()
        }), for: .touchUpInside)
        
        addButton.addAction(UIAction(handler: { [weak self] _ in
            self?.addBook()
        }), for: .touchUpInside)
        
        closeButton.addAction(UIAction(handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }), for: .touchUpInside)
    }
    
    private func setupViewModel() {
        viewModel = BookDetailViewModel(
            coreDataManager: CoreDataManager.shared,
            bookTitle: book?.title ?? "제목 없음",
            bookAuthor: book?.authors.first ?? "알수 없음",
            bookDescription: book?.contents ?? "설명 없음",
            bookImage: nil,
            bookPrice: book?.price ?? 0
        )
    }
    
    private func toggleDescription() {
        isExpanded.toggle()
        descriptionLabel.numberOfLines = isExpanded ? 0 : 7 // 삼항연산자 활용
        moreButton.setTitle(isExpanded ? "닫기" : "더보기", for: .normal)
    }
    
    private func addBook() {
        // 코어데이터 책 추가
        guard let book = book else { return }
        CoreDataManager.shared.addBook(title: book.title, author: book.authors.first ?? "모름", image: nil, price: book.price ?? 0)
        
        // 모달 닫기
        dismiss(animated: true) { [weak self] in
            // 탭바의 두 번째 탭(장바구니)으로 이동
            if let tabBarController = UIApplication.shared.windows.first?.rootViewController as? UITabBarController {
                tabBarController.selectedIndex = 1
            }
        }
        
        print("책이 담겼습니다.")
    }
    
    private func populateUI() {
        guard let book = book else {
            print("Error: Book data is nil")
            return
        }
        print("Populating UI with book: \(book.title)")
        
        titleLabel.text = book.title
        authorLabel.text = "저자: \(book.authors.joined(separator: ", "))"
        priceLabel.text = book.price != nil ? "가격: \(book.price!)원" : "가격 정보 없음"
        descriptionLabel.text = book.contents ?? "설명 없음"

        if let thumbnail = book.thumbnail, let url = URL(string: thumbnail) {
            loadImage(from: url)
        } else {
            bookImageView.image = UIImage(named: "defaultImage")
        }
    }

    private func loadImage(from url: URL) {
        // 비동기적으로 이미지를 다운로드하여 UIImageView에 설정
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("이미지 로딩 실패: \(error.localizedDescription)")
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.bookImageView.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self?.bookImageView.image = UIImage(named: "defaultImage") // 기본 이미지
                }
            }
        }
        
        task.resume()
    }
}

