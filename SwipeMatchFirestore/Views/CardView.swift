//
//  CardView.swift
//  SwipeMatchFirestore
//
//  Created by Berke Ersiz on 18.10.2023.
//

import UIKit

class CardView: UIView {
    
    var cardViewModel: CardViewModel! {
        didSet {
            // accessing index 0 will crash if imageNames.count == 0
            let imageName = cardViewModel.imageNames.first ?? ""
            imageView.image = UIImage(named: imageName)
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
            
            (0..<cardViewModel.imageNames.count).forEach { (_) in
                let barView = UIView()
                barView.backgroundColor = barDeselectedColor
                barsStackView.addArrangedSubview(barView)
            }
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
            
            setupImageIndexObserver()
        }
    }
    
    fileprivate func setupImageIndexObserver() {
        cardViewModel.imageIndexObserver = {(index, image) in
            print("changing")
            self.imageView.image = image
            
            self.barsStackView.arrangedSubviews.forEach { v in
                v.backgroundColor = self.barDeselectedColor
            }
            self.barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
    
    let img = UIImage(named: "lady5c")
    let imageView = UIImageView()
    let informationLabel = UILabel()
    let threshold: CGFloat = 100
    
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
    }
    
    //var imageIndex = 0
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        print("handling")
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false
        if shouldAdvanceNextPhoto {
            cardViewModel.advancedToNextPhoto()
        } else {
            cardViewModel.goToPreviousPhoto()
        }
        /*if shouldAdvanceNextPhoto {
            imageIndex = min(imageIndex + 1, cardViewModel.imageNames.count - 1)
            
        } else {
            imageIndex = max(0, imageIndex - 1)
        }//bu min maxlari arrayimizin boyutunu asip hata vermesin diye koyuyoruz.
        
        let imageName = cardViewModel.imageNames[imageIndex]
        imageView.image = UIImage(named: imageName)
        barsStackView.arrangedSubviews.forEach { v in
            v.backgroundColor = barDeselectedColor//secilmeyen fotolarin bar goruntusu olacak.
        }
        barsStackView.arrangedSubviews[imageIndex].backgroundColor = .white*/
        //bu usttekı kodu reactive programming yaparak viewmodela tasidik.
    }
    
    
    fileprivate func setupLayout() {
        // custom drawing code
        layer.cornerRadius = 10//imagein yanlarini yuvarladik.
        clipsToBounds = true//subviews to be clipped to the bounds of the view.

        imageView.image = img
        addSubview(imageView)
        imageView.fillSuperview()
        
        setupBarsStackView()
        
        // add a gradient layer somehow
        setupGradientLayer()
        
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        informationLabel.textColor = .white
        informationLabel.numberOfLines = 0//bu satir sinirini ortadan kaldiran fonks.1 yaparsak sinirli!
    }
    
    fileprivate let barsStackView = UIStackView()
    fileprivate func setupBarsStackView() {
        addSubview(barsStackView)
        barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 2))
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
        
    }
    
    
    let gradientLayer = CAGradientLayer()//layoutSubviews da erissin diye alttan buraya aldik.
    fileprivate func setupGradientLayer() {
        // how we can draw a gradient with swift
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        // self.frame is actually zero frame
        layer.addSublayer(gradientLayer)
    }
    override func layoutSubviews() {
        // in here you know what you CardView frame will be
        gradientLayer.frame = self.frame
    }
    
    
    //gesture
    @objc fileprivate func handlePan(_ gesture: UIPanGestureRecognizer){
        //print("panning img")
        //print(translation.x)//fotoyu kaydirmaya calistigimizdaki degisen x degerleri.
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ subview in
                subview.layer.removeAllAnimations()//takilmayi durdurmak icin.
            })
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

/*
 swift map fonksiyonu
 swift anchor fonksiyonu
 swift didset nedir
 removeallanimation swift
 arranged subview swift
 */
