//
//  CoinService.swift
//  CryptoCurrencyApp
//
//  Created by Alexander Korchak on 12.04.2023.
//

import Foundation

enum CoinServiceError: Error {
    case serverError(CoinError)
    case unknown(String = "Unknown error occured")
    case decodingError(String = "Error passing server response")
}

class CoinService {
    
    static func fetchData(with endpoint: Endpoint, completion: @escaping (Result<[Coin], CoinServiceError>) -> Void) {
        guard let request = endpoint.request else {
            return
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.unknown(error.localizedDescription)))
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                do {
                    let coinError = try JSONDecoder().decode(CoinError.self, from: data ?? Data())
                    completion(.failure(.serverError(coinError)))
                } catch let error {
                    completion(.failure(.unknown()))
                    print(error.localizedDescription)
                }
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let coinData = try decoder.decode(CoinArray.self, from: data).data
                    completion(.success(coinData))
                } catch let error {
                    completion(.failure(.decodingError()))
                    print(error.localizedDescription)
                }
            } else {
                completion(.failure(.unknown()))
            }
        }.resume()
    }

    static func fetchCoins(with endpoint: Endpoint) async throws -> [Coin] {
        guard let request = endpoint.request else {
            throw CoinServiceError.unknown()
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw CoinServiceError.unknown()
        }
        let decoder = JSONDecoder()
        let coin = try decoder.decode(CoinArray.self, from: data).data
        return coin
    }
}

