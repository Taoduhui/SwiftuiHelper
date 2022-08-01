//
//  CachedImage.swift
//  test1
//
//  Created by kagarikoumei on 2022/5/15.
//

import SwiftUI


class CachedImageManager{
    
    static let manager = CachedImageManager()
    
    var CachedImageDict = UserDefaultData(_key: "CachedImage")
    
    init(){
        if( CachedImageDict.Exist() == false ){
            
            try! CachedImageDict.Write(NSMutableDictionary())
        }
    }
    
    func GetCachedUrl(_ url:String)->String?{
        return try! CachedImageDict.Read()[url] as? String
    }
    
    func WriteCachedUrl(_ url:String,_ local:URL){
                         
    }
    
    
    
    func GetImage(_ url:String,_ callback:@escaping (_ data:Data)->Void)->Void{
        let CachedUrl = GetCachedUrl(url)
        if CachedUrl == nil {
            DownloadFile(url: url, Callback: { imgdata in
                
                let path = FileManager.default.urls(for: .documentDirectory,
                                                    in: .userDomainMask)[0].appendingPathComponent("\(UUID().uuidString).jpg")
                
                try! imgdata.write(to: path)

            }, Final: { err in
                if err != nil {
                    
                }
            })
        }else {
            let stringToSave = "The string I want to save"
            let path = FileManager.default.urls(for: .documentDirectory,
                                                in: .userDomainMask)[0].appendingPathComponent("myFile")
            
            if let stringData = stringToSave.data(using: .utf8) {
                try? stringData.write(to: path)
            }
        }
    }
}

struct CachedImage: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    
    
    func LoadImage(_ url:String)->CachedImage{
        

        
        return self
    }
    
    func DownloadJpeg(_ url:String){
        DownloadFile(url: url, Callback: { jpeg in
            
        }, Final: { _ in
            
        })
    }
    
    func documentDirectoryPath() -> URL? {
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        return path.first
    }
    
    func saveJpg(_ image: UIImage) {
        if let jpgData = image.jpegData(compressionQuality: 0.5),
            let path = documentDirectoryPath()?.appendingPathComponent("exampleJpg.jpg") {
            try? jpgData.write(to: path)
        }
    }
}

struct CachedImage_Previews: PreviewProvider {
    static var previews: some View {
        CachedImage()
    }
}
