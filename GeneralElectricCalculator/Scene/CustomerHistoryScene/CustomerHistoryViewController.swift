//
//  CustomerHistorySceneViewController.swift
//  GeneralElectricCalculator
//
//  Created by Yarkın Gazibaba on 3.06.2023.
//

import Foundation
import UIKit

class CustomerHistoryViewController: BaseViewController {
    

    private var currentConsumptionValue:Int?
    private var userServisNumber: String?
    private var calculatedBill:Int?
    private var difference: String?
    let interactor = CustomerHistroyInteractor()
    
    let infoTitleLabelFont = UIFont(name: "Quicksand-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
    let totalBilFont = UIFont(name: "Quicksand-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
    let tableHeaderFont = UIFont(name: "Quicksand-Bold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .bold)
    
    
    private var differenceLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.darkGray
        label.font = UIFont(name: "Arial", size: 12)
        label.textAlignment = .center
        return label
    }()
    
    private var currentConsumption: UILabel = {
        let label = UILabel()
        label.textColor = Constants.darkGray
        label.text = "Customer Service Info"
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 12)
        return label
    }()
    
    private var previousConsumption: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Constants.darkGray
        label.text = "Customer Service Info"
        label.font = UIFont(name: "Arial", size: 12)
        return label
    }()
    
    private var costBill: UILabel = {
        let label = UILabel()
        label.textColor = Constants.darkGray
        label.font = UIFont(name: "Arial", size: 15)
        label.textAlignment = .center
        return label
    }()
    
    private var readingsTable: UITableView = {
        let table = UITableView()
        table.backgroundColor = .cyan
        return table
    }()
    
    private var totalBillLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.darkGray
        label.font = UIFont(name: "Arial", size: 15)
        label.text = "TOTAL BILL:"
        label.textAlignment = .center
        return label
    }()
    
    private var billTableTitle: UILabel = {
        let label = UILabel()
        label.text = "Bill List"
        label.textAlignment = .center
        label.textColor = Constants.darkYellow
        return label
    }()
    
    private let saveButton: AnimatedButton = {
        let btn = AnimatedButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("SAVE", for: .normal)
        btn.backgroundColor = .systemYellow
        btn.setTitleColor(Constants.darkGray, for: .normal)
        btn.titleLabel?.textAlignment = .right
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = cornerRadius
        btn.addTarget(self, action: #selector(save_TUI), for: .touchUpInside)
        btn.titleLabel!.font = UIFont(name: "Arial" , size: 17)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        interactor.user = interactor.getUserWithServiceNumber()
        print(interactor.user)
        interactor.createCelllist()
        interactor.registerCells(tableView: readingsTable)
        setData(user: interactor.user, currentConsumptionVal: interactor.currentConsumpitonMeter ?? 0)
        setUI()
        setConstraints()
    }
    @objc func save_TUI(){
        if let calculatedBill = calculatedBill,let  user = interactor.user, let newConsumption = interactor.currentConsumpitonMeter  {
            let newTotalCost = Int(user.calculatedCost)! + calculatedBill
            var newConsumptions:[String?] = user.consumptions
            let stringCurrentConsumption = String(newConsumption)
            newConsumptions.append(stringCurrentConsumption)
            
            var newBillPrices:[String?] = user.billPrices
            let stringnewBillPrice = String(calculatedBill)
            newBillPrices.append(stringnewBillPrice)
            
            interactor.updateUserConsumption(model: user, billPrices: newBillPrices, consumptions: newConsumptions, cost: String(newTotalCost))
        }
    }
    
    func setData(user: InternalUserModel?, currentConsumptionVal: Int){
        currentConsumption.text = "Current Read Value:\(currentConsumptionVal)"
        if let lastReading = interactor.user?.consumptions.last {
            
            previousConsumption.text = "Previous Read:\(lastReading ?? "0")"
            if let currentConsumption = currentConsumption.text, let previousConsumption = previousConsumption.text{
                let difference = interactor.findDifference(currentValue: currentConsumptionVal, previousValue: lastReading ?? "")
                differenceLabel.text = "\(currentConsumption) - \(previousConsumption) = \(difference)"
                let bill = interactor.calculateBill(difference: difference)
                self.calculatedBill = bill
                
                costBill.text = "Current Bill:\(bill)$"
                if let total = user?.calculatedCost {
                    totalBillLabel.text = "TOTAL BILL: \(total)$"
                }
            }
        }
    }
    
    
    func setUI() {
        readingsTable.delegate = self
        readingsTable.dataSource = self
        previousConsumption.font = infoTitleLabelFont
        currentConsumption.font = infoTitleLabelFont
        differenceLabel.font = infoTitleLabelFont
        costBill.font = totalBilFont
        totalBillLabel.font = totalBilFont
        billTableTitle.font = tableHeaderFont
    }
    
    func setConstraints(){
       
        view.addSubview(previousConsumption)
        previousConsumption.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(45)
            make.width.equalToSuperview()
            make.height.equalTo(30)
        }
        
        view.addSubview(currentConsumption)
        currentConsumption.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(previousConsumption.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(30)
        }
        
        view.addSubview(differenceLabel)
        differenceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(currentConsumption.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(30)
        }
        
        view.addSubview(costBill)
        costBill.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(differenceLabel.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(30)
        }
        
        
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
        }
        
        view.addSubview(totalBillLabel)
        totalBillLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(saveButton.snp.height)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.bottom.equalTo(saveButton.snp.top).offset(-30)
        }
        
        view.addSubview(readingsTable)
        readingsTable.snp.makeConstraints { make in
            make.bottom.equalTo(totalBillLabel.snp.top).offset(-30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        view.addSubview(billTableTitle)
        billTableTitle.snp.makeConstraints { make in
            make.bottom.equalTo(readingsTable.snp.top).offset(-3)
            make.centerX.equalTo(readingsTable.snp.centerX)
            make.height.equalTo(30)
            make.width.equalToSuperview()
        }
    }
}

extension CustomerHistoryViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return interactor.rowHeightFor(indexPath: indexPath)
    }
}

extension CustomerHistoryViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.numberOfRow(in: readingsTable)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return interactor.createReadingCell(tableView: tableView, indexPath: indexPath)
        
    }

}


