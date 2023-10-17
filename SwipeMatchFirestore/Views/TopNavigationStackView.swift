//
//  TopNavigationStackView.swift
//  SwipeMatchFirestore
//
//  Created by Berke Ersiz on 17.10.2023.
//

import UIKit

class TopNavigationStackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 70).isActive = true//top kismindan 110
        
        let subviews = [UIImage(imageLiteralResourceName: "top_left_profile"),UIImage(imageLiteralResourceName: "app_icon"),UIImage(imageLiteralResourceName: "top_right_messages")].map { img -> UIView in
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
