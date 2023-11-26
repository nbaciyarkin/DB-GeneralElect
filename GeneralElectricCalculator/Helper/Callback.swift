//
//  Callback.swift
//  GeneralElectricCalculator
//
//  Created by Yarkın Gazibaba on 3.06.2023.
//

import Foundation
public typealias Callback = () -> Void
public typealias CallbackString = (_ result: String) -> Void
public typealias CallbackInt = (_ result: Int) -> Void
public typealias CallbackBool = (_ result: Bool) -> Void
public typealias CallbackGeneric<T> = (_ result: T) -> Void

