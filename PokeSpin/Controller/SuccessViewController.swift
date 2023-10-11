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
        
        let isUnlocked = pokemon?.isUnlocked ?? false

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
    func setupUI() {
        view.backgroundColor = UIColor.creamyBlue
        self.activityIndicatorView.hidesWhenStopped = true
    }

    func updateUI() {
        self.activityIndicatorView.stopAnimating()
        if let pokemon = self.pokemon {
            pokemonNameLabel.text = pokemon.name
            pokemonWeightLabel.text = String(pokemon.weight)
            pokemonHeightLabel.text = String(pokemon.height)
            pokemonBaseExperienceLabel.text = String(pokemon.baseExperience)
            pokemonImageView.image = UIImage(named: String(pokemonNumber))
        } else {
            let dittoPokemonNumber = 1
            let pokemonName = "Ditto"
            let weight = 23
            let height = 45
            let experience = 145
            pokemonNameLabel.text = pokemonName
            pokemonWeightLabel.text = String(weight)
            pokemonHeightLabel.text = String(height)
            pokemonBaseExperienceLabel.text = String(experience)
            pokemonImageView.image = UIImage(named: String(dittoPokemonNumber))
        }
    }
    
    func fetchPokemon() async -> Pokemon? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        do {
            let pokemonData = try await client.requestJSON(pokemon: pokemonNumber)
            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.managedObjectContext] = appDelegate.coreDataStack.managedContext
            let pokemon = try decoder.decode(Pokemon.self, from: pokemonData)
            pokemon.isUnlocked = true
            self.pokemon = pokemon
            PokemonManager.addPokemon(pokemon: pokemon)
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
