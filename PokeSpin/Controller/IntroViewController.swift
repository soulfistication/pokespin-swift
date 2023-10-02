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

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Setup UI

    func setupUI() {
        infoTextView.backgroundColor = UIColor.creamyBlue
        view.backgroundColor = UIColor.creamyBlue
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

    }

}
