//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Александр on 19.02.2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func burronPressed(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle else { return }
        
        print(buttonText)
        
        label.text = buttonText
        
    }
}

