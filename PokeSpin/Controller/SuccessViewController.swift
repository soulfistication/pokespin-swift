//
//  SuccessViewController.swift
//  PokeSpin
//
//  Created by Ivan Almada on 18/01/2018.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit
import RealmSwift

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
            activityIndicatorView.startAnimating()

            client.requestJSONString(pokemon: pokemonNumber, completion: { [weak self] (response) in
                self?.activityIndicatorView.stopAnimating()
                self?.activityIndicatorView.isHidden = true
                let jsonString = response.result.value!
                if let jsonData = jsonString.data(using: .utf8) {
                    if let pokemon = try? JSONDecoder().decode(Pokemon.self, from: jsonData) {
                        let realm = try! Realm()
                        try! realm.write {
                            realm.add(pokemon)
                        }
                        self?.updateUI() 
                    }
                } 
            })
        }
    }

    // MARK: - Helpers

    func updateUI() {
        pokemonImageView.image = UIImage(named: String(pokemonNumber))

        let realm = try! Realm()
        let pokemon = realm.object(ofType: Pokemon.self, forPrimaryKey: pokemonNumber)!

        pokemonNameLabel.text = pokemon.name
        pokemonWeightLabel.text = String(pokemon.weight)
        pokemonHeightLabel.text = String(pokemon.height)
        pokemonBaseExperienceLabel.text = String(pokemon.baseExperience)
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
