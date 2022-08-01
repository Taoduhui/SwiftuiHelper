//
//  LongPressButton.swift
//  test1
//
//  Created by kagarikoumei on 2022/4/12.
//

import SwiftUI

enum LpButtonStyle{
    case LeftCount
    case RightCount
    case CenterCount
    case NoneCount
    case NoCounter
}

class LongPressButtonProps{
    public var _buttonStyle = LpButtonStyle.CenterCount
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

struct LongPressButton: View {
    @State private var LongPreesedTimer:Timer?
    @State private var IsPressing = false
    var Countdown:TimeInterval=0
    var ContentText:String
    @State private var Counter:TimeInterval = 0
    @State private var Content = ""
    private var Props = LongPressButtonProps()
    @State private var _onPressedEvent:(()->Void)?
    @State private var _onCountTrigEvent:(()->Void)?
    @State private var _onTimeoutEvent:(()->Void)?
    @State private var _onReleaseEvent:(()->Void)?
    
    
    init(count:TimeInterval,interval:TimeInterval,_content:String){
        Countdown = count
        Props._timerInterval = interval
        ContentText = _content
    }
    
    init(count:TimeInterval,_content:String){
        Countdown = count
        ContentText = _content
    }
    
    init(content:String){
        ContentText = content
        Props._buttonStyle = LpButtonStyle.NoCounter
    }
    
    var body: some View {
        Button(action:{}){
            HStack{
                if (Props._buttonStyle == LpButtonStyle.CenterCount) {
                    ZStack{
                        Text(Content).opacity(IsPressing ? 0.2 : 1.0)
                        if IsPressing {
                            Text(String(Counter+1)).padding(.leading,2).opacity(1)
                        }
                    }
                }
                else if(Props._buttonStyle == LpButtonStyle.LeftCount){
                    if IsPressing {
                        Text(String(Counter+1)).padding(.leading,2)
                    }
                    Text(Content)
                }
                else if(Props._buttonStyle == LpButtonStyle.RightCount){
                    Text(Content)
                    if IsPressing {
                        Text(String(Counter+1)).padding(.leading,2)
                    }
                }
                else if(Props._buttonStyle == LpButtonStyle.NoneCount || Props._buttonStyle == LpButtonStyle.NoCounter){
                    Text(Content)
                }
            }.frame(alignment:.center)
        }.simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged({ _ in
                    if(!IsPressing){
                        Props.PressedEvent()
                        if(Props._buttonStyle != LpButtonStyle.NoCounter){
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
                        }
                        LongPreesedTimer!.fire()
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
            Content = ContentText
        })
    }
    
    public func interval(_ t:TimeInterval)->LongPressButton{
        Props._timerInterval = t;
        return self
    }
    
    public func onPressed(_ action:@escaping ()->Void)->LongPressButton{
        Props._onPressedEvent = action
        return self
    }
    public func onCounting(_ action:@escaping ()->Void)->LongPressButton{
        Props._onCountTrigEvent = action
        return self
    }
    public func onTimeout(_ action:@escaping ()->Void)->LongPressButton{
        Props._onTimeoutEvent = action
        return self
    }
    public func onRelease(_ action:@escaping ()->Void)->LongPressButton{
        Props._onReleaseEvent = action
        return self
    }
    public func Style(_ style:LpButtonStyle)->LongPressButton{
        Props._buttonStyle = style
        return self
    }
}

struct LongPressButton_Previews: PreviewProvider {
    static var previews: some View {
        LongPressButton(count: 2,_content: "test")
    }
}
