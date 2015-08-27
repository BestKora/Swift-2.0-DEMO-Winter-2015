//
//  ViewController.swift
//  CalculatorBrain
//
//  Created by Tatiana Kornilova on 2/5/15.
//  Copyright (c) 2015 Tatiana Kornilova. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    var userAlreadyEnteredADecimalPoint = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
//        println("digit = \(digit)");
        
        if userIsInTheMiddleOfTypingANumber {
//----- Уничтожаем лидирующие нули ---------------
            if (digit == "0") && (display.text == "0") { return }
            if (digit != ".") && (display.text == "0") { display.text = digit ; return }
//--------------------------------------------------
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
                   }
    }
    
    @IBAction func decimalPoint(sender: UIButton) {
        if !userAlreadyEnteredADecimalPoint {
            appendDigit(sender)
            userAlreadyEnteredADecimalPoint = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
                 history.text =  history.text! + " ="
            } else {
                // error?
                displayValue = nil  // задание 2
                history.text =  history.text! + " ERROR"
            }
        }
    }
    
    @IBAction func enter() {
         userIsInTheMiddleOfTypingANumber = false
         userAlreadyEnteredADecimalPoint = false
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        } else {
            // error?
            displayValue = nil  // задание 2
        }
    }
    
    @IBAction func clearAll(sender: AnyObject) {
        brain = CalculatorBrain()
        displayValue = nil
        history.text = " "

    }
 
    @IBAction func backSpace(sender: AnyObject) {
        if userIsInTheMiddleOfTypingANumber {
            if (display.text!).characters.count > 1 {
                display.text = String((display.text!).characters.dropLast())
//  смотрим не исчезла ли точка
                if (display.text!.rangeOfString(".") != nil){
                    userAlreadyEnteredADecimalPoint = false
                }
//   если осталось "-0" то превращаем в 0
                if ((display.text!).characters.count == 2) && (display.text?.rangeOfString("-") != nil) {
                    display.text = "0"
                }
            } else {
                display.text = "0"
                userIsInTheMiddleOfTypingANumber = false
            }
        }
    }
    
    @IBAction func plusMinus(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            if (display.text!.rangeOfString("-") != nil) {
                display.text = String((display.text!).characters.dropFirst())
            } else {
                display.text = "-" + display.text!
            }
        } else {
            operate(sender)
        }
    }
    
    var displayValue: Double? {
        get {
            if let displayText = display.text {
               return NSNumberFormatter().numberFromString(displayText)?.doubleValue
            }
            return nil
        }
        set {
            if (newValue != nil) {
                display.text = "\(newValue!)"
            } else {
                display.text = " "
            }
            userIsInTheMiddleOfTypingANumber = false
            history.text = brain.displayStack()
            
        }
    }

}

