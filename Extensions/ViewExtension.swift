//
//  ViewExtends.swift
//  test1
//
//  Created by kagarikoumei on 2022/5/7.
//

import SwiftUI




extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
    
    func modal<v:View>(isShow:Binding<Bool>,content: () -> v) -> some View {
        self.modifier(ModalModifier(isShow: isShow, content: content))
    }
}

private struct ModalModifier<v:View>: ViewModifier {
    
    @Binding var IsShow:Bool
    
    var contentView:v
    
    init(isShow:Binding<Bool>,@ViewBuilder content: () -> v){
        self._IsShow = isShow
        contentView = content()
    }
    
    var overlayController:some View{
        ZStack{
            Button(action: {
                IsShow = false
            }, label: {})
                .frame(maxWidth:.infinity,maxHeight:.infinity,alignment:.center)
                .background(VisualEffect(style: .systemUltraThinMaterial))
            contentView
        }
    }
    
    func body(content: Content) -> some View {
        Group{
            if IsShow == true {
                if #available(iOS 15, *) {
                    content.overlay{
                        overlayController
                    }
                }else{
                    content.overlay(overlayController)
                }
            }else{
                content
            }
        }
    }
}
