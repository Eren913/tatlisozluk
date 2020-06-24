//
//  Extensions.swift
//  tatlisozluk
//
//  Created by lil ero on 25.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import Foundation
import Firebase

extension CollectionReference{
    
    func yeniWhereSorgusu() -> Query{
        
        let tarihVeriler = Calendar.current.dateComponents([.year,.month,.day], from: Date())
        
        guard let bugun = Calendar.current.date(from: tarihVeriler),
            let bitis = Calendar.current.date(byAdding: .hour, value: 24, to: bugun),
            let baslangıc = Calendar.current.date(byAdding: .day, value: -2, to: bugun) else{
                fatalError("Belirtilen Tarih Araklıklarında Herhang bir Kayıt Bulunumadı")
        }
        //return whereField(EklenmeTarihi_REF, isLessThanOrEqualTo: bitis).whereField(EklenmeTarihi_REF, isGreaterThanOrEqualTo:  baslangıc).limit(to: 30)
        return whereField(EklenmeTarihi_REF, isLessThanOrEqualTo: bitis).whereField(EklenmeTarihi_REF, isGreaterThanOrEqualTo: bugun).limit(to: 30)
    }
}
