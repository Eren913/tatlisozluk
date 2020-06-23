//
//  GirisVC.swift
//  tatlisozluk
//
//  Created by lil ero on 23.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit
import FirebaseAuth
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
        
        guard let email = txtemail.text,
           let password = txtparlo.text else{return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (kullanici, error) in
            if let error = error{
                debugPrint(error.localizedDescription)
            }else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let girisVC = storyboard.instantiateViewController(withIdentifier: "navq")
                self.present(girisVC, animated: true, completion: nil)
                //self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
}
