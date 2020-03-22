//
//  Product.swift
//  simitci
//
//  Created by ercan on 16.01.2020.
//  Copyright © 2020 simitci. All rights reserved.
//

import Foundation

struct Product : Decodable{
    var id:String
    var ad:String
    var aciklama:String
    var kategori:String
    var kategori_ad:String
    var fiyat:String
    var resim:String
}

struct ProductCategory : Decodable{
    var id:String
    var ad:String
    var resim:String
}

