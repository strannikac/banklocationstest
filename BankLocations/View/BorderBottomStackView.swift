//
//  BorderStackView.swift
//  BankLocations
//
//  Created by Alexander Sokhin on 16.10.2020.
//

import Foundation
import UIKit

class BottomBorderStackView: UIStackView {
    
    private let defaultUnderlineColor: UIColor = .lightGray
        private let bottomLine = UIView()
    
    /*@IBInspectable var inset:Bool = true {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomBorder: CGFloat = 1 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var rightBorder: CGFloat = 1 {
        didSet {
           
            setNeedsLayout()
        }
    }
    
    @IBInspectable var leftBorder: CGFloat = 1 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var topBorder: CGFloat = 1 {
        didSet {
            setNeedsLayout()
        }
    }*/
    
    /*@IBInspectable var borderColor: UIColor = .lightGray {
        didSet {
            setNeedsLayout()
        }
    }*/
    
    /*public override func layoutSubviews() {
        super.layoutSubviews()
        
        //ViewUtil.setBorders(view: self, top: topBorder, bottom: bottomBorder, left: leftBorder, right: rightBorder, color: borderColor, inset: inset)
    }*/
    
    
    

        override func awakeFromNib() {
            super.awakeFromNib()

            bottomLine.translatesAutoresizingMaskIntoConstraints = false
            bottomLine.backgroundColor = defaultUnderlineColor

            self.addSubview(bottomLine)
            bottomLine.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 1).isActive = true
            bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        }

        public func setUnderlineColor(color: UIColor = .red) {
            bottomLine.backgroundColor = color
        }

        public func setDefaultUnderlineColor() {
            bottomLine.backgroundColor = defaultUnderlineColor
        }
   
}
