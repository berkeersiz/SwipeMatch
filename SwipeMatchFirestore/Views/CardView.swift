//
//  CardView.swift
//  SwipeMatchFirestore
//
//  Created by Berke Ersiz on 18.10.2023.
//

import UIKit

class CardView: UIView {
    
    let img = UIImage(named: "lady5c")
    fileprivate let imageView = UIImageView()
    let threshold: CGFloat = 100
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // custom drawing code
        layer.cornerRadius = 10//imagein yanlarini yuvarladik.
        clipsToBounds = true//subviews to be clipped to the bounds of the view.
        
        imageView.image = img
        addSubview(imageView)
        imageView.fillSuperview()
        
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
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            
            if shouldDismissCard {
                if translation.x > self.threshold {
                    let offScreenTransform = self.transform.translatedBy(x: 1000, y: 0)
                    self.transform = offScreenTransform
                } else if translation.x < -self.threshold {
                    let offScreenTransform = self.transform.translatedBy(x: -1000, y: 0)
                    self.transform = offScreenTransform
                }
                else {
                    self.transform = .identity
                }
            }}) { (_) in
            //fotonun nasil yerine doneceginin ozellikleri.
            self.transform = .identity
            self.frame = CGRect(x: 0, y: 0, width: self.superview!.frame.width, height: self.superview!.frame.height)
        }
    }
    
    required init(coder Adecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
