//
//  ViewController.swift
//  Calculator
//

//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber: Bool = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        //println("digit = \(digit)")
        
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        switch operation {
            
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        default: break
        }
    }
    
    @nonobjc func performOperation (operation: Double -> Double ){
        if operandStack.count >= 1 {
            displayValue = operation (operandStack.removeLast())
            enter()
        }
    }

    @nonobjc func performOperation (operation: (Double, Double) -> Double ){
        if operandStack.count >= 2 {
            displayValue = operation (operandStack.removeLast() , operandStack.removeLast())
            enter()
        }
 
    }
    

    
    var operandStack = Array <Double>()
    
    @IBAction func enter() {
        
        userIsInTheMiddleOfTypingANumber = false
        
        operandStack.append( displayValue )
        
        print("operandStack = \(operandStack)")
        
    }
    var displayValue :Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
            
        }
    }
}

