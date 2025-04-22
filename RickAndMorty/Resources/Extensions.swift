//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Razumov Pavel on 22.04.2025.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
