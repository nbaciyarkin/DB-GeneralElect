//
//  UserModel.swift
//  GeneralElectricCalculator
//
//  Created by Yarkın Gazibaba on 3.06.2023.
//

import Foundation

struct InternalUserModel {
    var serviceNumber:String
    var consumptions:[String?]
    var billPrices:[String?]
    var lastConsumption: String
    var calculatedCost:String
    
    mutating func updateConsumption(consumptions:[String?]) {
        self.consumptions = consumptions
       }
    
    mutating func updateCost(calculatedCost:String) {
        self.calculatedCost = calculatedCost
       }
}


