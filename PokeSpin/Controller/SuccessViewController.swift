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
    var unlocked = false
    var client: NetworkClient!
    weak var delegate: ScreenDismissable?

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

        view.backgroundColor = UIColor.creamyBlue
        client = NetworkClient()

        if unlocked {
            updateUI()
        } else {
            fetchPokemon()
        }
    }

    // MARK: - Helpers

    func updateUI() {
        pokemonImageView.image = UIImage(named: String(pokemonNumber))

        //TODO: fetch pokemon from db
        let pokemon = Pokemon(id: 1, name: "Ditto", weight: 23, height: 45, baseExperience: 145)

        pokemonNameLabel.text = pokemon.name
        pokemonWeightLabel.text = String(pokemon.weight)
        pokemonHeightLabel.text = String(pokemon.height)
        pokemonBaseExperienceLabel.text = String(pokemon.baseExperience)
    }
    
    func fetchPokemon() {
        activityIndicatorView.startAnimating()

        client.requestJSONString(pokemon: pokemonNumber, completion: { [weak self] (response) in
            self?.activityIndicatorView.stopAnimating()
            self?.activityIndicatorView.isHidden = true
//            let jsonString = response.result.value!
//            if let jsonData = jsonString.data(using: .utf8) {
//                if let pokemon = try? JSONDecoder().decode(Pokemon.self, from: jsonData) {
//                    //TODO: Add pokemon data to db
//                    self?.updateUI()
//                }
//            }
        })
    }

    // MARK: - IBAction

    @IBAction func closeButtonTapped(sender: AnyObject) {
        dismiss(animated: true) { [weak self] in
            if let delegate = self?.delegate {
                if delegate.responds(to: #selector(delegate.screenDidDismissed)) {
                    delegate.screenDidDismissed()
                }
            }
        }
    }

}
