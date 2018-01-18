//
//  SuccessViewController.swift
//  PokeSpin
//
//  Created by Ivan Almada on 18/01/2018.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit

class SuccessViewController: BaseViewController {

    var pokemonNumber = 2

    var unlocked = false

    weak var delegate: ScreenDismissable?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
