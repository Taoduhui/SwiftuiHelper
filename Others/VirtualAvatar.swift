//
//  VirtualAvatar.swift
//  test1
//
//  Created by kagarikoumei on 2022/5/16.
//

import SwiftUI



private class HashColorResource{
    static var fgcolor = UIColor { c in
        if c.userInterfaceStyle == .dark {
            return UIColor(r: 0, g: 50, b: 98, alpha: 1)
        }else {
            return UIColor(r: 0, g: 50, b: 98, alpha: 1)
        }
    }
    static var colors:[UIColor] = [
        UIColor(r: 83, g: 186, b: 196, alpha: 1),
        UIColor(r: 235, g: 109, b: 177, alpha: 1),
        UIColor(r: 165, g: 165, b: 172, alpha: 1),
        UIColor(r: 169, g: 116, b: 97, alpha: 1),
        UIColor(r: 225, g: 71, b: 67, alpha: 1),
        UIColor(r: 237, g: 205, b: 49, alpha: 1),
        UIColor(r: 234, g: 126, b: 48, alpha: 1),
        UIColor(r: 155, g: 120, b: 216, alpha: 1)
    ]
    
    static var systemColors:[UIColor] = [
        .systemRed,.systemBlue,.systemFill,.systemGray,.systemPink,
        .systemTeal,.systemBrown,.systemIndigo,.systemGreen,.systemOrange,.systemPurple,.systemYellow
    ]
    
    static func GetColor(_ hash:Int)->UIColor{
        let i = hash % colors.count
        return colors[i]
    }
    
    static func GetColor(_ str:String)->UIColor{
        let i = str.hash % colors.count
        return colors[i]
    }
    
    static func GetImage(_ str:String)->Image{
        return Image(uiImage: GetColor(str).imageValue)
    }
}



public extension UIColor {
    var imageValue: UIImage {
        let rect = CGRect(origin: .zero, size: CGSize(width: 1, height: 1))
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(self.cgColor)
        context.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(r:Int,g:Int,b:Int, alpha: CGFloat = 1.0) {
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}


class VirtualAvatarProps:ObservableObject{
    static var LastColor = 0
    
    @Published var name = ""
    @Published var first = ""
    @Published var size = 10
    @Published var shape = VirtualAvatarShape.Rect
}

enum VirtualAvatarShape{
    case Circle
    case Rounded
    case Rect
}

struct VirtualAvatar: View {
    @ObservedObject var props = VirtualAvatarProps()
    
    init(_ name:String){
        props.name = name
        if name != "" {
            props.first.append(name.first!)
        }
    }
    
    init(_ name:String,_ size:Int){
        props.name = name
        if name != "" {
            props.first.append(name.first!)
        }
        props.size = size
    }
    
    func Shape(_ shape:VirtualAvatarShape)->VirtualAvatar{
        props.shape = shape
        return self
    }
    
    var bgColor:some View{
        VStack{
            if props.shape == VirtualAvatarShape.Circle {
                HashColorResource.GetImage(props.name).resizable().clipShape(Circle()).scaledToFit()
            }
            else if props.shape == VirtualAvatarShape.Rounded {
                HashColorResource.GetImage(props.name).resizable().scaledToFit().cornerRadius(10)
            }
            else {
                HashColorResource.GetImage(props.name).resizable().scaledToFit()
            }
        }
    }
    
    var body: some View {
        VStack{
            Text(props.first)
                .font(.system(size: CGFloat(props.size)))
                .foregroundColor(Color(HashColorResource.fgcolor))
        }
        .padding(CGFloat(props.size))
        .background(bgColor)
    }
}

struct VirtualAvatar_Previews: PreviewProvider {
    static var previews: some View {
        VirtualAvatar("1123",20).Shape(VirtualAvatarShape.Circle)
    }
}
