//
//  ViewCryptoViewController.swift
//  CryptoCurrencyApp
//
//  Created by Alexander Korchak on 09.04.2023.
//

import UIKit
import SnapKit
import SDWebImage

class ViewCryptoViewController: UIViewController {
    
    let viewModel: ViewCryptoControllerViewModel
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private let contentView: UIView = {
        let content = UIView()
        return content
    }()
    
    private lazy var coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        imageView.image = UIImage(systemName: "heart.fill")
        return imageView
    }()
    
    private lazy var rankLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.text = "Error"
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.text = "Error"
        return label
    }()
    
    private lazy var marketCapLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.text = "Error"
        return label
    }()
    
    private lazy var maxSupplyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 100
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [rankLabel,
                                                   priceLabel,
                                                   marketCapLabel,
                                                   maxSupplyLabel])
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()
    
    init(_ viewModel: ViewCryptoControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.navigationItem.title = self.viewModel.coin.name
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: nil, action: nil)
        self.rankLabel.text = self.viewModel.rankLabel.description
        self.priceLabel.text = self.viewModel.priceLabel.description
        self.marketCapLabel.text = self.viewModel.marketCapLabel.description
        self.maxSupplyLabel.text = self.viewModel.maxSupplyLabel.description
        self.coinImageView.sd_setImage(with: self.viewModel.coin.logoURL)
        setupUI()
       
    }
    
    private func setupUI() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        self.contentView.addSubview(coinImageView)
        self.contentView.addSubview(stack)
        
        let height = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        height.priority = UILayoutPriority(1)
        height.isActive = true
        
        scrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            
        }
        
        coinImageView.snp.makeConstraints { make in
            make.centerX.equalTo(self.scrollView.snp.centerX)
            make.top.equalTo(self.contentView.snp.top).offset(40)
            make.leading.equalTo(self.scrollView.snp.leading).offset(100)
            make.trailing.equalTo(self.scrollView.snp.trailing).offset(-100)
            make.height.equalTo(200)
        }
        
        stack.snp.makeConstraints { make in
            make.top.equalTo(coinImageView.snp.bottom).offset(16)
            make.centerX.equalTo(self.scrollView.snp.centerX)
            make.leading.equalTo(self.scrollView.snp.leading).offset(16)
            make.trailing.equalTo(self.scrollView.snp.trailing).offset(-16)
            make.height.equalTo(150)
        }
    }
}
