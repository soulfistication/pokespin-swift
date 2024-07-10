//
//  UIViewExtensions.swift
//  PokeSpin
//
//  Created by Ivan Almada on 7/10/24.
//  Copyright © 2024 Ivan. All rights reserved.
//

import UIKit

extension UIView {
    func recursiveDescription(depth: Int) -> String {
        guard subviews.count > 0 else { return "\t|--\(head())>\n" }
        let str = (depth == 0) ? "\(head())>\n" : "\t|--\(head())>\n"
        return subviews.reduce(str) { $0 + $1.recursiveDescription(depth: depth + 1) }
    }

    func head() -> String {
        let lastIndex = description.index(description.startIndex, offsetBy: 20)
        return description.substring(to: lastIndex)
    }
}
