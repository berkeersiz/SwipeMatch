//
//  User.swift
//  SwipeMatchFirestore
//
//  Created by Berke Ersiz on 24.10.2023.
//

import UIKit

struct User: ProducesCardViewModel {
    //defining our properties for oul model layer.
    var name: String?
    var age: Int?
    var profession: String?
    //let imageNames: [String]
    var imageUrl1: String?
    var uid: String?
    
    init(dictionary: [String: Any]) {
        // we'll initialize our user here

        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.uid = dictionary["uid"] as? String ?? ""
        self.name = dictionary["fullName"] as? String ?? ""
        self.imageUrl1 = dictionary["imageUrl1"] as? String ?? ""
        //self.imageNames = []
    }
    
    func toCardViewModel() -> CardViewModel {
        
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        let ageString = age != nil ? "\(age!)" : "N\\A"
        attributedText.append(NSAttributedString(string: "  \(ageString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        let professionString = profession != nil ? profession! : "Not available"
        attributedText.append(NSAttributedString(string: "\n" + (professionString), attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        return CardViewModel(imageNames: [imageUrl1 ?? ""], attributedString: attributedText, textAlignment: .left)
    }
}

