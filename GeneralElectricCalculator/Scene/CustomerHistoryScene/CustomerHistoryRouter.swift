//
//  CustomeHistoryrInteractor.swift
//  GeneralElectricCalculator
//
//  Created by Yarkın Gazibaba on 3.06.2023.
//

import Foundation
import UIKit

class CustomerHistoryRouter {
    
    static func showCustomerHistory(currentViewController: UIViewController, nextViewController: UIViewController) {
        currentViewController.present(nextViewController, animated: true)
    }
    static func dissmissCustomerHistroyScene(currentviewController: UIViewController) {
        currentviewController.dismiss(animated: true)
    }
}
