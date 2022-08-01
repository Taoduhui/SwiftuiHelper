//
//  MultiplePicker.swift
//  test1
//
//  Created by kagarikoumei on 2022/6/23.
//

import SwiftUI

class MultiplePickerItem:Identifiable{
    var label:String = ""
    var value:Any? = nil
    
}

struct MultiplePicker: View {
    
    @State var PickerItems:[MultiplePickerItem] = []
    @State var SelectedItems:[MultiplePickerItem] = []
    @State var ShowOverlay = false
    
    init(items:[MultiplePickerItem]){

    }
    
    var PickerBtn: some View{
        Button(action: {
            ShowOverlay = true
        }, label: {
            if SelectedItems.count == 0 {
                Text("请选择")
            }else{
                ForEach($SelectedItems){ $item in
                    Text(" \(item.label)")
                }
            }
        })
    }
    
    var PickerOverlay:some View{
        VStack{
            Text("123456")
        }
        .zIndex(100)
        .frame(maxWidth:.infinity,maxHeight:.infinity,alignment:.bottom)
        .background(VisualEffect(style: .systemUltraThinMaterial))
    }
    

    
    var body: some View {
        Group{
            PickerBtn.actionSheet(isPresented: $ShowOverlay) {
                ActionSheet(
                    title: Text("Food alert!"),
                    message: Text("You have made a selection"),
                    buttons: [
                        .cancel(),
                        .destructive(Text("Change to 🍑")) {},
                        .default(Text("Confirm")) {  }
                    ]
                )
            }
                 
        }
    }
}

struct MultiplePicker_Previews: PreviewProvider {
    static var previews: some View {
        MultiplePicker(items:[])
    }
}
