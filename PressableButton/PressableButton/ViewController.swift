//
//  ViewController.swift
//  PressableButton
//
//  Created by Unsung Lee on 6/2/19.
//  Copyright © 2019 Unsung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dimButton = DimButton()
        dimButton.setTitle("Press me!!", for: .normal)
        dimButton.translatesAutoresizingMaskIntoConstraints = false
        
        let brightButton = BrightButton()
        brightButton.setTitle("Press me!!", for: .normal)
        brightButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(brightButton)
        view.addSubview(dimButton)
        
        NSLayoutConstraint.activate([
            brightButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1, constant: -40),
            brightButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 70),
            brightButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dimButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1, constant: -40),
            dimButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dimButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70)
            ])
    }
}

