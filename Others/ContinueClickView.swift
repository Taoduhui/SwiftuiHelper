//
//  ContinueClickView.swift
//  test1
//
//  Created by kagarikoumei on 2022/6/5.
//

import SwiftUI
//
//class MultipleClicker {
//
//    var click_cnt = 3
//    var require_cnt = 3
//    var maxInterval:TimeInterval = 0.3
//    var clicked = false
//    var cancel_timer:()->Void = {}
//    var _onTrigger:()->Void = {}
//
//    init(_ require_cnt:Int,_ maxInterval:TimeInterval,_ ontrigger:@escaping ()->Void){
//        require_cnt = require_cnt
//        maxInterval = maxInterval
//        _onTrigger = ontrigger
//    }
//
//    func Click(){
//        if clicked == false {
//            cancel_timer = SetTimeout({
//                props.clicked = false
//                props.click_cnt = props.require_cnt
//            }, props.maxInterval)
//        }
//       clicked = true
//        click_cnt = click_cnt - 1
//        OnTaped()
//        if click_cnt == 0 {
//            cancel_timer()
//            _onTrigger()
//            clicked = false
//            click_cnt = require_cnt
//        }
//    }
//
//}

class ContinueClickViewProps:ObservableObject{
    var click_cnt = 3
    var require_cnt = 3
    var maxInterval:TimeInterval = 0.3
    var clicked = false
    var cancel_timer:()->Void = {}
}

class ContinueClickViewEvents:ObservableObject{
    var OnTaped:()->Void = {}
    var OnTrigger:()->Void = {}
}

struct ContinueClickView<V:View>: View {
    var ContentView: V
    @ObservedObject var props = ContinueClickViewProps()
    @ObservedObject var events = ContinueClickViewEvents()
    
    init(_ require_cnt:Int,_ maxInterval:TimeInterval,@ViewBuilder _ content: () -> V){
        self.ContentView = content()
        props.require_cnt = require_cnt
        props.maxInterval = maxInterval
    }
    
    func OnTaped(_ action:@escaping ()->Void)->ContinueClickView{
        events.OnTaped = action
        return self
    }
    
    func OnTrigger(_ action:@escaping ()->Void)->ContinueClickView{
        events.OnTrigger = action
        return self
    }
    
    var body: some View {
        VStack{
            ContentView
        }.onTapGesture {
//            if props.clicked == false {
//                props.cancel_timer = SetTimeout({
//                    props.clicked = false
//                    props.click_cnt = props.require_cnt
//                }, props.maxInterval)
//            }
            props.clicked = true
            props.click_cnt = props.click_cnt - 1
            events.OnTaped()
            if props.click_cnt == 0 {
                props.cancel_timer()
                events.OnTrigger()
                props.clicked = false
                props.click_cnt = props.require_cnt
            }
        }
    }
}

struct ContinueClickView_Previews: PreviewProvider {
    static var previews: some View {
        ContinueClickView(2,0.3,{
            Text("123456")
        })
    }
}
