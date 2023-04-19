//
//  ViewController.swift
//  CryptoCurrencyApp
//
//  Created by Alexander Korchak on 09.04.2023.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    private let viewModel: HomeControllerViewModel
    var allCoins: [Coin] = []
    
    private lazy var table: UITableView =  {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(CoinCell.self, forCellReuseIdentifier: CoinCell.reuseIdentifier)
        return table
    }()
    
    private lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = false
        search.searchBar.placeholder = "Search coins"
        search.searchBar.showsBookmarkButton = true
        search.searchBar.setImage(UIImage(systemName: "line.horizontal.3.decrease"), for: .bookmark, state: .normal)
        return search
    }()
    
    init(_ viewModel: HomeControllerViewModel = HomeControllerViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBlue
        self.table.delegate = self
        self.table.dataSource = self
        self.searchController.searchBar.delegate = self
        setupUI()
        setupSearchController()
        
        self.viewModel.onCoinsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.table.reloadData()
            }
        }
        self.viewModel.onErrorMessage = {
            [weak self] error in
                DispatchQueue.main.async {
                    self?.showErrorAlert(error: error)
                }
        }

//        Task {
//            let endpoint = Endpoint.fetchCoins()
//            do {
//                let loadedCoins = try await CoinService.fetchCoins(with: endpoint)
//                self.allCoins.append(contentsOf: loadedCoins)
//                await MainActor.run(body: {
//                self.table.reloadData()
//              })
//            } catch  {
//                viewModel.onErrorMessage = { [weak self] error in
//                    DispatchQueue.main.async {
//                        self?.showErrorAlert(error: error)
//                    }
//                }
//            }
//        }
    }
    
    func showErrorAlert(error: CoinServiceError) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        switch error {
        case .decodingError(let decodingError):
            alert.title = "Error parsing data"
            alert.message = decodingError
        case .serverError(let serverError):
            alert.title = "Server error \(serverError)"
            alert.message = serverError.errorMessage
        case .unknown(let string):
            alert.title = "Error fetching coins"
            alert.message = string
        }
       self.present(alert, animated: true)
    }

   private func setupUI() {
        self.view.addSubview(table)
        self.navigationItem.title = "iCrypto"
        table.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupSearchController() {
        self.navigationItem.searchController = self.searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinCell.reuseIdentifier, for: indexPath) as? CoinCell else {
            return UITableViewCell()
        }
    
        let coin = self.viewModel.coins[indexPath.row]
        cell.configure(with: coin)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         self.viewModel.coins.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coin = self.viewModel.coins[indexPath.row]
        let viewModel = ViewCryptoControllerViewModel(coin)
        let vc = ViewCryptoViewController(viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.viewModel.setInSearchMode(searchController)
        self.viewModel.updateSearchController(searchBarText: searchController.searchBar.text)
    }

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    
}
