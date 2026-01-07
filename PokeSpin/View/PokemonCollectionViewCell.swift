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
            cellLabel.text = "#\(text)"
            cellLabel.font = UIFont.boldSystemFont(ofSize: 16)
            cellLabel.textColor = .darkGray
            cellImageView.image = nil
            cellImageView.backgroundColor = .systemGray5
            // Add lock icon overlay
            addLockOverlay()
        } else if let name = imageName {
            cellLabel.text = nil
            cellImageView.image = UIImage(named: name)
            cellImageView.backgroundColor = .clear
            removeLockOverlay()
        }

    }

    // MARK: - Setup UI

    func setupUI() {
        contentView.backgroundColor = UIColor.creamyBlue
        contentView.layer.cornerRadius = 8.0
        contentView.layer.borderWidth = 2.0
        contentView.layer.borderColor = UIColor.systemBlue.cgColor
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOpacity = 0.1
        
        cellImageView.contentMode = .scaleAspectFit
        cellImageView.layer.cornerRadius = 6.0
        cellImageView.clipsToBounds = true
    }
    
    private func addLockOverlay() {
        // Remove existing lock if any
        removeLockOverlay()
        
        let lockImageView = UIImageView(image: UIImage(systemName: "lock.fill"))
        lockImageView.tag = 999
        lockImageView.tintColor = .systemGray
        lockImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(lockImageView)
        
        NSLayoutConstraint.activate([
            lockImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            lockImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            lockImageView.widthAnchor.constraint(equalToConstant: 30),
            lockImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func removeLockOverlay() {
        contentView.subviews.forEach { subview in
            if subview.tag == 999 {
                subview.removeFromSuperview()
            }
        }
    }

}
