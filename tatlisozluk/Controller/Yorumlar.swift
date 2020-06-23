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
                debugPrint("Yorumları Getitirken Hata meydana geldi \(error?.localizedDescription)")
                return }
            
            self.yorumlar.removeAll()
            self.yorumlar = Yorum.yorumlarGetir(snapShot: snap)
            self.tableView.reloadData()
        })
        
    }

    @IBAction func addbuttn(_ sender: UIButton) {
        
        guard let yorumText = txtField.text else {return}
        
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
                KULLANICI_ADI_REF : self.kullaniciAdi ?? "null"
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
            cell.gorunumAyarla(yorum: yorumlar[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}
