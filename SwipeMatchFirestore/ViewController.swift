//
//  ViewController.swift
//  SwipeMatchFirestore
//
//  Created by Berke Ersiz on 17.10.2023.
//

import UIKit

class ViewController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let blueView = UIView()
    let buttonStackView = HomeBottomControlsStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blueView.backgroundColor = .blue

        setupLayout()//setup layout kismini sag tik refactor extract method ile yaptik.
        
        
        
        
    }
    // MARK: Fileprivate
    
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, blueView, buttonStackView])
        overallStackView.axis = .vertical //yatay sekilde yerlesmesini sagladi.
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }


}

