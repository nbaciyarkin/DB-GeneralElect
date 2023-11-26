//
//  ConsumptionCalculatorRouter.swift
//  GeneralElectricCalculator
//
//  Created by Yarkın Gazibaba on 3.06.2023.
//

import Foundation

class ConsumptionCalculatorInteractor {
    
    func isAlphaNumeric(string:String) -> Bool {
        let alphanumericCharacterSet = CharacterSet.alphanumerics
        return string.rangeOfCharacter(from: alphanumericCharacterSet.inverted) == nil && !string.isEmpty
    }
    
    func isTextCountEqualToTen(_ string: String) -> Bool {
        return string.count == 10
    }
    
    func isPositiveCurrentMeterValue(currentMeter:Int) -> Bool{
        if currentMeter > 0 {
            return true
        }
        else {
            return false
        }
    }
    
    func isCurrentValueGreaterThanPreviousValue() {
        //
    }
    
    func getUserWithServiceNumber(with serviceNumber: String) -> InternalUserModel{
        var user = InternalUserModel(serviceNumber: "", consumptions: [], billPrices: [], lastConsumption: "", calculatedCost: "")
        DatapersistenceManager.shared.fetchUserModel(withServiceNumber: serviceNumber) { result in
            switch result {
            case .success(let userModel):
                if let userModel = userModel {
                    // User model found for the specified service number
                    print(userModel)
                    if let serviceNumber = userModel.serviceNumber, let consumptionPrice =  userModel.consumptionPrice, let consumptions = userModel.consumptions, let calculatedCost = userModel.calculatedConsumption {
                        user.serviceNumber = serviceNumber
                        user.lastConsumption = consumptionPrice
                        user.consumptions = consumptions as! [String]
                        user.calculatedCost = calculatedCost
                        Alert.success(title: "User Founded", text: "User service Number: \(serviceNumber)")
                    }
                } else {
                    // No user model found for the specified service number
                    print("User model not found")
                }
            case .failure(let error):
                // Handle the fetch error
                print("Error fetching user model: \(error.localizedDescription)")
            }
        }
        return user
    }
    
    func saveCurrentUser(serviceId: String?, consumptionPrice: String?, consumptions:[String]){
        guard let consumptionPrice = consumptionPrice else {
            return
        }
        guard let serviceId = serviceId else {
            return
        }
        
        DatapersistenceManager.shared.saveUser(model: InternalUserModel(serviceNumber: serviceId, consumptions: [], billPrices: [], lastConsumption: consumptionPrice, calculatedCost: "0")) { result in
            switch result{
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("User Created"), object: nil)
                Alert.success(title: "User Created", text: "New User Created")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
   }
    
}
