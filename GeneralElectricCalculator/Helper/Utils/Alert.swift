//
//  Alert.swift
//  GeneralElectricCalculator
//
//  Created by Yarkın Gazibaba on 3.06.2023.
//

import Foundation
import SwiftMessages
import UIKit

class Alert {
    
    class func success(title: String?, text: String?) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.success)
        view.configureTheme(backgroundColor: UIColor.systemGreen, foregroundColor: .white)
        view.button?.isHidden = true
        view.configureDropShadow()
        view.configureContent(title: title ?? "", body: text ?? "Localized.", iconImage: UIImage(named: "arrow")!)
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        view.backgroundView.layer.cornerRadius = 10
        SwiftMessages.show(view: view)
    }
    
    class func error(title: String?, text: String?) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.error)
        view.configureTheme(backgroundColor: UIColor.systemRed, foregroundColor: .white)
        view.button?.isHidden = true
        view.configureDropShadow()
        view.configureContent(title: title ?? "", body: text ?? "error", iconImage: UIImage(named: "error")!)
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        view.backgroundView.layer.cornerRadius = 10
        SwiftMessages.show(view: view)
    }

    class func warning(title: String?, text: String?) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.error)
        view.configureTheme(backgroundColor: UIColor.darkGray, foregroundColor: UIColor.blue)
        view.button?.isHidden = true
        view.configureDropShadow()
        view.configureContent(title: title ?? "", body: text ?? "warning", iconImage: UIImage(named: "info-warning")!)
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        view.backgroundView.layer.cornerRadius = 10
        SwiftMessages.show(view: view)
    }
}



