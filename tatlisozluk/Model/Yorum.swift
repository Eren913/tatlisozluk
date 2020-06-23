//
//  Yorum.swift
//  tatlisozluk
//
//  Created by lil ero on 23.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import Foundation


class Yorum {
    
    private(set) var kullanici_ADI : String!
    private(set) var yorum_TXT : String!
    private(set) var eklenme_Tarihi : Date!
    
    init(kullaniciadi : String, yorum : String,eklenmetarihi: Date){
        self.kullanici_ADI = kullaniciadi
        self.yorum_TXT = yorum
        self.eklenme_Tarihi = eklenmetarihi
    }
}
