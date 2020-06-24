//
//  YorumlarVC.swift
//  tatlisozluk
//
//  Created by lil ero on 23.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit
import Firebase

class Yorumlar: UIViewController {

    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var secilenfikir : Fikir!
    var yorumlar = [Yorum]()
    
    var fikirRef : DocumentReference!
    let dbfireStore = Firestore.firestore()
    var kullaniciAdi : String!
    
    var yorumlarListener : ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        fikirRef = dbfireStore.collection(Fikirler_REF).document(secilenfikir.documentId)
        
        if let adi = Auth.auth().currentUser?.displayName{
            kullaniciAdi = adi
        }
        self.view.klavyeyiAyarla()
    }
    override func viewDidAppear(_ animated: Bool) {
        
        yorumlarListener = dbfireStore.collection(Fikirler_REF).document(secilenfikir.documentId).collection(YORUMLAR_REF)
            .order(by: EklenmeTarihi_REF, descending: false)
            .addSnapshotListener({ (snapshot, error) in
            
            guard let snap = snapshot else {
                debugPrint("Yorumları Getitirken Hata meydana geldi \(error?.localizedDescription ?? "")")
                return }
            
            self.yorumlar.removeAll()
            self.yorumlar = Yorum.yorumlarGetir(snapShot: snap)
            self.tableView.reloadData()
        })
        
    }

    @IBAction func addbuttn(_ sender: UIButton) {
        
        guard let yorumText = txtField.text,txtField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty != true else {return}
        
        dbfireStore.runTransaction({ (transection, errorPointer) -> Any? in
            
            let secilenfikirKayıt : DocumentSnapshot
            do {
                try secilenfikirKayıt = transection.getDocument(self.dbfireStore.collection(Fikirler_REF).document(self.secilenfikir.documentId))
            }catch let hata as NSError{
                debugPrint("hh\(hata.localizedDescription)")
                return nil
            }
            
            guard let eskiYorumSayisi = (secilenfikirKayıt.data()?[YorumSayısı_REF] as? Int) else {return nil}
            
            transection.updateData([YorumSayısı_REF : eskiYorumSayisi+1], forDocument: self.fikirRef)
            
            let yeniYorumRef = self.dbfireStore.collection(Fikirler_REF).document(self.secilenfikir.documentId).collection(YORUMLAR_REF).document()
            
            transection.setData([
                YORUM_TEXT : yorumText,
                EklenmeTarihi_REF : FieldValue.serverTimestamp(),
                KULLANICI_ADI_REF : self.kullaniciAdi ?? "nul data",
                KULLANICI_ID : Auth.auth().currentUser?.uid ?? "null"
            ], forDocument: yeniYorumRef)
            
            return nil
        }) { (nesne, hata) in
            if let hata = hata{
                debugPrint("Hata Meydana Geldi TRAns \(hata.localizedDescription)")
            }else{
                self.txtField.text = ""
            }
        }
    }
}
extension Yorumlar : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yorumlar.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "yorumCell", for: indexPath) as? YorumCell{
            cell.gorunumAyarla(yorum: yorumlar[indexPath.row], delegate: self)
            return cell
        }
        return UITableViewCell()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "yorumDuzenleSegue"{
            if let destination = segue.destination as? YorumDuzenle{
                if let yorumVerisi = sender as? (secilenYorum : Yorum , secilenFikir : Fikir){
                    destination.yorumDuzenle = yorumVerisi
                }
            }
        }
    }
}
extension Yorumlar : YorumDelegate{
    func seceneklerYorumPressed(yorum : Yorum){
        
        let alert  = UIAlertController(title: "Yorumu Düzenle", message: "Yorumu düzenle veya sil", preferredStyle: .actionSheet)
        
        let silAction = UIAlertAction(title: "Yorumu sil", style: .default) { (action) in
            
            self.dbfireStore.runTransaction({ (transsection, error) -> Any? in
                
                let secilenfikirKayıt : DocumentSnapshot
                do {
                    try secilenfikirKayıt = transsection.getDocument(self.dbfireStore.collection(Fikirler_REF).document(self.secilenfikir.documentId))
                }catch let hata as NSError{
                    debugPrint("hh\(hata.localizedDescription)")
                    return nil
                }
                
                guard let oldcomment = (secilenfikirKayıt.data()?[YorumSayısı_REF] as? Int) else {return nil}
                
                transsection.updateData([YorumSayısı_REF : oldcomment-1 ], forDocument: self.fikirRef)
                
                let silinicekYorumREF = self.dbfireStore.collection(Fikirler_REF).document(self.secilenfikir.documentId).collection(YORUMLAR_REF).document(yorum.documentid)
                transsection.deleteDocument(silinicekYorumREF)
                  return nil
            }) { (nesne, error) in
                if let error = error {
                    debugPrint("Yorum Silinirken Hata Meydana  Geldi \(error.localizedDescription)")
                }else{
                    alert.dismiss(animated: true, completion: nil)
                }
              
            }
            
        }
        
        let düzenleAction = UIAlertAction(title: "Yorumu düzenle", style: .default) { (action) in
            self.performSegue(withIdentifier: "yorumDuzenleSegue", sender: (yorum,self.secilenfikir))
            self.dismiss(animated: true, completion: nil)
        }
        let iptalAction = UIAlertAction(title: "İptal ET", style: .cancel) { (action) in
            //iptal
        }
        alert.addAction(silAction)
        alert.addAction(düzenleAction)
        alert.addAction(iptalAction)
        present(alert, animated: true, completion: nil)
        
        
    }
}
