//
//  CoinCell.swift
//  CryptoCurrencyApp
//
//  Created by Alexander Korchak on 09.04.2023.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

class CoinCell: UITableViewCell {
    
    private var coin: Coin?
    
    private lazy var coinLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        return imageView
    }()
    
    private lazy var coinName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    // MARK: - lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.coinName.text = nil
        self.coinLogo.image = nil
    }
    
    
    // MARK: - UI setup
    private func setupUI() {
        self.addSubview(coinLogo)
        self.addSubview(coinName)
        
        coinLogo.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(self.snp.leading).offset(20)
            make.width.height.equalTo(50).multipliedBy(0.75)
        }
        
        coinName.snp.makeConstraints { make in
            make.leading.equalTo(coinLogo.snp.trailing).offset(16)
            make.centerY.equalTo(self.snp.centerY)
            make.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    public func configure(with coin: Coin) {
        self.coin = coin
        self.coinName.text = coin.name
        self.coinLogo.sd_setImage(with: coin.logoURL)
    }
}
