//
//  User.swift
//  SwipeMatchFirestore
//
//  Created by Berke Ersiz on 24.10.2023.
//

import UIKit

struct User {
    //defining our properties for oul model layer.
    let name: String
    let age: Int
    let profession: String
    let imageName: String
    
    func toCardViewMode() -> CardViewModel {
        
        let attributedText = NSMutableAttributedString(string: name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributedText.append(NSAttributedString(string: "  \(age)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        attributedText.append(NSAttributedString(string: "\n" + profession, attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        return CardViewModel(imageName: imageName, attributedString: attributedText, textAlignment: .left)
    }
}

