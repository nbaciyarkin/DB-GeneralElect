//
//  BaseViewController.swift
//  GeneralElectricCalculator
//
//  Created by Yarkın Gazibaba on 3.06.2023.
//

import Foundation
import UIKit
class BaseViewController: UIViewController {
    
    lazy var hideNavbar = false
    var callbackBackButton: Callback?
    var callbackCloseButton: Callback?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(hideNavbar, animated: false)
    }
    
    func setHeaderOnlyTitle(title: String) {
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        let titleLabel = UILabel()
        titleLabel.text = title.uppercased()
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = .black
        self.navigationItem.titleView = titleLabel
    }
    
    func hideKeyboardWhenTappedAround() {
           let tap = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.dismissKeyboard))
           tap.cancelsTouchesInView = false
           view.addGestureRecognizer(tap)
       }
       
       @objc func dismissKeyboard() {
           view.endEditing(true)
       }
    
    func setHeaderNativeBackTitleWhite(title: String) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        
        let backButton = UIBarButtonItem(image: ImageConstants.backArrow, style: .plain, target: self, action: #selector(btnBackClicked))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        let titleLabel = UILabel()
        titleLabel.text = title.uppercased()
        titleLabel.textColor = Constants.darkGray
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.navigationItem.titleView = titleLabel
    }
    
    func route(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnBackClicked() {
        self.navigationController?.popViewController(animated: true)
        self.callbackBackButton?()
    }
    
    func onReturn(callback: Callback?) {
        self.callbackBackButton = callback
    }
    
    func onClose(callback: Callback?) {
        self.callbackCloseButton = callback
    }
}

extension BaseViewController {
    func configureEmptyContextMenu(customerNumber: String) -> UIContextMenuConfiguration{
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            let edit = UIAction(title: "Add Notification List", image: UIImage(systemName: "bell"), identifier: nil, discoverabilityTitle: nil, state: .off) { (_) in
                print("edit button clicked")
            }
            return UIMenu(title:"\(customerNumber) founded", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [edit])
        }
        return context
    }
}

