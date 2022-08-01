//
//  SetTimeout.swift
//  test1
//
//  Created by kagarikoumei on 2022/6/1.
//

import Foundation



func SetTimeout(_ action:@escaping ()->Void,_ timeout_second:TimeInterval){
    let timer = Timer(timeInterval: timeout_second, repeats: false, block: { t in
        action()
    })
    timer.tolerance = timeout_second/10
    RunLoop.current.add(timer, forMode: .default)
}
