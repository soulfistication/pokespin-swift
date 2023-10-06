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
            fetchPokemon()
        }
    }

    // MARK: - Helpers
    func setupUI() {
        view.backgroundColor = UIColor.creamyBlue
    }

    func updateUI() {
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
    
    func fetchPokemon() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        activityIndicatorView.startAnimating()
        
        client.requestJSONData(pokemon: pokemonNumber) { [weak self] result in
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                strongSelf.activityIndicatorView.stopAnimating()
                strongSelf.activityIndicatorView.isHidden = true
            }
            
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.userInfo[CodingUserInfoKey.managedObjectContext] = appDelegate.coreDataStack.managedContext
                if let pokemon = try? decoder.decode(Pokemon.self, from: data) {
                    pokemon.isUnlocked = true
                    strongSelf.pokemon = pokemon
                    PokemonManager.addPokemon(pokemon: pokemon)
                    DispatchQueue.main.async {
                        strongSelf.updateUI()
                    }
                }
            case .failure(let error):
                print(String(describing: error))
            }
            
        }

    }

    // MARK: - IBAction

    @IBAction func closeButtonTapped(sender: AnyObject) {
        dismiss(animated: true) { [weak self] in
            self?.delegate?.screenDidDismissed()
        }
    }

}
