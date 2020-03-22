//
//  api.swift
//  simitci
//
//  Created by ercan on 16.01.2020.
//  Copyright © 2020 simitci. All rights reserved.
//

import Foundation
import Alamofire

class myApi{
    
    static let shared = myApi()
    typealias completionCall = ([Product]?,AFError?)->Void
    
    func getData(kategoriID : String = "0",completionHandler: @escaping ([Product])->Void){
        let url = URL(string: "http://cubus3d.de/simitci-panel/api/urunler.php?cat=\(kategoriID)")
        AF.request(url!).responseJSON(completionHandler: { response in

                guard let data = response.data else{return}
                             
                   do{
                    let json = try JSONDecoder().decode([Product].self, from: data)
                    completionHandler(json)
                    
                  }catch{
                       print("Hata")
                }
        })
    }
    func getkategori(completionHandler : @escaping ([ProductCategory]) -> Void){
        
        let url = URL(string: "http://cubus3d.de/simitci-panel/api/kategoriler.php")
        
        AF.request(url!).responseJSON(completionHandler: {response in
            guard let data = response.data else{return}
             do{
              let json = try JSONDecoder().decode([ProductCategory].self, from: data)
              completionHandler(json)
              
            }catch{
                 print("Hata")
             }
            
        })
    }

}
