//
//  SelectionView.swift
//  test1
//
//  Created by kagarikoumei on 2022/5/28.
//

import SwiftUI



class SelectionItem:Identifiable{
    var label:String = ""
    var item:Any
    
    init(_ _label:String,_ _item:Any){
        label = _label
        item = _item
    }
}

class SelectionViewEventArgs{
    var OnFinished:(_ args:SelectionViewEventArgs)->Void = {_ in}
    var SelectedItems:[SelectionItem] = []
    var GoBack:()->Void = {}
}

class SelectionViewProps:ObservableObject{
    @Published var items:[SelectionItem] = []
    @Published var searchKey = ""
    @Published var SelectedItems:[SelectionItem] = []
    var EventArgs = SelectionViewEventArgs()
}

struct SelectionView: View {
    
    @ObservedObject var props = SelectionViewProps()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    func GoBack(){ DispatchQueue.main.async{presentationMode.wrappedValue.dismiss()}}
    
    @State var ManualRedraw = 0
    
    func Assign(_ items:[SelectionItem])->SelectionView{
        props.items = items
        return self
    }
    
    func Assign(_ items:[SelectionItem],_ selecteditems:[SelectionItem])->SelectionView{
        props.items = items
        props.SelectedItems = selecteditems
        return self
    }
    
    func OnFinished(_ action:@escaping (_ args:SelectionViewEventArgs)->Void)->SelectionView{
        props.EventArgs.OnFinished = action
        return self
    }
    
    var body: some View {
        VStack{
            TextField("搜索",text: $props.searchKey)
                .multilineTextAlignment(.center)
                .padding(5)
                .background(Color(UIColor(hex: 0xECECEC))).cornerRadius(10)
                .padding()
            ScrollView{
                ForEach(props.items.indices,id:\.self){ i in
                //ForEach($props.items){ $item in
                    let item = props.items[i]
                    if props.searchKey == "" || item.label.contains(props.searchKey) {
                        HStack{
                            Text(item.label)
                            Spacer()
                            Button(action:{
                                if props.SelectedItems.contains(where: {r in r.label == item.label}) {
                                    props.SelectedItems.removeAll(where: {r in r.label == item.label})
                                }else {
                                    props.SelectedItems.append(item)
                                }
                            }){
                                if props.SelectedItems.contains(where: {r in r.label == item.label}) {
                                    Image(systemName: "checkmark.circle.fill")
                                }else {
                                    Image(systemName: "checkmark.circle")
                                }
                            }
                        }.padding(10).padding(.leading,15).padding(.trailing,15)
                        Divider()
                    }
                }
            }
            .frame(maxWidth:.infinity,alignment:.topLeading)
        }
        .toolbar {
            ToolbarItem(id: "finished", placement: .navigationBarTrailing) {
                Button(action: {
                    props.EventArgs.GoBack = self.GoBack
                    props.EventArgs.SelectedItems = props.SelectedItems
                    props.EventArgs.OnFinished(props.EventArgs)
                }, label: {
                    Text("完成")
                })
            }
        }
    }
}

struct SelectionView_Previews: PreviewProvider {
    static var previews: some View {
        var s:[SelectionItem] = []
        ForEach(0..<50){ i in
            let _ = s.append(SelectionItem("\(i)", "\(i)"))
        }
        SelectionView().Assign(s)
    }
}
