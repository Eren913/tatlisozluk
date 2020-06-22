//
//  FikirCell.swift
//  tatlisozluk
//
//  Created by lil ero on 22.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit

class FikirCell: UITableViewCell {

    @IBOutlet weak var lblKullaniciadi: UILabel!
    @IBOutlet weak var imgBegeni: UIImageView!
    @IBOutlet weak var lblBegeni: UILabel!
    @IBOutlet weak var lblYorum: UILabel!
    @IBOutlet weak var lblTarih: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func gorunumayarla(fikir : Fikir){
        lblKullaniciadi.text = fikir.kullaniciAdi
        lblYorum.text = fikir.fikirText
        lblBegeni.text = "\(fikir.begeniSayisi ?? 0)"
    }

}
