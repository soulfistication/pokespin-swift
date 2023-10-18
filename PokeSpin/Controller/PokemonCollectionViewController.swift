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

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setup UI

    func setupUI() {
        title = "Pokemons"
    }

    // MARK: - UICollectionViewData Source

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.numberOfPokemonsDisplayed
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.pokemonCollectionViewCell.rawValue, for: indexPath) as? PokemonCollectionViewCell else {
            return UICollectionViewCell()
        }

        var image: String?

        // Remember Pokemon numbers start at 1 not zero.
        let pokemonNumber = indexPath.row + 1
        let pokemon = PokemonManager.fetchPokemon(number: pokemonNumber)
        let isUnlocked = pokemon?.isUnlocked ?? false

        // If Pokemon is unlocked we show the image if not the number
        if isUnlocked {
            image = String(pokemonNumber)
            cell.prepareForDisplay(with: nil, image: image)
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
