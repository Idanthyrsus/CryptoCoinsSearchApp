//
//  ViewCryptoControllerViewModel.swift
//  CryptoCurrencyApp
//
//  Created by Alexander Korchak on 12.04.2023.
//

import Foundation
import UIKit

class ViewCryptoControllerViewModel {
    
    let coin: Coin
    
    init(_ coin: Coin) {
        self.coin = coin
    }
    
    // MARK: - computed properties
    
    var rankLabel: String {
        return "Rank: \(self.coin.rank)"
    }
    
    var priceLabel: String {
        return "Price: $\(self.coin.pricingData.CAD.price)"
    }
    
    var marketCapLabel: String {
        return "Market Cap: $\(self.coin.pricingData.CAD.market_cap)"
    }
    
    var maxSupplyLabel: String {
        if let maxSuplly = self.coin.maxSupply {
            return "Max Supply: \(maxSuplly)"
        } else {
            return ""
        }
    }
}
