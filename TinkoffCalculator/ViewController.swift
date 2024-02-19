//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Александр on 19.02.2024.
//

import UIKit

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle else { return }
        
        print(buttonText)
    }
    
}

