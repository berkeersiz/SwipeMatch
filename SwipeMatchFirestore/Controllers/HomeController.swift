//
//  ViewController.swift
//  SwipeMatchFirestore
//
//  Created by Berke Ersiz on 17.10.2023.
//

import UIKit

class HomeController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let buttonStackView = HomeBottomControlsStackView()
   
    let cardViewModels = [
        User(name: "Kelly", age: 23, profession: "Music DJ", imageName: "lady5c").toCardViewMode(),
        User(name: "Jane", age: 18, profession: "Teacher", imageName: "lady4c").toCardViewMode(),
        Advertiser(title: "Slide Out Menu", brandName: "Lets Build That App", posterPhotoName: "slide_out_menu_poster").toCardViewModel()
    ]
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        setupLayout()//setup layout kismini sag tik refactor extract method ile yaptik.
        
        setupDummyCards()
        
        
        
    }
    
    fileprivate func setupDummyCards() {//Kartlari gostermemizi saglayan fonks.
        cardViewModels.forEach { cardVM in
            let cardView = CardView(frame: .zero)
            cardView.imageView.image = UIImage(named: cardVM.imageName)
            cardView.informationLabel.attributedText = cardVM.attributedString
            cardView.informationLabel.textAlignment = cardVM.textAlignment
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
        
        
        /*users.forEach { (user) in
            let cardView = CardView(frame: .zero)
            cardView.imageView.image = UIImage(named: user.imageName)
            //cardView.informationLabel.text = "\(user.name) \(user.age)\n\(user.profession)"

            cardView.informationLabel.attributedText = attributedText
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }*/

    }

    // MARK: Fileprivate
    
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, buttonStackView])
        overallStackView.axis = .vertical //yatay sekilde yerlesmesini sagladi.
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)//fotografa margin verdik.
        overallStackView.bringSubviewToFront(cardsDeckView)//cardi z axis olarak one aldik.
        
    }


}
