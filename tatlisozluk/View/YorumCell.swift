//
//  YorumCell.swift
//  tatlisozluk
//
//  Created by lil ero on 23.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit

class YorumCell: UITableViewCell {

    @IBOutlet weak var lblkullanıcıadı: UILabel!
    @IBOutlet weak var lblyorum: UILabel!
    @IBOutlet weak var lbltarih: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func gorunumAyarla(yorum : Yorum){
        
        lblkullanıcıadı.text = yorum.kullanici_ADI
        lblyorum.text = yorum.yorum_TXT
        
        let tarihFormat = DateFormatter()
        tarihFormat.dateFormat = "dd MM YYYY hh:dd"
        let eklenmeTarihi = tarihFormat.string(from: yorum.eklenme_Tarihi)
        lbltarih.text = eklenmeTarihi
    }

}
