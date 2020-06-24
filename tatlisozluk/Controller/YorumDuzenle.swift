//
//  YorumDuzenle.swift
//  tatlisozluk
//
//  Created by lil ero on 24.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit
import Firebase
class YorumDuzenle: UIViewController {

    @IBOutlet weak var btnGuncelle: UIButton!
    @IBOutlet weak var txtYorum: UITextView!
    
    var yorumDuzenle : (secilenYorum : Yorum , secilenFikir : Fikir)!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtYorum.layer.cornerRadius = 10
        btnGuncelle.layer.cornerRadius = 10
        txtYorum.text = yorumDuzenle.secilenYorum.yorum_TXT
    }
    

    @IBAction func btnGuncellePressed(_ sender: UIButton) {
        
        guard let yorumText = txtYorum.text,txtYorum.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty != true else {return}
        
        Firestore.firestore().collection(Fikirler_REF)
        .document(self.yorumDuzenle.secilenFikir.documentId)
        .collection(YORUMLAR_REF).document(yorumDuzenle.secilenYorum.documentid)
            .updateData([YORUM_TEXT : yorumText]) { (error) in
                if let error = error{
                    debugPrint("Yorum Güncellenirken Hata Meydana Geldi \(error.localizedDescription)")
                }else{
                    self.navigationController?.popViewController(animated: true)
                }
        }
        
    }
}
