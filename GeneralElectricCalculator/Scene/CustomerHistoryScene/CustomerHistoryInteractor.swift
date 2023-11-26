//
//  CustomerHistoryInteractor.swift
//  GeneralElectricCalculator
//
//  Created by Yarkın Gazibaba on 3.06.2023.
//

import Foundation
import UIKit

class CustomerHistroyInteractor {
    
    var user:InternalUserModel?
    private var serviceNumber: String?
    var currentConsumpitonMeter: Int?
    
    enum CellType: String {
        case Reading = "Reading"
    }
    
    func setData(serviceNumber: String?, currentConsumpitonMeter: Int?) {
        self.serviceNumber = serviceNumber
        self.currentConsumpitonMeter = currentConsumpitonMeter
    }
    
    var cellList = [CellType]()
    
    func createCelllist() {
        cellList.removeAll()
        cellList.append(.Reading)
    }
    
    let slabTable = [
        Calculator.Slab(upperLimit: 100, rate: 5),
        Calculator.Slab(upperLimit: 500, rate: 8),
        Calculator.Slab(upperLimit: Int.max, rate: 10)
    ]
    
    func calculateBill(difference:Int) ->Int{
        //let reading1: Int = 250 // Household HA123
        let billAmount = Calculator.shared.calculateBillAmount(forReading: difference, usingSlabTable: slabTable)
        print("Bill amount for reading 1: $\(billAmount)")
        return billAmount
    }
    
    func findDifference(currentValue: Int, previousValue: String) -> Int {
        if let intPreviousValue = Int(previousValue) {
            return currentValue - intPreviousValue
        }
        return 0
    }
}

// MARK: - TableView Methods
extension CustomerHistroyInteractor {
    
    
    func registerCells(tableView: UITableView) {
        tableView.register(ReadingTableViewCell.self, forCellReuseIdentifier: ReadingTableViewCell.identifier)
    }
    
    func createReadingCell(tableView: UITableView, indexPath: IndexPath) -> ReadingTableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReadingTableViewCell", for: indexPath) as! ReadingTableViewCell
        if let lastConsumption = user?.consumptions.last {
            if user?.consumptions.count ?? 0 < 2 {
                if let calculatedCost = user?.calculatedCost {
                    cell.setData(consumption: user?.consumptions[indexPath.row] ?? "", cost: ":\(calculatedCost)$")
                }
            }else {
                if let lastConsumption = lastConsumption, let currentConsumption = currentConsumpitonMeter {
                    let difference = currentConsumption - (Int(lastConsumption) ?? 0)
                    let bill = calculateBill(difference: difference)
                    if let calculated = user?.calculatedCost, let billPirces = user?.billPrices[indexPath.row]{
                        cell.setData(consumption: getLastThreeConsumptions()[indexPath.row] ?? "", cost: ":\(String(describing: getLastThreePrices()[indexPath.row] ?? ""))$")
                    }
                }
            }
        }
        return cell
    }
    
    func rowHeightFor(indexPath: IndexPath) -> CGFloat{
        return 150
    }
    
    func numberOfSection(in tableView: UITableView) -> Int {
        return cellList.count
    }
    
    func numberOfRow(in tableView: UITableView) -> Int {
        var rowNumber = 0
        if let rows = user?.consumptions {
            if rows.count > 2 {
                rowNumber = 3
            }else {
                rowNumber = rows.count
            }
        }
        return rowNumber
    }
    
    func getLastThreeConsumptions() -> [String?] {
        var list:[String?] = []
        if let consumptions = user?.consumptions{
            let lastThreeElements = Array(consumptions.suffix(3))
            list = lastThreeElements
        }
        return list
    }
    func getLastThreePrices() -> [String?] {
        var list:[String?] = []
        if let billprices = user?.billPrices{
            let lastThreeElements = Array(billprices.suffix(3))
            list = lastThreeElements
        }
        return list
    }
}

extension CustomerHistroyInteractor {
    func getUserWithServiceNumber() -> InternalUserModel{
        var user = InternalUserModel(serviceNumber: "", consumptions: [], billPrices: [], lastConsumption: "", calculatedCost: "")
        DatapersistenceManager.shared.fetchUserModel(withServiceNumber: serviceNumber ?? "") { result in
            switch result {
            case .success(let userModel):
                if let userModel = userModel {
                    // User model found for the specified service number
                    print(userModel)
                    if let serviceNumber = userModel.serviceNumber, let consumptionPrice =  userModel.consumptionPrice, let consumptions = userModel.consumptions, let calculatedCost = userModel.calculatedConsumption ,let billPrices = userModel.billPrices {
                        user.serviceNumber = serviceNumber
                        user.lastConsumption = consumptionPrice
                        user.consumptions = consumptions as! [String]
                        user.calculatedCost = calculatedCost
                        user.billPrices = billPrices as! [String]
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
    
    func updateUserConsumption(model: InternalUserModel, billPrices:[String?], consumptions: [String?], cost: String){
        DatapersistenceManager.shared.updateUser(updatedConsumptions: consumptions, billPrices: billPrices, updatedTotalCost: cost, model: model) { result in
            switch result {
            case .success:
                print("User entity updated successfully.")
            case .failure(let error):
                print("Failed to update user entity: \(error)")
            }
        }
    }
    
}
