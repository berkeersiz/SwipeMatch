//
//  ViewController.swift
//  SwipeMatchFirestore
//
//  Created by Berke Ersiz on 17.10.2023.
//

import UIKit

class ViewController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let buttonStackView = HomeBottomControlsStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        setupLayout()//setup layout kismini sag tik refactor extract method ile yaptik.
        
        setupDummyCards()
        
        
        
    }
    
    fileprivate func setupDummyCards() {
        let cardView = CardView(frame: .zero)
        cardsDeckView.addSubview(cardView)
        cardView.fillSuperview()
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

