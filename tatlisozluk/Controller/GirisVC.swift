//
//  GirisVC.swift
//  tatlisozluk
//
//  Created by lil ero on 23.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit

class GirisVC: UIViewController {

    @IBOutlet weak var txtemail: UITextField!
    @IBOutlet weak var txtparlo: UITextField!
    @IBOutlet weak var btngiris: UIButton!
    @IBOutlet weak var btnkayıtol: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btngiris.layer.cornerRadius = 20
        btnkayıtol.layer.cornerRadius = 20
    }
    
    @IBAction func btnSignin(_ sender: UIButton) {
    }
    

    @IBAction func btnSignup(_ sender: UIButton) {
    }
    
}
