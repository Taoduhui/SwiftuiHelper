//
//  Formatter.swift
//  test1
//
//  Created by kagarikoumei on 2022/6/14.
//

import Foundation

public let decimalFormatter: NumberFormatter = {
//    let formatter = MyNumberFormatter()
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.generatesDecimalNumbers = true
    return formatter
}()

public func FixedDecimalFormatter(_ fixed:Int)->NumberFormatter{
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.generatesDecimalNumbers = true
    formatter.maximumFractionDigits = fixed
    formatter.minimumFractionDigits = fixed
    return formatter
}
