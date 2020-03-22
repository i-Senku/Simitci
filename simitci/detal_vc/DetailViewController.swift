//
//  DetailViewController.swift
//  simitci
//
//  Created by ercan on 18.01.2020.
//  Copyright © 2020 simitci. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {

    @IBOutlet weak var aciklamaText: UITextView!
    @IBOutlet weak var imageDetail: UIImageView!
    @IBOutlet weak var kategori: UILabel!
    @IBOutlet weak var fiyat: UILabel!
    @IBOutlet weak var fiyatView: UIView!
    
    var resource : ImageResource?
    var myKategori:String?
    var myFiyat : String?
    var aciklama : String?
    var ad : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fiyat.text = myFiyat! + " €"
        fiyatView.layer.cornerRadius = 5
        self.kategori.text = myKategori
        aciklamaText.text = aciklama
        imageDetail.layer.cornerRadius = 15
        imageDetail.layer.masksToBounds = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        imageDetail.kf.setImage(with: resource!)
        
    }
    

}
