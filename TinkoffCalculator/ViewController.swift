//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Александр on 19.02.2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let buttonText = sender.titleLabel else { return }
        
        print(buttonText)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Та-дам")
    }
    
}

