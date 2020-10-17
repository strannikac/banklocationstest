//
//  AlertView.swift
//  BankLocations
//
//  Created by Alexander Sokhin on 15.10.2020.
//

import UIKit
import Foundation

/* MARK: show error or notice in any controller (screen) */

class AlertView {
    
    class func show(title: String, message: String, controller: UIViewController) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: StringConstants.ok.rawValue, style: .default, handler: nil))
        
            controller.present(alertVC, animated: true, completion: nil)
        }
    }
    
    class func show(title: String, message: String, controller: UIViewController, handler: @escaping () -> Void) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: StringConstants.ok.rawValue, style: .default, handler: { (action: UIAlertAction!) in
                handler()
            }))
        
            controller.present(alertVC, animated: true, completion: nil)
        }
    }
}
