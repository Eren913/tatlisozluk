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
    private var secilenKategori = Kategoriler.Eglence.rawValue
    private var fikirListener : ListenerRegistration!
    private var listenerHandle : AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        
        fireStoreRef = Firestore.firestore().collection(Fikirler_REF)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        if fikirListener != nil{
            fikirListener.remove()
        }
       }
    override func viewWillAppear(_ animated: Bool) {
        
        listenerHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let girisVC = storyboard.instantiateViewController(withIdentifier: "girisVC")
                self.present(girisVC, animated: true, completion: nil)
            }else{
                self.setListener()
            }
        })
    }
    func setListener(){
        
        if secilenKategori == Kategoriler.Populer.rawValue{
            fikirListener = fireStoreRef
            .order(by: EklenmeTarihi_REF, descending: true)
            .addSnapshotListener { (snapshot, error) in
            if let error = error{
            debugPrint("Hata\(error.localizedDescription)")
            }else{
                    self.fikirler.removeAll()
                    self.fikirler = Fikir.populerfikirGetir(snapshot: snapshot)
                    self.tableView.reloadData()
                }
            }
        }else{
            fikirListener = fireStoreRef.whereField(Kategori_REF, isEqualTo: secilenKategori)
            .order(by: EklenmeTarihi_REF, descending: true)
            .addSnapshotListener { (snapshot, error) in
            if let error = error{
            debugPrint("Hata\(error.localizedDescription)")
            }else{
                self.fikirler.removeAll()
                self.fikirler = Fikir.populerfikirGetir(snapshot: snapshot)
                self.tableView.reloadData()
                }
            }
        }
    }
   
    
    
    @IBAction func sgmntChanged(_ sender: UISegmentedControl) {
        switch sgmntKategori.selectedSegmentIndex {
        case 0:
            secilenKategori = Kategoriler.Eglence.rawValue
        case 1 :
            secilenKategori = Kategoriler.Absurt.rawValue
        case 2 :
            secilenKategori = Kategoriler.Gundem.rawValue
        case 3 :
            secilenKategori = Kategoriler.Populer.rawValue
        default:
            secilenKategori = Kategoriler.Eglence.rawValue
        }
        fikirListener.remove()
        setListener()
    }
    
    @IBAction func SignoutClickec(_ sender: UIBarButtonItem) {
       
        do{
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let girisVC = storyboard.instantiateViewController(withIdentifier: "girisVC")
            self.present(girisVC, animated: true, completion: nil)
            print("Çıkış işlemi Başarılı")
        }catch{
            print("Çıkış işlemi  Hatası")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toYorumlar" {
            if let destination = segue.destination as? Yorumlar{
                if let secilenfikir = sender as? Fikir{
                    destination.secilenfikir = secilenfikir
                }
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toYorumlar", sender: fikirler[indexPath.row])
    }
}
