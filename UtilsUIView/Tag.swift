//
//  Tag.swift
//  test1
//
//  Created by kagarikoumei on 2022/2/1.
//

import SwiftUI

struct Tag: View {
    var Content:String
    var BgColor:Color
    var body: some View {
        Group {
            Text(Content).foregroundColor(Color.white).font(.system(size: 12))
        }.padding(EdgeInsets(top: 0,
                             leading: 10,
                             bottom: 0,
                             trailing: 10))
            .background(BgColor)
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .padding(.trailing,15.0)
    }
}

struct Tag_Previews: PreviewProvider {
    static var previews: some View {
        Tag(Content: "teacher", BgColor: Color.orange)
    }
}
