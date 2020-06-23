//
//  KeyBoardSettings.swift
//  tatlisozluk
//
//  Created by lil ero on 24.06.2020.
//  Copyright © 2020 lil ero. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    func klavyeyiAyarla(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(klavyeKonumAyarla(_ :)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    @objc private func klavyeKonumAyarla(_ notifaction : NSNotification){
        
        let sure = notifaction.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        let curve = notifaction.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        
        let baslangicFrame = (notifaction.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        let bitisFrame = (notifaction.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let farkY = bitisFrame.origin.y - baslangicFrame.origin.y
        
        UIView.animateKeyframes(withDuration: sure, delay: 0.0, options: KeyframeAnimationOptions.init(rawValue: curve), animations: {self.frame.origin.y += farkY}, completion: nil)
        
    }
    
}
