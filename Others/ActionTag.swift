//
//  ActionTag.swift
//  test1
//
//  Created by kagarikoumei on 2022/5/21.
//

import SwiftUI

class ActionTagProps:ObservableObject{
    @Published var tag:String = ""
    @Published var ActionIcon:String = "xmark"
    var OnTapped:()->Void = {}
}

struct ActionTag: View {
    @ObservedObject var props = ActionTagProps()
    
    init(_ tag:String){
        props.tag = tag
    }
    
    func icon(_ systemName:String)->ActionTag{
        props.ActionIcon = systemName
        return self
    }
    
    func OnTapped(_ action:@escaping ()->Void)->ActionTag{
        props.OnTapped = action
        return self
    }
    
    var body: some View {
        HStack{
            Text(props.tag)
            Divider()
            Button(action: {
                props.OnTapped()
            }, label: {
                Image(systemName: props.ActionIcon)
            })
        }
        .padding(8)
        .frame( height: 40)
        .border(Color.blue, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
    }
}

struct ActionTag_Previews: PreviewProvider {
    static var previews: some View {
        ActionTag("123")
    }
}
