//
//  ViewController.swift
//  tatlisozluk
//
//  Created by lil ero on 21.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit
import Firebase

class Anafikir: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sgmntKategori: UISegmentedControl!
    
    private var fikirler = [Fikir]()
    var fireStoreRef : CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
        fireStoreRef = Firestore.firestore().collection(Fikirler_REF)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        fireStoreRef.getDocuments { (snapshot, error) in
            if let error = error{
                debugPrint("Hata\(error.localizedDescription)")
            }else{
                
                guard let snap = snapshot else {return}
                for document in snap.documents {
                    let data = document.data()
                    
                    let kullaniciadi = data[KullaniciAdi_REF] as? String ?? "Misafir"
                    let yorumsayisi = data[YorumSayısı_REF] as? Int ?? 0
                    let begenisayisi = data[Begenisayisi_REF] as? Int ?? 0
                    let fikirtext = data[FikirText_REF] as? String ?? "Fikir yok"
                    let eklenmetarihi = data[EklenmeTarihi_REF] as? Date ?? Date()
                    let documentid = document.documentID
                    
                    let yeniFikir = Fikir(kullaniciAdi: kullaniciadi, eklenmeTarihi: eklenmetarihi, fikirText: fikirtext, yorumSayisi: yorumsayisi, begeniSayisi: begenisayisi, documentId: documentid)
                    
                    self.fikirler.append(yeniFikir)
                }
                self.tableView.reloadData()
            }
        }
    }
}
extension Anafikir : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fikirler.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "fikirCell",for: indexPath) as? FikirCell{
        cell.gorunumayarla(fikir: fikirler[indexPath.row])
            return cell
        }else{
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
