//
//  Yorum.swift
//  tatlisozluk
//
//  Created by lil ero on 23.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import Foundation
import Firebase

class Yorum {
    
    private(set) var kullanici_ADI : String!
    private(set) var yorum_TXT : String!
    private(set) var eklenme_Tarihi : Date!
    
    private(set) var documentid : String!
    private(set) var kullaniciID : String!
    
    
    
    init(kullaniciadi : String, yorum : String,eklenmetarihi: Date,documentid :String,kullaniciID:String){
        self.kullanici_ADI = kullaniciadi
        self.yorum_TXT = yorum
        self.eklenme_Tarihi = eklenmetarihi
        self.documentid = documentid
        self.kullaniciID = kullaniciID
    }
    
    class func yorumlarGetir(snapShot : QuerySnapshot?) ->[Yorum] {
        
        var yorumlar = [Yorum]()
        guard let snap = snapShot else { return yorumlar}
        for kayit in snap.documents {
            let veri = kayit.data()
            let kullaniciAdi = veri[KULLANICI_ADI_REF] as? String ?? "Misafir"
            
            let ts = veri[EklenmeTarihi_REF] as? Timestamp ?? Timestamp()
            let eklenmeTarihi = ts.dateValue()
            let yorumText = veri[YORUM_TEXT] as? String ?? "null yorum"
            let documentid = kayit.documentID
            let kullaniciid = veri[KULLANICI_ID_REF] as? String ?? ""
            let yeniYorum = Yorum(kullaniciadi: kullaniciAdi, yorum: yorumText, eklenmetarihi: eklenmeTarihi,documentid: documentid,kullaniciID: kullaniciid)
            yorumlar.append(yeniYorum)
        }
        return yorumlar
    }
}
