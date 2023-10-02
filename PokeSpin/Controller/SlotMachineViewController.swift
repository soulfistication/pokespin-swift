//
//  SlotMachineViewController.swift
//  PokeSpin
//
//  Created by Ivan Almada on 18/01/2018.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

class SlotMachineViewController: BaseViewController, UIPickerViewDataSource, UIPickerViewDelegate, ScreenDismissable {

    var pokemonNumber: Int = 0
    weak var delegate: ScreenDismissable?

    // MARK: - IBOutlets

    @IBOutlet weak var pokemonNumberLabel: UILabel!
    @IBOutlet weak var slotMachinePickerView: UIPickerView!
    @IBOutlet weak var wonLabel: UILabel!
    @IBOutlet weak var wonImageView: UIImageView!
    @IBOutlet weak var spinSlotButton: UIButton!

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setup UI

    func setupUI() {
        pokemonNumberLabel.text = String(pokemonNumber)
        view.backgroundColor = UIColor.creamyBlue
        slotMachinePickerView.selectRow(4, inComponent: 0, animated: true)
        slotMachinePickerView.selectRow(4, inComponent: 1, animated: true)
        slotMachinePickerView.selectRow(4, inComponent: 2, animated: true)
    }

    // MARK: - IBActions

    @IBAction func closeButtonTapped(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func spinSlotMachine(sender: AnyObject) {
        spinSlotButton.isEnabled = false
        
        let firstComponentRandomNumber = Int.random(in: 12...24)
        let secondComponentRandomNumber = Int.random(in: 12...24)
        let thirdComponentRandomNumber = Int.random(in: 12...24)

        slotMachinePickerView.selectRow(firstComponentRandomNumber, inComponent: 0, animated: true)
        slotMachinePickerView.selectRow(secondComponentRandomNumber, inComponent: 1, animated: true)
        slotMachinePickerView.selectRow(thirdComponentRandomNumber, inComponent: 2, animated: true)

        let firstSymbol = slotSymbol(row: firstComponentRandomNumber)
        let secondSymbol = slotSymbol(row: secondComponentRandomNumber)
        let thirdSymbol = slotSymbol(row: thirdComponentRandomNumber)

        let firstHit = firstSymbol == secondSymbol
        let secondHit = secondSymbol == thirdSymbol
        let thirdHit = firstSymbol == thirdSymbol

        // let successHit = firstHit && secondHit
        let successHit = true

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
            if successHit {
                self?.wonLabel.isHidden = false
                self?.wonImageView.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: { [weak self] in
                    self?.performSegue(withIdentifier: Constants.SegueIdentifier.openSuccess.rawValue, sender: nil)
                })
            } else {
                var message = "You lost! Please try again."
                if firstHit || secondHit || thirdHit {
                    message = "You almost won! Please try again"
                }
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { [weak self] (action) in
                    self?.dismiss(animated: true, completion: nil)
                })
                alertController.addAction(action)
                self?.show(alertController, sender: nil)
            }
        }
    }

    // MARK: - UIPickerView Data Source

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 36
    }

    // MARK: - UIPickerView Delegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return slotSymbol(row: row)
    }

    // MARK: - Helpers

    private func slotSymbol(row: Int) -> String {
        if row % 4 == 0 {
            return "♠️"
        } else if row % 4 == 1 {
            return "♥️"
        } else if row % 4 == 2 {
            return "♣️"
        } else if row % 4 == 3 {
            return "♦️"
        }
        return "💊"
    }

    // MARK: - Screen Dismissable

    func screenDidDismissed() {
        dismiss(animated: true) { [weak self] in
            if let delegate = self?.delegate, delegate.responds(to: #selector(delegate.screenDidDismissed)) {
                delegate.screenDidDismissed()
            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifier.openSuccess.rawValue {
            let successViewController = segue.destination as! SuccessViewController
            successViewController.pokemonNumber = pokemonNumber
            successViewController.unlocked = false
            successViewController.delegate = self
        }
    }

}
