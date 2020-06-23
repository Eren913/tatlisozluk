//
//  FikirEkle.swift
//  tatlisozluk
//
//  Created by lil ero on 21.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit
import Firebase

class FikirEkle: UIViewController {

    @IBOutlet weak var sgmntKategori: UISegmentedControl!
    @IBOutlet weak var buttonPaylas: UIButton!
    @IBOutlet weak var txtkullanıcıAdı: UITextField!
    @IBOutlet weak var txtPost: UITextView!

    var placeHolder = "Fikrinizi Belirtiniz"
    var secilenKategori = Kategoriler.Eglence.rawValue
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonPaylas.layer.cornerRadius = 10
        txtPost.layer.cornerRadius = 10
        
        txtPost.delegate = self
        txtPost.text = placeHolder
        txtPost.textColor = .lightGray
    }
    
    @IBAction func btnPaylas(_ sender: Any) {
        
        guard let kullaniciadi = txtkullanıcıAdı.text else { return}
        
        db.collection(Fikirler_REF).addDocument(data: [
            Kategori_REF : secilenKategori,
            Begenisayisi_REF : 0,
            YorumSayısı_REF : 0,
            FikirText_REF: txtPost.text!,
            EklenmeTarihi_REF : FieldValue.serverTimestamp(),
            KullaniciAdi_REF : kullaniciadi
        ]){ error in
            if let error = error {
                print("print error\(error)")
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @IBAction func kategoridegisti(_ sender: Any) {
        
        switch sgmntKategori.selectedSegmentIndex {
        case 0:
            secilenKategori = Kategoriler.Eglence.rawValue
        case 1 :
            secilenKategori = Kategoriler.Absurt.rawValue
        case 2 :
            secilenKategori = Kategoriler.Gundem.rawValue
        default:
            secilenKategori = Kategoriler.Eglence.rawValue
        }
        
    }
    
    
    
}
extension FikirEkle : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeHolder {
            textView.text = ""
            textView.textColor = .darkGray
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolder
            textView.textColor = .lightGray
        }
    }
}
