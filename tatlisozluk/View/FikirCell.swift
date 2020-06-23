//
//  FikirCell.swift
//  tatlisozluk
//
//  Created by lil ero on 22.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit
import Firebase

class FikirCell: UITableViewCell {

    var secilenFikir : Fikir!
    
    @IBOutlet weak var lblKullaniciadi: UILabel!
    @IBOutlet weak var imgBegeni: UIImageView!
    @IBOutlet weak var lblBegeni: UILabel!
    @IBOutlet weak var lblYorum: UILabel!
    @IBOutlet weak var lblTarih: UILabel!
    @IBOutlet weak var lblYorumsayisi: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
          let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
              imgBegeni.addGestureRecognizer(tap)
              imgBegeni.isUserInteractionEnabled = true
    }
    @objc func imgTapped(){
        
        Firestore.firestore().collection(Fikirler_REF).document(secilenFikir.documentId).setData([Begenisayisi_REF : secilenFikir.begeniSayisi+1], merge: true)
        
        //Firestore.firestore().document("Fikirler\(secilenFikir.documentId!)").updateData([Begenisayisi_REF : secilenFikir.begeniSayisi + 1] )
        
    }
    func gorunumayarla(fikir : Fikir){
        
        secilenFikir = fikir
        lblKullaniciadi.text = fikir.kullaniciAdi
        lblYorum.text = fikir.fikirText
        lblBegeni.text = "\(fikir.begeniSayisi ?? 0)"
        lblYorumsayisi.text = "\(fikir.yorumSayisi ?? 0)"
        
        let tarihFormat = DateFormatter()
        tarihFormat.dateFormat = "dd MM YYYY hh:mm"
        let eklenmetarihi = tarihFormat.string(from: fikir.eklenmeTarihi)
        lblTarih.text = eklenmetarihi
        
    }

}
