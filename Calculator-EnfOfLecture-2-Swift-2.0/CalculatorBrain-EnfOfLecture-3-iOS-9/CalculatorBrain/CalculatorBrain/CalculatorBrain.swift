//
//  CalculatorBrain.swift
//  Calculator
//
//   Created by Tatiana Kornilova on 2/5/15.
//  Copyright (c) 2015 Tatiana Kornilova. All rights reserved.
//

//

import Foundation

class CalculatorBrain
{
    private enum Op: CustomStringConvertible
    {
        case Operand(Double)
        case ConstantOperation(String, () -> Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .ConstantOperation(let symbol, _):
                    return symbol

                }
            }
        }
    }

    private var opStack = [Op]()
    
 
    private var knownOps = [String:Op]()
    
    init() {
        func learnOp (op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷", { $1 / $0 }))
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−", { $1 - $0 }))
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
        learnOp(Op.ConstantOperation("π", { M_PI }))
        learnOp(Op.UnaryOperation("±", { -$0 }))

    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
                
            case .ConstantOperation(_, let operation):
                return (operation(), remainingOps)
                
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func displayStack() -> String? {
        return opStack.map{ "\($0)" }.joinWithSeparator(" ")
    }

    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        //let (result, _) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}