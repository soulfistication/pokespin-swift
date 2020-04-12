//
//  PokemonCollectionViewCell.swift
//  PokeSpin
//
//  Created by Ivan Almada on 18/01/2018.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

class PokemonCollectionViewCell: UICollectionViewCell {

    @IBOutlet var cellLabel: UILabel!
    @IBOutlet var cellImageView: UIImageView!

    // MARK: - UICollectionViewCell

    func prepareForDisplay(with text:String?, image imageName: String?) {
        setupUI()

        if let text = text {
            cellLabel.text = text
            cellImageView.image = nil
        } else if let name = imageName {
            cellLabel.text = nil
            cellImageView.image = UIImage(named: name)
        }

    }

    // MARK: - Setup UI

    func setupUI() {
        contentView.backgroundColor = UIColor.creamyBlue
        contentView.layer.cornerRadius = 5.0
    }

}
