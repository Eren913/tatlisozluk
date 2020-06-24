//
//  Fikir.swift
//  tatlisozluk
//
//  Created by lil ero on 21.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import Foundation
import Firebase

class Fikir{
    
    private(set) var kullaniciAdi :String!
    private(set) var eklenmeTarihi : Date!
    private(set) var fikirText : String!
    private(set) var yorumSayisi : Int!
    private(set) var begeniSayisi : Int!
    private(set) var documentId : String!
    private(set) var kullaniciId : String!
    
    
    init(kullaniciAdi : String,eklenmeTarihi : Date, fikirText : String, yorumSayisi : Int,begeniSayisi : Int,documentId : String,kullaniciId : String){
        
        self.kullaniciAdi = kullaniciAdi
        self.eklenmeTarihi = eklenmeTarihi
        self.fikirText = fikirText
        self.yorumSayisi = yorumSayisi
        self.begeniSayisi = begeniSayisi
        self.documentId = documentId
        self.kullaniciId = kullaniciId
    }
    class func populerfikirGetir(snapshot : QuerySnapshot?) -> [Fikir]{
        var fikirler = [Fikir]()
    guard let snap = snapshot else {return fikirler}
    for document in snap.documents {
    let data = document.data()
    let kullaniciadi = data[KullaniciAdi_REF] as? String ?? "Misafir"
    let yorumsayisi = data[YorumSayısı_REF] as? Int ?? 0
    let begenisayisi = data[Begenisayisi_REF] as? Int ?? 0
    let fikirtext = data[FikirText_REF] as? String ?? "Fikir yok"
    let kullaniciid = data[KULLANICI_ID_REF] as? String ?? ""
        
        
    let ts = data[EklenmeTarihi_REF] as? Timestamp ?? Timestamp()
        let eklenmetarihi = ts.dateValue()
    
    let documentid = document.documentID
        
    let yeniFikir = Fikir(kullaniciAdi: kullaniciadi, eklenmeTarihi: eklenmetarihi, fikirText: fikirtext, yorumSayisi: yorumsayisi, begeniSayisi: begenisayisi, documentId: documentid,kullaniciId: kullaniciid)
        fikirler.append(yeniFikir)
        }
        return fikirler
}
}
