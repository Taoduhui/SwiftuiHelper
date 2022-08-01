//
//  LongPressView.swift
//  test1
//
//  Created by kagarikoumei on 2022/4/20.
//

import Foundation

//
//  LongPressView.swift
//  test1
//
//  Created by kagarikoumei on 2022/4/12.
//

import SwiftUI

enum LpViewStyle{
    case LeftCount
    case RightCount
    case CenterCount
    case NoneCount
    case NoCounter
}

class LongPressViewProps{
    public var _viewStyle = LpViewStyle.CenterCount
    public var _timerInterval:TimeInterval = 1
    public var _onPressedEvent:(()->Void)?
    public var _onCountTrigEvent:(()->Void)?
    public var _onTimeoutEvent:(()->Void)?
    public var _onReleaseEvent:(()->Void)?
    
    public func PressedEvent(){
        if(nil != _onPressedEvent){_onPressedEvent?()}
    }
    
    public func CountTrigEvent(){
        if(nil != _onCountTrigEvent){_onCountTrigEvent?()}
    }
    
    public func TimeoutEvent(){
        if(nil != _onTimeoutEvent){ _onTimeoutEvent?()}
    }
    
    public func ReleaseEvent(){
        if(nil != _onReleaseEvent){_onReleaseEvent?()}
    }
}

struct LongPressView<V: View>: View {
    @State private var LongPreesedTimer:Timer?
    @State private var IsPressing = false
    var Countdown:TimeInterval=0
    //var ContentText:String
    var ContentView: V
    @State private var Counter:TimeInterval = 0
    @State private var Content = ""
    private var Props = LongPressViewProps()
    @State private var _onPressedEvent:(()->Void)?
    @State private var _onCountTrigEvent:(()->Void)?
    @State private var _onTimeoutEvent:(()->Void)?
    @State private var _onReleaseEvent:(()->Void)?
    
    
    init(count:TimeInterval,interval:TimeInterval,@ViewBuilder content: () -> V){
        Countdown = count
        Props._timerInterval = interval
        ContentView = content()
    }
    
    init(count:TimeInterval,@ViewBuilder content: () -> V){
        Countdown = count
        ContentView = content()
    }
    
    init(@ViewBuilder content: () -> V){
        ContentView = content()
        Props._viewStyle = LpViewStyle.NoCounter
    }
    
    var body: some View {
        Button(action:{}){
            HStack{
                if (Props._viewStyle == LpViewStyle.CenterCount) {
                    ZStack{
                        ContentView.opacity(IsPressing ? 0.2 : 1.0)
                        //Text(Content).opacity(IsPressing ? 0.2 : 1.0)
                        if IsPressing {
                            Text(String(Counter+1)).padding(.leading,2).opacity(1)
                        }
                    }
                }
                else if(Props._viewStyle == LpViewStyle.LeftCount){
                    if IsPressing {
                        Text(String(Counter+1)).padding(.leading,2)
                    }
                    ContentView
                    //Text(Content)
                }
                else if(Props._viewStyle == LpViewStyle.RightCount){
                    ContentView
                    //Text(Content)
                    if IsPressing {
                        Text(String(Counter+1)).padding(.leading,2)
                    }
                }
                else if(Props._viewStyle == LpViewStyle.NoneCount || Props._viewStyle == LpViewStyle.NoCounter){
                    //Text(Content)
                    ContentView
                }
            }.frame(alignment:.center)
        }.buttonStyle(.plain)
            .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged({ _ in
                    if(!IsPressing){
                        Props.PressedEvent()
                        if(Props._viewStyle != LpViewStyle.NoCounter){
                            if(nil == LongPreesedTimer){
                                LongPreesedTimer = Timer(timeInterval: Props._timerInterval, repeats: true, block: {t in
                                    if(Counter <= 0){
                                        IsPressing = false
                                        Counter = Countdown
                                        LongPreesedTimer?.invalidate()
                                        LongPreesedTimer = nil
                                        Props.TimeoutEvent()
                                    }
                                    Props.CountTrigEvent()
                                    Counter -= Props._timerInterval
                                })
                                LongPreesedTimer!.tolerance = Props._timerInterval/10
                                RunLoop.current.add(LongPreesedTimer!, forMode: .default)
                            }
                            LongPreesedTimer!.fire()
                        }
                    }
                    withAnimation(.easeOut(duration: Props._timerInterval/2), {
                        IsPressing = true
                    })
                })
                .onEnded({ _ in
                    IsPressing = false
                    Counter = Countdown
                    LongPreesedTimer?.invalidate()
                    LongPreesedTimer = nil
                    Props.ReleaseEvent()
                })
        ).onAppear(perform: {
            Counter = Countdown
        })
    }
    
    public func interval(_ t:TimeInterval)->LongPressView{
        Props._timerInterval = t;
        return self
    }
    
    public func onPressed(_ action:@escaping ()->Void)->LongPressView{
        Props._onPressedEvent = action
        return self
    }
    public func onCounting(_ action:@escaping ()->Void)->LongPressView{
        Props._onCountTrigEvent = action
        return self
    }
    public func onTimeout(_ action:@escaping ()->Void)->LongPressView{
        Props._onTimeoutEvent = action
        return self
    }
    public func onRelease(_ action:@escaping ()->Void)->LongPressView{
        Props._onReleaseEvent = action
        return self
    }
    public func Style(_ style:LpViewStyle)->LongPressView{
        Props._viewStyle = style
        return self
    }
}

struct LongPressView_Previews: PreviewProvider {
    static var previews: some View {
        LongPressView(count: 3.0, interval: 1.0) {
            Text("123456")
        }
    }
}
