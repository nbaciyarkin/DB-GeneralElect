//
//  Calculator.swift
//  GeneralElectricCalculator
//
//  Created by Yarkın Gazibaba on 3.06.2023.
//

import Foundation

class Calculator {
    struct Slab {
        let upperLimit: Int
        let rate: Int
    }
    static let shared = Calculator()
    
    func calculateBillAmount<T>(forReading reading: T, usingSlabTable slabTable: [Slab]) -> Int where T: BinaryInteger {
        var totalBillAmount = 0
        var remainingUnits = Int(reading)
        
        for slab in slabTable {
            if remainingUnits <= 0 {
                break
            }
            
            let unitsInSlab = min(remainingUnits, slab.upperLimit)
            let slabCost = unitsInSlab * slab.rate
            totalBillAmount += slabCost
            
            remainingUnits -= unitsInSlab
        }
        
        return totalBillAmount
    }
}
