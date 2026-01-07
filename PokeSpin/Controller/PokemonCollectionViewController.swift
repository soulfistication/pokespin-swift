//
//  PokemonCollectionViewController.swift
//  PokeSpin
//
//  Created by Ivan Almada on 18/01/2018.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

class PokemonCollectionViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ScreenDismissable {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    private let gameStats = GameStats.shared
    private var progressLabelFallback: UILabel?
    private var progressBarFallback: UIProgressView?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setup UI

    func setupUI() {
        title = "Pokédex"
        updateProgress()
        
        // Style progress bar
        progressBar.progressTintColor = .systemGreen
        progressBar.trackTintColor = .lightGray
        progressBar.layer.cornerRadius = 4
        progressBar.clipsToBounds = true
        
        // Add navigation bar button for stats
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Stats",
            style: .plain,
            target: self,
            action: #selector(showStats)
        )
    }
    
    func updateProgress() {
        let progress = gameStats.collectionProgress / 100.0
        let unlockedCount = PokemonManager.fetchPokemons().filter { $0.isUnlocked }.count
        let progressText = "Collection: \(unlockedCount)/\(Constants.numberOfPokemonsDisplayed) (\(String(format: "%.0f", gameStats.collectionProgress))%)"
        
        if let progressBar = progressBar {
            progressBar.setProgress(Float(progress), animated: true)
        } else {
            // Create fallback progress bar if not in storyboard
            if progressBarFallback == nil {
                let bar = UIProgressView(progressViewStyle: .default)
                bar.translatesAutoresizingMaskIntoConstraints = false
                bar.progressTintColor = .systemGreen
                bar.trackTintColor = .lightGray
                bar.layer.cornerRadius = 4
                bar.clipsToBounds = true
                view.addSubview(bar)
                NSLayoutConstraint.activate([
                    bar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                    bar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    bar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                    bar.heightAnchor.constraint(equalToConstant: 8)
                ])
                progressBarFallback = bar
            }
            progressBarFallback?.setProgress(Float(progress), animated: true)
        }
        
        if let progressLabel = progressLabel {
            progressLabel.text = progressText
            progressLabel.font = UIFont.boldSystemFont(ofSize: 16)
            progressLabel.textColor = .darkGray
        } else {
            // Create fallback label if not in storyboard
            if progressLabelFallback == nil {
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.font = UIFont.boldSystemFont(ofSize: 16)
                label.textColor = .darkGray
                label.textAlignment = .center
                view.addSubview(label)
                let bar = progressBarFallback ?? progressBar
                if let bar = bar {
                    NSLayoutConstraint.activate([
                        label.topAnchor.constraint(equalTo: bar.bottomAnchor, constant: 8),
                        label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                    ])
                } else {
                    NSLayoutConstraint.activate([
                        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
                        label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                    ])
                }
                progressLabelFallback = label
            }
            progressLabelFallback?.text = progressText
        }
    }
    
    @objc func showStats() {
        let stats = gameStats
        let message = """
        📊 Game Statistics
        
        Total Spins: \(stats.totalSpins)
        Wins: \(stats.totalWins)
        Losses: \(stats.totalLosses)
        Win Rate: \(String(format: "%.1f", stats.winRate))%
        
        Collection Progress: \(String(format: "%.0f", stats.collectionProgress))%
        Energy: \(stats.energy)/\(stats.maxEnergy)
        """
        
        let alert = UIAlertController(title: "Game Statistics", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - UICollectionViewData Source

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.numberOfPokemonsDisplayed
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.pokemonCollectionViewCell.rawValue, for: indexPath) as? PokemonCollectionViewCell else {
            return UICollectionViewCell()
        }

        // Remember Pokemon numbers start at 1 not zero.
        let pokemonNumber = indexPath.row + 1
        let pokemon = PokemonManager.fetchPokemon(number: pokemonNumber)
        let isUnlocked = pokemon?.isUnlocked ?? false

        // If Pokemon is unlocked we show the image if not the number
        if isUnlocked {
            cell.prepareForDisplay(with: nil, image: String(pokemonNumber))
        } else {
            cell.prepareForDisplay(with: String(pokemonNumber), image: nil)
        }

        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let pokemonNumber = indexPath.row + 1
        let pokemon = PokemonManager.fetchPokemon(number: pokemonNumber)
        let isUnlocked = pokemon?.isUnlocked ?? false
        
        if isUnlocked {
            performSegue(withIdentifier: Constants.SegueIdentifier.openPokemonUnlocked.rawValue, sender: indexPath)
        } else {
            performSegue(withIdentifier: Constants.SegueIdentifier.openSlotMachine.rawValue, sender: indexPath)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width * 0.3, height: 100.0)
    }

    // MARK: - ScreenDismissable

    func screenDismissed() {
        collectionView.reloadData()
        updateProgress()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateProgress()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = sender as? IndexPath else { return }
        let pokemonNumber = indexPath.row + 1
        if segue.identifier == Constants.SegueIdentifier.openSlotMachine.rawValue {
            guard let slotMachineViewController = segue.destination as? SlotMachineViewController else { return }
            slotMachineViewController.pokemonNumber = pokemonNumber
            slotMachineViewController.delegate = self
        } else if segue.identifier == Constants.SegueIdentifier.openPokemonUnlocked.rawValue {
            guard let successViewController = segue.destination as? SuccessViewController else { return }
            successViewController.pokemonNumber = pokemonNumber
            successViewController.delegate = self
        }
    }

}
