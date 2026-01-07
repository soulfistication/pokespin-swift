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
    
    private let gameStats = GameStats.shared
    private let hapticGenerator = UINotificationFeedbackGenerator()
    private let impactGenerator = UIImpactFeedbackGenerator(style: .medium)

    // MARK: - IBOutlets

    @IBOutlet weak var pokemonNumberLabel: UILabel!
    @IBOutlet weak var slotMachinePickerView: UIPickerView!
    @IBOutlet weak var wonLabel: UILabel!
    @IBOutlet weak var wonImageView: UIImageView!
    @IBOutlet weak var spinSlotButton: UIButton!
    @IBOutlet weak var energyLabel: UILabel!
    @IBOutlet weak var statsLabel: UILabel!
    
    // Fallback labels if not connected in storyboard
    private var energyLabelFallback: UILabel?
    private var statsLabelFallback: UILabel?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setup UI

    func setupUI() {
        pokemonNumberLabel.text = "Pokemon #\(pokemonNumber)"
        view.backgroundColor = UIColor.creamyBlue
        slotMachinePickerView.selectRow(4, inComponent: 0, animated: true)
        slotMachinePickerView.selectRow(4, inComponent: 1, animated: true)
        slotMachinePickerView.selectRow(4, inComponent: 2, animated: true)
        
        updateEnergyDisplay()
        updateStatsDisplay()
        
        // Prepare haptic feedback
        hapticGenerator.prepare()
        impactGenerator.prepare()
        
        // Style the button
        spinSlotButton.layer.cornerRadius = 12
        spinSlotButton.backgroundColor = UIColor.systemBlue
        spinSlotButton.setTitleColor(.white, for: .normal)
        spinSlotButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    func updateEnergyDisplay() {
        let energy = gameStats.energy
        let energyText = "⚡ Energy: \(energy)/\(gameStats.maxEnergy)"
        
        if let energyLabel = energyLabel {
            energyLabel.text = energyText
            energyLabel.textColor = energy > 0 ? .systemGreen : .systemRed
        } else {
            // Create fallback label if not in storyboard
            if energyLabelFallback == nil {
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.font = UIFont.boldSystemFont(ofSize: 16)
                view.addSubview(label)
                NSLayoutConstraint.activate([
                    label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                    label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                ])
                energyLabelFallback = label
            }
            energyLabelFallback?.text = energyText
            energyLabelFallback?.textColor = energy > 0 ? .systemGreen : .systemRed
        }
        
        spinSlotButton.isEnabled = energy > 0
        spinSlotButton.alpha = energy > 0 ? 1.0 : 0.5
    }
    
    func updateStatsDisplay() {
        let stats = gameStats
        let winRate = String(format: "%.1f", stats.winRate)
        let statsText = "Spins: \(stats.totalSpins) | Wins: \(stats.totalWins) | Win Rate: \(winRate)%"
        
        if let statsLabel = statsLabel {
            statsLabel.text = statsText
            statsLabel.font = UIFont.systemFont(ofSize: 14)
            statsLabel.textColor = .darkGray
        } else {
            // Create fallback label if not in storyboard
            if statsLabelFallback == nil {
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.font = UIFont.systemFont(ofSize: 14)
                label.textColor = .darkGray
                view.addSubview(label)
                if let energyLabel = energyLabelFallback ?? energyLabel {
                    NSLayoutConstraint.activate([
                        label.topAnchor.constraint(equalTo: energyLabel.bottomAnchor, constant: 8),
                        label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                    ])
                } else {
                    NSLayoutConstraint.activate([
                        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
                        label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                    ])
                }
                statsLabelFallback = label
            }
            statsLabelFallback?.text = statsText
        }
    }

    // MARK: - IBActions

    @IBAction func closeButtonTapped(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func spinSlotMachine(sender: AnyObject) {
        spin()
    }

    // MARK: - UIPickerView Data Source

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return Constants.numberOfColumnsInSlotMachine
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.numberOfRowsInSlotMachine
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

    func screenDismissed() {
        dismiss(animated: true) { [weak self] in
            self?.delegate?.screenDismissed()
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifier.openSuccess.rawValue {
            let successViewController = segue.destination as! SuccessViewController
            successViewController.pokemonNumber = pokemonNumber
            successViewController.delegate = self
        }
    }
    
    // MARK: - Logic
    func spin() {
        guard gameStats.energy > 0 else {
            let alert = UIAlertController(title: "No Energy", message: "You need energy to spin! Energy regenerates over time (1 per hour).", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        spinSlotButton.isEnabled = false
        impactGenerator.impactOccurred()
        
        // Animate each wheel with different timings for more realistic effect
        let baseRow = Int.random(in: 12...24)
        let spinDuration: TimeInterval = 1.5
        
        // First wheel - fastest
        let firstFinalRow = baseRow + Int.random(in: 20...30)
        
        // Second wheel - medium
        let secondFinalRow = baseRow + Int.random(in: 25...35)
        
        // Third wheel - slowest
        let thirdFinalRow = baseRow + Int.random(in: 30...40)
        
        // Animate wheels with staggered timing
        slotMachinePickerView.selectRow(firstFinalRow, inComponent: 0, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.slotMachinePickerView.selectRow(secondFinalRow, inComponent: 1, animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            self?.slotMachinePickerView.selectRow(thirdFinalRow, inComponent: 2, animated: true)
        }
        
        // Calculate results after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + spinDuration + 0.5) { [weak self] in
            guard let self = self else { return }
            
            let firstSymbol = self.slotSymbol(row: firstFinalRow)
            let secondSymbol = self.slotSymbol(row: secondFinalRow)
            let thirdSymbol = self.slotSymbol(row: thirdFinalRow)

            let firstHit = firstSymbol == secondSymbol
            let secondHit = secondSymbol == thirdSymbol
            let thirdHit = firstSymbol == thirdSymbol

            let successHit = firstHit && secondHit
            
            // Record the spin
            self.gameStats.recordSpin(win: successHit)
            self.updateEnergyDisplay()
            self.updateStatsDisplay()
            
            if successHit {
                self.hapticGenerator.notificationOccurred(.success)
                self.wonLabel.isHidden = false
                self.wonImageView.isHidden = false
                self.wonLabel.text = "🎉 WINNER! 🎉"
                
                // Add celebration animation
                UIView.animate(withDuration: 0.3, animations: {
                    self.wonLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }) { _ in
                    UIView.animate(withDuration: 0.3) {
                        self.wonLabel.transform = .identity
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1.5), execute: { [weak self] in
                    self?.performSegue(withIdentifier: Constants.SegueIdentifier.openSuccess.rawValue, sender: nil)
                })
            } else {
                self.hapticGenerator.notificationOccurred(.error)
                var message = "You lost! Please try again."
                var title = "Try Again"
                
                if firstHit || secondHit || thirdHit {
                    message = "So close! You matched 2 symbols. Try again!"
                    title = "Almost There!"
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { [weak self] (action) in
                    self?.updateEnergyDisplay()
                    self?.dismiss(animated: true, completion: nil)
                })
                alertController.addAction(action)
                self.present(alertController, animated: true)
            }
        }
    }

}
