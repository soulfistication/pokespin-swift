//
//  IntroViewController.swift
//  PokeSpin
//
//  Created by Ivan Almada on 18/01/2018.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

class IntroViewController: BaseViewController {

    @IBOutlet var infoTextView: UITextView!
    
    private let gameStats = GameStats.shared

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setup UI

    func setupUI() {
        infoTextView.backgroundColor = UIColor.creamyBlue
        view.backgroundColor = UIColor.creamyBlue
        
        // Update info text with game stats
        let unlockedCount = PokemonManager.fetchPokemons().filter { $0.isUnlocked }.count
        let welcomeText = """
        Welcome to PokeSpin! 🎰
        
        Spin the slot machine to collect all 18 Pokemon!
        
        Your Progress:
        • Collected: \(unlockedCount)/\(Constants.numberOfPokemonsDisplayed)
        • Total Spins: \(gameStats.totalSpins)
        • Win Rate: \(String(format: "%.1f", gameStats.winRate))%
        • Energy: \(gameStats.energy)/\(gameStats.maxEnergy)
        
        Tap "View Pokédex" to start collecting!
        """
        infoTextView.text = welcomeText
        infoTextView.font = UIFont.systemFont(ofSize: 16)
        infoTextView.textAlignment = .center
        infoTextView.isEditable = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI() // Refresh stats when returning to intro
    }

    // MARK: - IBActions

    @IBAction func triggerSegueTapped(sender: AnyObject) {
        performSegue(withIdentifier: Constants.SegueIdentifier.openPokeDex.rawValue, sender: self)
    }

    @IBAction func resetProgressTapped(sender: AnyObject) {
        let alertController = UIAlertController(title: "Confirm reset progress.", message: "Are you sure you want to erase your precious Pokemon?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Reset progress", style: .destructive, handler: { [weak self] (action) in
            self?.resetProgress()
        }))

        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Helpers

    func resetProgress() {
        PokemonManager.deletePokemons()
    }

}
