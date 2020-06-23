//
//  YorumlarVC.swift
//  tatlisozluk
//
//  Created by lil ero on 23.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import UIKit

class YorumlarVC: UIViewController {

    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var secilenfikir : Fikir!
    var yorumlar = [Yorum]()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
    

    @IBAction func addbuttn(_ sender: UIButton) {
    }
    
}
extension YorumlarVC : UITableViewDelegate,UITableViewDataSource{
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
