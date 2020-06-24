//
//  Begeni.swift
//  tatlisozluk
//
//  Created by lil ero on 24.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import Foundation
import Firebase

class Begeni{
    
    private(set) var kullaniciId : String
    private(set) var documentId : String
    
    init(kullanici_like_id: String ,kullanici_doc_id :String){
        self.kullaniciId = kullanici_like_id
        self.documentId = kullanici_doc_id
    }
    class func BegenileriGetir(snapshot: QuerySnapshot?) -> [Begeni]{
        var begeniler = [Begeni]()
        
        guard let snap = snapshot else { return begeniler }
        
        for kayit in snap.documents {
            let veri = kayit.data()
            let kullaniciId = veri[KULLANICI_ID] as? String ?? ""
            let documentId = kayit.documentID
            
            let yeniBegeni = Begeni(kullanici_like_id: kullaniciId, kullanici_doc_id: documentId)
            begeniler.append(yeniBegeni)
        }
        return begeniler
    }
}
