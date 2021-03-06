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
        title = "Collection"
    }

    // MARK: - UICollectionViewData Source

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18 // I decided to use 18 Pokemons
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.pokemonCollectionViewCell.rawValue, for: indexPath) as! PokemonCollectionViewCell

        var image: String?

        // Remember Pokemon numbers start at 1 not zero.
        let pokemonNumber = indexPath.row + 1
        let pokemonNumberString = String(pokemonNumber)

        // If Pokemon is unlocked we show the image if not the number
        if Pokemon.pokemonIsUnlocked(number: pokemonNumber) {
            image = pokemonNumberString
            cell.prepareForDisplay(with: nil, image: image)
        } else {
            cell.prepareForDisplay(with: pokemonNumberString, image: nil)
        }

        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if Pokemon.pokemonIsUnlocked(number: indexPath.row + 1) {
            performSegue(withIdentifier: Constants.SegueIdentifier.openPokemonUnlocked.rawValue, sender: indexPath)
        } else {
            performSegue(withIdentifier: Constants.SegueIdentifier.openSlotMachine.rawValue, sender: indexPath)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width * 0.3, height: 100.0)
    }

    // MARK: - ScreenDismissable

    func screenDidDismissed() {
        collectionView.reloadData()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = sender as! IndexPath
        let pokemonNumber = indexPath.row + 1
        if segue.identifier == Constants.SegueIdentifier.openSlotMachine.rawValue {
            let slotMachineViewController = segue.destination as! SlotMachineViewController
            slotMachineViewController.pokemonNumber = indexPath.row + 1
            slotMachineViewController.delegate = self
        } else if segue.identifier == Constants.SegueIdentifier.openPokemonUnlocked.rawValue {
            let successViewController = segue.destination as! SuccessViewController
            successViewController.unlocked = true
            successViewController.pokemonNumber = pokemonNumber
            successViewController.delegate = self
        }
    }

}
