//
//  ActivityIndicatorHelper.swift
//  BankLocations
//
//  Created by Alexander Sokhin on 31.10.2020.
//

import Foundation
import UIKit

class ActivityIndicatorHelper {
    private var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    //create activity indicator in controller
    func createActivityIndicator(forController controller: UITableViewController) {
        DispatchQueue.main.async {
            let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
            controller.view.addSubview(indicator)
            
            indicator.backgroundColor = UIColor.white.withAlphaComponent(0.8)
            indicator.color = .red
            indicator.style = .large
            
            indicator.translatesAutoresizingMaskIntoConstraints = false
            
            let w = controller.view.bounds.size.width
            let h = controller.view.bounds.size.height
            
            indicator.widthAnchor.constraint(equalToConstant: w).isActive = true
            indicator.heightAnchor.constraint(equalToConstant: h).isActive = true
            
            let topOffset = controller.tableView.contentOffset.y
            indicator.topAnchor.constraint(equalTo: controller.tableView.topAnchor, constant: topOffset).isActive = true
            
            indicator.hidesWhenStopped = true
            indicator.center = controller.view.center
            
            self.activityIndicatorView = indicator
            
            self.setActivityIndicator(forController: controller, show: true)
        }
    }
    
    //show or hide activity indicator
    func setActivityIndicator(forController controller: UIViewController, show: Bool) {
        DispatchQueue.main.async {
            self.activityIndicatorView.isHidden = !show
            controller.view.isUserInteractionEnabled = !show
            
            if show {
                self.activityIndicatorView.startAnimating()
            } else {
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    func removeActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicatorView.removeFromSuperview()
        }
    }
}
