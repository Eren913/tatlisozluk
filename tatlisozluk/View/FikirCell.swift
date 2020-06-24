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
    
    @IBOutlet weak var imgSecenekler: UIImageView!
    
    
    var delegate : FikirDelegate!
    
    
    let fireStore = Firestore.firestore()
    var begeniler = [Begeni]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
          let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
              imgBegeni.addGestureRecognizer(tap)
              imgBegeni.isUserInteractionEnabled = true
    }
    func begeniGetir(){
        let begeniSorgu = fireStore.collection(Fikirler_REF).document(self.secilenFikir.documentId).collection(BEGENI_REF).whereField(KULLANICI_ID, isEqualTo: Auth.auth().currentUser?.uid ?? "begeniyok")
        begeniSorgu.getDocuments { (snapshot, error) in
            self.begeniler = Begeni.BegenileriGetir(snapshot: snapshot)
            if self.begeniler.count > 0{
                self.imgBegeni.image = UIImage(named: "yildizRenkli")
            }else{
                self.imgBegeni.image = UIImage(named: "yildizTransparan")
            }
        }
    }
    
 
    @objc func imgTapped(){
        
        
        fireStore.runTransaction({ (transection, errorPointer) -> Any? in
            let secilenFikirKayit : DocumentSnapshot
            
            do{
                try secilenFikirKayit = transection.getDocument(self.fireStore.collection(Fikirler_REF).document(self.secilenFikir.documentId))
            }catch let error as NSError{
                debugPrint("Begenide Hata oluştu...\(error.localizedDescription)")
                return nil
            }
            
            guard let eskisayi = (secilenFikirKayit.data()?[Begenisayisi_REF] as? Int) else {return nil}
            let secilenFikirRef = self.fireStore.collection(Fikirler_REF).document(self.secilenFikir.documentId)
            
            if self.begeniler.count > 0 {
                //Kullanıcı daha önceden beğenmiş ve beğeniden çıkmak üzere
                transection.updateData([Begenisayisi_REF : eskisayi-1], forDocument: secilenFikirRef)
                let eskibegeni = self.fireStore.collection(Fikirler_REF).document(self.secilenFikir.documentId).collection(BEGENI_REF).document(self.begeniler[0].documentId)
                transection.deleteDocument(eskibegeni)
            }else {
                //kullanıcı daha önce beğenmemeiş ve beğenmek üzere
                transection.updateData([Begenisayisi_REF : eskisayi+1], forDocument: secilenFikirRef)
                let yeniBegeniRef = self.fireStore.collection(Fikirler_REF).document(self.secilenFikir.documentId).collection(BEGENI_REF).document()
                transection.setData([KULLANICI_ID : Auth.auth().currentUser?.uid ?? "" ], forDocument : yeniBegeniRef)
            }
            return nil
        }) { (nesne, error) in
            if let error = error {
                debugPrint("Begenme Fonksiyonunda hata meydana geldi \(error.localizedDescription)")
            }
        }
    }
    func gorunumayarla(fikir : Fikir,delegate : FikirDelegate){
        
        secilenFikir = fikir
        lblKullaniciadi.text = fikir.kullaniciAdi
        lblYorum.text = fikir.fikirText
        lblBegeni.text = "\(fikir.begeniSayisi ?? 0)"
        lblYorumsayisi.text = "\(fikir.yorumSayisi ?? 0)"
        
        let tarihFormat = DateFormatter()
        tarihFormat.dateFormat = "dd MM YYYY hh:mm"
        let eklenmetarihi = tarihFormat.string(from: fikir.eklenmeTarihi)
        lblTarih.text = eklenmetarihi
        
        self.delegate = delegate
        
        imgSecenekler.isHidden = true
        if fikir.kullaniciId == Auth.auth().currentUser?.uid{
            imgSecenekler.isHidden = false
            imgSecenekler.isUserInteractionEnabled = true
            let tapo = UITapGestureRecognizer(target: self, action: #selector(imgFikirSelectedPressed))
            imgSecenekler.addGestureRecognizer(tapo)
        }
        begeniGetir()
        
    }
    @objc func imgFikirSelectedPressed(){
        delegate.seceneklerPressed(fikir: secilenFikir)
    }

}
protocol FikirDelegate {
    func seceneklerPressed(fikir : Fikir)
}

