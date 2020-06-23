//
//  KayıtolmaVC.swift
//  tatlisozluk
//
//  Created by lil ero on 23.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit
import Firebase
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
        guard let email = txtEmail.text,
              let password = txtsifre.text,
              let username = txtkullanıcı.text else {return}
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (users, error) in
            if let error = error{
                print("Kullanıcı oluşturulurken hata meydana geldi\(error.localizedDescription)")
            }
            /* Kullanıcı bilgilerini güncelleme istek metodu
            let changeRequest = users?.user.createProfileChangeRequest()
            changeRequest?.displayName = username
            changeRequest?.commitChanges(completion: { (error) in
                if let error = error{
                    print("Kullanıcı bilgileri güncellenirken hata meydana geldi \(error.localizedDescription)")
                }
            })
           */
            
            guard let userid = users?.user.uid else {return}
            
            Firestore.firestore().collection(USER_REF).document(userid).setData([
                USERNAME_REF : username,
                USERCREATETIME_REF : FieldValue.serverTimestamp()
                ],completion: {(error) in
                    if let error = error{
                        print("Kullanıcı Eklenirken hata meydana geldi \(error.localizedDescription)")
                    }else{
                        self.dismiss(animated: true, completion: nil)
                    }
            })
        }
    }
    
    @IBAction func btnExit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
