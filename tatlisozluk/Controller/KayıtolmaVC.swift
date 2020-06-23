//
//  KayıtolmaVC.swift
//  tatlisozluk
//
//  Created by lil ero on 23.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit

class kayitVC: UIViewController {
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtsifre: UITextField!
    
    @IBOutlet weak var txtkullanıcı: UITextField!
    @IBOutlet weak var btngiris: UIButton!
    @IBOutlet weak var btnvazgec: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btngiris.layer.cornerRadius = 20
        btnvazgec.layer.cornerRadius = 20
    }
    
    @IBAction func btnSignin(_ sender: UIButton) {
    }
    
    @IBAction func btnExit(_ sender: Any) {
    }
}
