//
//  ViewController.swift
//  GeneralElectricCalculator
//
//  Created by Yarkın Gazibaba on 3.06.2023.
//

import UIKit
import SnapKit

class ConsumptionCalculatorvViewController: BaseViewController {
    
    var user: InternalUserModel?
    
    
    
    let infoTitleLabelFont = UIFont(name: "Quicksand-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .bold)
    
    private var serviceNumberInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.açıkGri
        label.text = "Customer Service Info"
        label.font = UIFont(name: "Arial", size: 12)
        return label
    }()
    
    private var customerNumberTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.returnKeyType = .continue
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.keyboardType = .emailAddress
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        field.backgroundColor = UIColor(white: 1, alpha: 0.5)
        field.attributedPlaceholder = NSAttributedString(
            string: "Enter 10 Digits Customer Service Number",
            attributes: [NSAttributedString.Key.foregroundColor: Constants.darkGray?.withAlphaComponent(0.7) as Any]
        )
        return field
    }()
    
    private var currentMeterInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Current Meter"
        label.textColor = Constants.açıkGri
        
        return label
    }()
    
    private var currentMeterTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.returnKeyType = .continue
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.keyboardType = .numberPad
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        field.backgroundColor = UIColor(white: 1, alpha: 0.5)
        field.attributedPlaceholder = NSAttributedString(
            string: "Enter Current Meter Value",
            attributes: [NSAttributedString.Key.foregroundColor: Constants.darkGray?.withAlphaComponent(0.7) as Any]
        )
        return field
    }()
    
    let submitButton: AnimatedButton = {
        let btn = AnimatedButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("SUBMIT", for: .normal)
        btn.backgroundColor = .red
        btn.setTitleColor(Constants.darkGray, for: .normal)
        btn.titleLabel?.textAlignment = .right
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = cornerRadius
        btn.addTarget(self, action: #selector(submit_TUI), for: .touchUpInside)
        btn.titleLabel!.font = UIFont(name: "Arial" , size: 17)
        return btn
    }()

    let interactor = ConsumptionCalculatorInteractor()
    
    let HA123 = InternalUserModel(serviceNumber: "HA123HA123", consumptions: ["250"], billPrices: ["1700"], lastConsumption: "250", calculatedCost: "1700")
    
    let HA456 = InternalUserModel(serviceNumber: "HA456HA456", consumptions: ["510"], billPrices: ["3800"], lastConsumption: "510", calculatedCost: "3800")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        saveUser(user:HA123)
//        saveUser(user:HA456)
        
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = Constants.darkGray
        setUI()
            
        
    }
    
    @objc func submit_TUI() {
        if checkValidCurrentMeter(), checkValidCustomerNumber(),checkTenCharacters() {
            if let customerNumber = customerNumberTextField.text {
                user =  interactor.getUserWithServiceNumber(with: customerNumber)
                checkCurrentMeterGreaterPrevious()
            }
        }
    }
    

    private func saveUser(user: InternalUserModel){
        DatapersistenceManager.shared.saveUser(model: InternalUserModel(serviceNumber: user.serviceNumber, consumptions: user.consumptions, billPrices: user.billPrices, lastConsumption: user.lastConsumption, calculatedCost: user.calculatedCost)) { result in
            switch result{
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("created"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    func checkCurrentMeterGreaterPrevious(){
        if let user = user {
            if let currentMeter = currentMeterTextField.text{
                if !user.consumptions.isEmpty{
                    let lastConsumption =  Int((user.consumptions.last ?? "0") ?? "0") ?? 0
                    if lastConsumption <= Int(currentMeter) ?? 0 {
                        let vc = CustomerHistoryViewController()
                        vc.interactor.setData(serviceNumber: user.serviceNumber, currentConsumpitonMeter: Int(currentMeter))
                        CustomerHistoryRouter.showCustomerHistory(currentViewController: self, nextViewController: vc)
                    }
                    else {
                        Alert.warning(title: "Warning", text: "Current consupmtion value should be greater than old value OLD VALUE İS = \(lastConsumption)")
                    }
                }
                else {
                    let vc = CustomerHistoryViewController()
                    vc.interactor.setData(serviceNumber: user.serviceNumber, currentConsumpitonMeter: Int(currentMeter))
                    CustomerHistoryRouter.showCustomerHistory(currentViewController: self, nextViewController: vc)
                }
            }
        }
    }
    
    private func checkTenCharacters() -> Bool {
        var isValid = false
        if let currentMeterValue = customerNumberTextField.text {
            if interactor.isTextCountEqualToTen(currentMeterValue) {
                isValid = true
            } else {
                isValid = false
                Alert.error(title: "Warning", text: "Customer number should be 10 digits")
            }
        }
        return isValid
    }
    
    private func checkValidCustomerNumber() -> Bool{
        var isValid: Bool = false
        if let customerNumber = customerNumberTextField.text {
            if interactor.isAlphaNumeric(string: customerNumber) {
                isValid =  true
            }
            else {
                Alert.warning(title: "Warning", text: "Text shoul be Alpha Numeric Characters")
                isValid =  false
            }
        }
        return isValid
    }
    
    private func checkValidCurrentMeter() -> Bool{
        var isValid:Bool = false
        if let currentMeterValue = currentMeterTextField.text {
            if interactor.isPositiveCurrentMeterValue(currentMeter: Int(currentMeterValue) ?? 0){
                isValid = true
            }
            else {
                Alert.warning(title: "Warning", text: "Incorect Meter Values")
                isValid = false
            }
        }
        return isValid
    }
    
    private func setLabelFonts() {
        currentMeterInfoLabel.font = infoTitleLabelFont
        serviceNumberInfoLabel.font = infoTitleLabelFont
    }
    private func setUI() {
        setLabelFonts() 
        view.addSubview(customerNumberTextField)
        customerNumberTextField.delegate = self
        customerNumberTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-35)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        view.addSubview(currentMeterTextField)
        currentMeterTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(35)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-85)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(50)
        }
        view.addSubview(serviceNumberInfoLabel)
        serviceNumberInfoLabel.snp.makeConstraints { make in
            make.bottom.equalTo(customerNumberTextField.snp.top)
            make.leading.equalTo(customerNumberTextField.snp.leading)
            make.width.equalTo(customerNumberTextField.snp.width)
            make.height.equalTo(customerNumberTextField.snp.height).multipliedBy(0.5)
        }
        
        view.addSubview(currentMeterInfoLabel)
        currentMeterInfoLabel.snp.makeConstraints { make in
            make.bottom.equalTo(currentMeterTextField.snp.top)
            make.leading.equalTo(currentMeterTextField.snp.leading)
            make.width.equalTo(currentMeterTextField.snp.width)
            make.height.equalTo(currentMeterTextField.snp.height).multipliedBy(0.5)
        }
    }
}

extension ConsumptionCalculatorvViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.keyboardType = .asciiCapable
        print(textField.text)
        return true
    }
    
}

