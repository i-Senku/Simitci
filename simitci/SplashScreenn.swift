//
//  SplashScreenn.swift
//  simitci
//
//  Created by ercan on 22.01.2020.
//  Copyright © 2020 simitci. All rights reserved.
//

import UIKit

class SplashScreenn: UIViewController {
    
    func showController(){
        performSegue(withIdentifier: "controller", sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { timer in
            self.performSegue(withIdentifier: "controller", sender: nil)
        })
    }
    
}
