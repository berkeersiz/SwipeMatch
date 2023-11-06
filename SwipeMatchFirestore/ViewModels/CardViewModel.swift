//
//  CardViewModel.swift
//  SwipeMatchFirestore
//
//  Created by Berke Ersiz on 24.10.2023.
//

import UIKit


protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

class CardViewModel {
    //we will define the propesties that are view will display/render out
    let imageNames: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    
    init(imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
        self.imageNames = imageNames
        self.attributedString = attributedString
        self.textAlignment = textAlignment
    }
    
    
    
    
    
    fileprivate var imageIndex = 0 {
        didSet {
            let imageName = imageNames[imageIndex]
            let image = UIImage(named: imageName)
            imageIndexObserver?(imageIndex, image)
            
            
        }
    }
    // reactive programming
    var imageIndexObserver: ((Int, UIImage?) -> ())?
    
    func advancedToNextPhoto() {
        imageIndex = min(imageIndex + 1, imageNames.count - 1)
    }
    func goToPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
}

//what exactly do we do with this card view model thing???
