//
//  Referenceable.swift
//  test1
//
//  Created by kagarikoumei on 2022/6/25.
//

import Foundation
import SwiftUI

 
protocol Referenceable:View{
    
}

extension Referenceable{
    func Ref(_ action:@escaping (_ refObj:Any)->Void)->some View{
        action(self)
        return self
    }
}
