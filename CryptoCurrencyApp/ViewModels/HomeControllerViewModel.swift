//
//  HomeControllerViewModel.swift
//  CryptoCurrencyApp
//
//  Created by Alexander Korchak on 12.04.2023.
//

import Foundation
import UIKit

class HomeControllerViewModel {
    
    var onCoinsUpdated: (() -> Void)?
    var onErrorMessage: ((CoinServiceError) -> Void)?
    var inSearchMode: Bool = false
    
    var coins: [Coin] {
        return self.inSearchMode ? filteredCoins : allCoins
    }
    
    var allCoins: [Coin] = [] {
        didSet {
            self.onCoinsUpdated?()
        }
    }
    
    var filteredCoins: [Coin] = []
    
    init()  {
        self.fetchData()
    }
    
    public func fetchData() {
        let endpoint = Endpoint.fetchCoins()
        CoinService.fetchData(with: endpoint) { [weak self]  result in
            switch result {
            case .success(let coins):
                self?.allCoins = coins
            case .failure(let error):
                self?.onErrorMessage?(error)
                print("Some error")
            }
        }
    }
    
//    public func fetchCoins() async {
//        let endpoint = Endpoint.fetchCoins()
//            do {
//                let loadedCoins = try await CoinService.fetchCoins(with: endpoint)
//                self.coins.append(contentsOf: loadedCoins)
//                print("Got \(coins.count)")
//            } catch  {
//                print("Error")
//            }
//    }
}

extension HomeControllerViewModel {
    
    public func setInSearchMode(_ searchController: UISearchController) {
        let isActive = searchController.isActive
        let searchText = searchController.searchBar.text ?? ""
        self.inSearchMode = isActive && !searchText.isEmpty
    }
    
    public func updateSearchController(searchBarText: String?) {
        self.filteredCoins = allCoins
        if let searchText = searchBarText?.lowercased() {
            guard !searchText.isEmpty else {
                self.onCoinsUpdated?()
                return
            }
            self.filteredCoins = self.filteredCoins.filter({ $0.name.lowercased().contains(searchText)})
        }
        self.onCoinsUpdated?()
    }
}
