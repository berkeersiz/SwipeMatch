//
//  HomeBottomControlsStackView.swift
//  SwipeMatchFirestore
//
//  Created by Berke Ersiz on 17.10.2023.
//

import UIKit
//Uygulamadaki alt butonlari kontrol etmek icin actigimiz bir sinif.
class HomeBottomControlsStackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true//bottomdan yukari
        
        let subviews = [UIImage(imageLiteralResourceName: "refresh_circle"),UIImage(imageLiteralResourceName: "dismiss_circle"),UIImage(imageLiteralResourceName: "super_like_circle"),UIImage(imageLiteralResourceName: "like_circle"),UIImage(imageLiteralResourceName: "boost_circle")].map { img -> UIView in
            let button = UIButton(type: .system)
            button.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)//withrenderingmode goruntunun yeni modeunu dondurur. 
            return button
        }
        
        let button = UIButton(type: .system)
        
        
        
        subviews.forEach { v in
            addArrangedSubview(v)
        }
        
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

}
