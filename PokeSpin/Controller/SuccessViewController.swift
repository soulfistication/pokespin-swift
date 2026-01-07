//
//  SuccessViewController.swift
//  PokeSpin
//
//  Created by Ivan Almada on 02/10/2023.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

class SuccessViewController: BaseViewController {

    var pokemonNumber = 0
    var client = NetworkClient()
    weak var delegate: ScreenDismissable?

    var pokemon: Pokemon?
    var isUnlocked: Bool { return pokemon?.isUnlocked ?? false }

    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    // MARK: - IBOutlets

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonWeightLabel: UILabel!
    @IBOutlet weak var pokemonHeightLabel: UILabel!
    @IBOutlet weak var pokemonBaseExperienceLabel: UILabel!

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        if isUnlocked {
            updateUI()
        } else {
            self.activityIndicatorView.startAnimating()
            Task {
                self.pokemon = await fetchPokemon()
                self.updateUI()
            }
        }
    }

    // MARK: - Helpers
    @MainActor
    func setupUI() {
        view.backgroundColor = UIColor.creamyBlue
        self.activityIndicatorView.hidesWhenStopped = true
    }

    @MainActor
    func updateUI() {
        self.activityIndicatorView.stopAnimating()
        if let pokemon = self.pokemon {
            pokemonNameLabel.text = pokemon.name.capitalized
            pokemonNameLabel.font = UIFont.boldSystemFont(ofSize: 24)
            pokemonWeightLabel.text = "Weight: \(pokemon.weight) kg"
            pokemonHeightLabel.text = "Height: \(pokemon.height) cm"
            pokemonBaseExperienceLabel.text = "Base Experience: \(pokemon.baseExperience)"
            pokemonImageView.image = UIImage(named: String(pokemonNumber))
            
            // Add celebration animation
            celebrateUnlock()
        }
    }
    
    private func celebrateUnlock() {
        // Scale animation
        pokemonImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: [], animations: {
            self.pokemonImageView.transform = .identity
        })
        
        // Pulse animation for name
        UIView.animate(withDuration: 0.5, animations: {
            self.pokemonNameLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.5) {
                self.pokemonNameLabel.transform = .identity
            }
        }
    }

    func fetchPokemon() async -> Pokemon? {
        guard let appDelegate else { return nil }
        
        do {
            let pokemonData = try await client.requestJSON(pokemon: pokemonNumber)
            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.managedObjectContext] = appDelegate.coreDataStack.managedContext
            let pokemon = try decoder.decode(Pokemon.self, from: pokemonData)
            pokemon.isUnlocked = true
            self.pokemon = pokemon
            PokemonManager.add(pokemon: pokemon)
            return pokemon
        } catch (let error) {
            print(String(describing: error))
            return nil
        }

    }

    // MARK: - IBAction

    @IBAction func closeButtonTapped(sender: AnyObject) {
        dismiss(animated: true) { [weak self] in
            self?.delegate?.screenDismissed()
        }
    }

}
