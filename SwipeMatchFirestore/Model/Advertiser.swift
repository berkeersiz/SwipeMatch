//
//  Advertiser.swift
//  SwipeMatchFirestore
//
//  Created by Berke Ersiz on 24.10.2023.
//

import UIKit

struct Advertiser {
    let title: String
    let brandName: String
    let posterPhotoName: String
    
    func toCardViewModel() -> CardViewModel {
        
        let attributedString = NSMutableAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 34, weight: .heavy)])
        attributedString.append(NSAttributedString(string: "\n" + brandName,attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold)]))
        
        
        return CardViewModel(imageName: posterPhotoName, attributedString: attributedString, textAlignment: .center)
    }
}
