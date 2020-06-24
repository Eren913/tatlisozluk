//
//  YorumCell.swift
//  tatlisozluk
//
//  Created by lil ero on 23.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit
import FirebaseAuth

class YorumCell: UITableViewCell {

    @IBOutlet weak var lblkullanıcıadı: UILabel!
    @IBOutlet weak var lblyorum: UILabel!
    @IBOutlet weak var lbltarih: UILabel!
    
    @IBOutlet weak var imgSecenekler: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }
    var delegate : YorumDelegate?
    var secilenyorum : Yorum!
    
    func gorunumAyarla(yorum : Yorum,delegate : YorumDelegate?){
        
        lblkullanıcıadı.text = yorum.kullanici_ADI
        lblyorum.text = yorum.yorum_TXT
        
        let tarihFormat = DateFormatter()
        tarihFormat.dateFormat = "dd MM YYYY hh:dd"
        let eklenmeTarihi = tarihFormat.string(from: yorum.eklenme_Tarihi)
        lbltarih.text = eklenmeTarihi
        
        secilenyorum = yorum
        self.delegate = delegate
        
        imgSecenekler.isHidden = true
        if yorum.kullaniciID == Auth.auth().currentUser?.uid{
            imgSecenekler.isHidden = false
            let tap = UITapGestureRecognizer(target: self, action: #selector(imgYorumSeceneklerPressed))
            imgSecenekler.isUserInteractionEnabled = true
            imgSecenekler.addGestureRecognizer(tap)
        }
    }
    @objc func imgYorumSeceneklerPressed(){
        delegate?.seceneklerYorumPressed(yorum: secilenyorum)
    }

}

protocol YorumDelegate{
    func seceneklerYorumPressed(yorum : Yorum)
}
