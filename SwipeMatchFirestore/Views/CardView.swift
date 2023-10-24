//
//  CardView.swift
//  SwipeMatchFirestore
//
//  Created by Berke Ersiz on 18.10.2023.
//

import UIKit

class CardView: UIView {
    
    let img = UIImage(named: "lady5c")
    let imageView = UIImageView()
    let informationLabel = UILabel()
    let threshold: CGFloat = 100
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // custom drawing code
        layer.cornerRadius = 10//imagein yanlarini yuvarladik.
        clipsToBounds = true//subviews to be clipped to the bounds of the view.
        
        imageView.image = img
        addSubview(imageView)
        imageView.fillSuperview()
        
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        informationLabel.text = " TEST NAME TEST NAME"
        informationLabel.textColor = .white
        informationLabel.font = UIFont.systemFont(ofSize: 34, weight: .heavy)
        informationLabel.numberOfLines = 0//bu satir sinirini ortadan kaldiran fonks.1 yaparsak sinirli!
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        
    }
    
    //gesture
    @objc fileprivate func handlePan(_ gesture: UIPanGestureRecognizer){
        //print("panning img")
        //print(translation.x)//fotoyu kaydirmaya calistigimizdaki degisen x degerleri.
        switch gesture.state {
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
        default:
            ()
        }
    }
    
    //fotoya dokundugumuzda nolucagini yazdigimiz fonk.
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        //some not that scary math here to convert radians to degrees
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
        
        
        
        /*bu kod hareket ettirmemizi sagladi ama biz belli bir aciyla hareket etmesini istiyoruz.
        let translation = gesture.translation(in: nil)
        self.transform = CGAffineTransform(translationX: translation.x, y: translation.y)*/
    }
    
    //fotoyu biraktigimizda nolucagini yazdigimiz fonk.
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        
        let translation =  gesture.translation(in: nil)
        let shouldDismissCard = translation.x > threshold  || translation.x < -threshold
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            
            if shouldDismissCard {
                if translation.x > self.threshold {
                    let offScreenTransform = self.transform.translatedBy(x: 600, y: 0)
                    self.transform = offScreenTransform
                } else if translation.x < -self.threshold {
                    let offScreenTransform = self.transform.translatedBy(x: -600, y: 0)
                    self.transform = offScreenTransform
                }
                else {
                    self.transform = .identity
                }
            }}) { (_) in
            //fotonun nasil yerine doneceginin ozellikleri.
          //self.transform = .identity
          //self.frame = CGRect(x: 0, y: 0, width: self.superview!.frame.width, height: self.superview!.frame.height)//Burasi nesnenin geri gelmesini sagliyordu ama biz yeni kullanicilari gormek istiyoruz o yuzden comment.
        }
    }
    
    required init(coder Adecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
