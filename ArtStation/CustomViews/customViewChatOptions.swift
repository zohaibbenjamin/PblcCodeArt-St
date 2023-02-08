//
//  customViewChatOptions.swift
//  ArtStation
//
//  Created by Andpercent on 24/11/2021.
//

import UIKit

@IBDesignable
class customViewChatOptions: UIView {
        override func layoutSubviews() {
            super.layoutSubviews()
            self.layer.borderColor = UIColor.white.cgColor
            self.layer.borderWidth = 2
            self.layer.cornerRadius = self.frame.height / 2
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = .zero
            self.layer.shadowRadius = 20
            self.layer.shadowOpacity = 0.18
        }
}
