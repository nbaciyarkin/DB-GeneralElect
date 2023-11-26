//
//  ViewController.swift
//  GeneralElectricCalculator
//
//  Created by Yarkın Gazibaba on 3.06.2023.
//

import UIKit

class ConsumptionCalculatorvViewController: UIViewController {
    
    private var mailTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.attributedPlaceholder = NSAttributedString(
            string: "Enter Mail",
            attributes: [NSAttributedString.Key.foregroundColor: Constants.darkGray?.withAlphaComponent(0.7)]
        )
        field.returnKeyType = .continue
        field.leftViewMode = .always
        // padding 10 pixel to text
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        field.backgroundColor = UIColor(white: 1, alpha: 0.5)
        return field
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    
    


}

