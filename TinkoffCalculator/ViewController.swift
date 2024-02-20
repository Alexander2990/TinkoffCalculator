//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Александр on 19.02.2024.
//

import UIKit

enum CalculationError: Error {
    case divideByZero
}

enum Operation: String, CaseIterable {
    case add = "+"
    case subtract = "-"
    case multiply = "x"
    case divide = "/"
    
    func calculate(_ number1: Double, _ number2: Double) throws -> Double {
        switch self {
        case .add:
            return number1 + number2
        case .subtract:
            return number1 - number2
        case .multiply:
            return number1 * number2
        case .divide:
            if number2 == 0 {
                throw CalculationError.divideByZero
            }
            return number1 / number2
        }
    }
}

enum CalculationHistoryItem {
    case number(Double)
    case operation(Operation)
}

final class ViewController: UIViewController {
    
    @IBOutlet var label: UILabel!
    
    lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "ru_RU")
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter
    }()
    
    var calculationHistory: [CalculationHistoryItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetLabelText()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle else { return }
        
        if buttonText == "," && label.text?.contains(",") == true {
            return
        }
        
        if label.text == "0" || label.text == "Ошибка" || label.text?.contains("E") == true {
            if buttonText == "," {
                label.text = "0,"
            } else {
                label.text = buttonText
            }
        } else {
            let input = (label.text ?? "") + buttonText
            let inputWidth = input.size(withAttributes: [.font : UIFont.systemFont(ofSize: 30.0)]).width
            
            if inputWidth > label.bounds.size.width { return }
            
            label.text?.append(buttonText)
        }
    }
    
    @IBAction func operationBurronPressed(_ sender: UIButton) {
        guard
            let buttonText = sender.currentTitle,
            let buttonOperation = Operation(rawValue: buttonText)
        else { return }
        
        guard
            let labelText = label.text,
            let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else { return }
        
        if label.text == "0" && buttonText == "-" {
            label.text = "-"
        } else {
            calculationHistory.append(.number(labelNumber))
            calculationHistory.append(.operation(buttonOperation))
            
            resetLabelText()
        }
    }
    
    @IBAction func clearButtonPressed() {
        
        calculationHistory.removeAll()
        
        resetLabelText()
        
    }
    
    @IBAction func calculateButtonPressed() {
        guard
            let labelText = label.text,
            let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else { return }
        
        calculationHistory.append(.number(labelNumber))
        
        do {
            let result = try calculate()
            
            let output = numberFormatter.string(from: NSNumber(value: result))
            let resultWidth = output?.size(
                withAttributes: [.font : UIFont.systemFont(ofSize: 30.0)]
            ).width ?? 0
            
            if resultWidth > label.bounds.size.width {
                let formatter = NumberFormatter()
                formatter.numberStyle = .scientific
                formatter.maximumFractionDigits = 5
                label.text = formatter.string(for: result)
            } else {
                label.text = output
            }
        } catch {
            label.text = "Ошибка"
        }
        
        calculationHistory.removeAll()
    }
    
    func calculate() throws -> Double {
        guard case .number(let firstNumber) = calculationHistory[0] else { return 0 }
        
        var currentResult = firstNumber
        
        for index in stride(from: 1, to: calculationHistory.count - 1, by: 2) {
            guard
                case .operation(let operation) = calculationHistory[index],
                case .number(let number) = calculationHistory[index + 1]
            else { break }
            
            currentResult = try operation.calculate(currentResult, number)
        }
        
        return currentResult
    }
    
    func resetLabelText() {
        label.text = "0"
    }
}

