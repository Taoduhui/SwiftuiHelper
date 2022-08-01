//
//  MultiSelection.swift
//  test1
//
//  Created by kagarikoumei on 2022/5/21.
//

import SwiftUI

class MultiSelectionItem:Identifiable{
    var label:String = ""
    var item:Any
    
    init(_ _label:String,_ _item:Any){
        label = _label
        item = _item
    }
}

class MultiSelectionDelegate {
    
    var rawValue = ""
    
    var SelectedItems:[MultiSelectionItem] = []
    
    var Suggestion:[MultiSelectionItem] = []
    
    var OnModified:(_ oldstr:String,_ newstr:String)->String = {(_,newstr) in return newstr}
    
    var OnSuggestion:(_ val:String)->[MultiSelectionItem] = {_ in  return []}
    
    var OnSelected:(_ item:MultiSelectionItem)->Void = {_ in}
    
    var OnSelectionChanged:(_ items:[MultiSelectionItem])->Void = {_ in}
    
    var Value:String {
        get{
            return rawValue
        }
        set{
            rawValue = OnModified(rawValue,newValue)
            withAnimation(.easeInOut(duration: 0.5), {
                Suggestion = OnSuggestion(rawValue)
            })
        }
    }
}

class MultiSelectionProps:ObservableObject{
    @Published var Label = ""
    @Published var TipString = ""
    @Published var HasBottomDivider = false
    @Published var delegate = MultiSelectionDelegate()
    @Published var SelectedItems:[MultiSelectionItem] = []
}

struct MultiSelection: View {
    @ObservedObject var props = MultiSelectionProps()
    @Environment(\.colorScheme) var colorScheme
    
    func Label(_ lable:String)->MultiSelection{
        props.Label = lable
        return self
    }
    
    func Tips(_ tips:String)->MultiSelection{
        props.TipString = tips
        return self
    }
    
    func Divided()->MultiSelection{
        props.HasBottomDivider = true
        return self
    }
    
    func OnSelected(_ action:@escaping (_ item:MultiSelectionItem)->Void)->MultiSelection{
        props.delegate.OnSelected = action
        return self
    }
    
    func OnModified(_ action:@escaping (_ oldstr:String,_ newstr:String)->String)->MultiSelection{
        props.delegate.OnModified = action
        return self
    }
    
    func OnSuggeestion(_ action:@escaping (_ val:String)->[MultiSelectionItem])->MultiSelection{
        props.delegate.OnSuggestion = action
        return self
    }
    
    func OnSelectionChanged(_ action:@escaping (_ items:[MultiSelectionItem])->Void)->MultiSelection{
        props.delegate.OnSelectionChanged = action
        return self
    }
    
    var body: some View {
        VStack{
            HStack{
                Text(props.Label)
                Spacer()
                TextField("",text:$props.delegate.Value)
                    .multilineTextAlignment(.trailing)
            }.padding(.leading).padding(.trailing).padding(10)
            ZStack{
                VStack{
                    if props.delegate.Suggestion.count > 0 {
                        VStack{
                            ForEach(props.delegate.Suggestion.indices,id:\.self){ i in
                            //ForEach($props.delegate.Suggestion){ $suggetion in
                                let suggetion = props.delegate.Suggestion[i]
                                Button(action: {
                                    props.delegate.SelectedItems.append(suggetion)
                                    props.delegate.OnSelected(suggetion)
                                    props.delegate.Value = ""
                                    withAnimation(.easeOut(duration: 0.5), {
                                        props.SelectedItems = props.delegate.SelectedItems
                                    })
                                    props.delegate.OnSelectionChanged(props.delegate.SelectedItems)
                                }, label: {
                                    HStack{
                                        Text(suggetion.label)
                                        Spacer()
                                        Image(systemName: "plus")
                                    }.padding(5).frame(maxWidth:.infinity,alignment:.center)
                                })
                            }
                        }
                        .padding(10)
                        .background(colorScheme == .dark ? Color.black : Color.white)
                        .padding(.trailing,20).padding(.leading,20)
                        .frame(alignment: .top)
                    }
//                    ScrollView(.vertical){
//                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4)) {
                    ForEach(props.SelectedItems.indices,id:\.self){ i in
                                let selected = props.SelectedItems[i]
                                ActionTag(selected.label).OnTapped {
                                    props.delegate.SelectedItems.removeAll(where: {item in item.id == selected.id})
                                    withAnimation(.easeOut(duration: 0.5), {
                                        props.SelectedItems = props.delegate.SelectedItems
                                    })
                                    props.delegate.OnSelectionChanged(props.delegate.SelectedItems)
                                }
                                Text(".")
                            }
                    
                    if props.TipString != "" {
                        ZStack{
                            Text(props.TipString)
                                .font(.system(size: 12))
                                .background(Color.white)
                                .padding(5)
                            Divider()
                        }
                    }
                    if props.HasBottomDivider {
                        Divider()
                    }
                }
            }.frame(alignment: .top)
        }
        
    }
}

struct MultiSelection_Previews: PreviewProvider {
    static var previews: some View {
        MultiSelection()
            .Label("123")
            .Tips("123tip")
            .Divided()
    }
}
