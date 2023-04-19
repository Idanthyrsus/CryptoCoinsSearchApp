//
//  ReuseIdentifiable.swift
//  CryptoCurrencyApp
//
//  Created by Alexander Korchak on 09.04.2023.
//

import Foundation
import UIKit

protocol ReuseIdentifiable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UIView: ReuseIdentifiable {
    
}
