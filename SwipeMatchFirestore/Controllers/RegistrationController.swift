//
//  RegistrationController.swift
//  SwipeMatchFirestore
//
//  Created by Berke Ersiz on 30.10.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import JGProgressHUD
import FirebaseStorage

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        registrationViewModel.bindableImage.value = image
        
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    
}
class RegistrationController: UIViewController{
    
    // UI Components
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 300).isActive = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)//img secebilmek icin.
        button.imageView?.contentMode = .scaleAspectFill//sectigimiz img icin.
        button.clipsToBounds = true
        return button
    }()
    
    @objc fileprivate func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    let fullNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 44)
        tf.placeholder = "Enter Full Name"
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 44)
        tf.placeholder = "Enter Email"
        tf.keyboardType = .emailAddress
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 16, height: 44)
        tf.placeholder = "Enter Password"
        tf.isSecureTextEntry = true // yazilani gizlemek.
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    //bosluklar dolmadan butonun aktif olmamasi icin.
    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == fullNameTextField {
            print("fullnamechanging")
            registrationViewModel.fullName = textField.text
        } else if textField == emailTextField {
            print("emailchanging")
            registrationViewModel.email = textField.text
        } else {
            print("passwordchanging")
            registrationViewModel.password = textField.text
        }
    }
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        //button.backgroundColor = UIColor(cgColor: CGColor(red: 230, green: 0, blue: 83, alpha: 0.5))
        button.backgroundColor = .lightGray
        button.setTitleColor(.gray, for: .disabled)
        button.isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    let registeringHUD = JGProgressHUD(style: .dark)
    // giris kontrolu
    @objc fileprivate func handleRegister() {
        
        print("register our user in firebase auth.")
        self.handleTapDismiss()
        registrationViewModel.performRegistration { err  in
            if let err = err {
                self.showHUDWithError(error: err)
                return
            }
            print("registering finished.")
        }
        
    }

    fileprivate func showHUDWithError(error: Error) {
        registeringHUD.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed Registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()//arkaplan
        view.backgroundColor = .red
        setupLayout()//gorunum
        setupNotificationObservers()//klavye
        
        setupTapGesture()
        
        setupRegistrationViewModelObserver()

        
    }
    
    let registrationViewModel = RegistrationViewModel()
    fileprivate func setupRegistrationViewModelObserver() {
        registrationViewModel.bindableIsFormValid.bind { [unowned self] isFormValid in
            guard let isFormValid = isFormValid else { return }
            self.registerButton.isEnabled = isFormValid
            self.registerButton.setTitleColor(.white, for: .normal)
            self.registerButton.backgroundColor = UIColor(cgColor: CGColor(red: 230, green: 0, blue: 83, alpha: 0.5))
        }
//        registrationViewModel.isFormValidObserver = { [unowned self] (isFormValid) in
//
//            self.registerButton.isEnabled = isFormValid
//            if isFormValid {
//                self.registerButton.setTitleColor(.white, for: .normal)
//                self.registerButton.backgroundColor = UIColor(cgColor: CGColor(red: 230, green: 0, blue: 83, alpha: 0.5))
//            } else {
//                self.registerButton.backgroundColor = .lightGray
//                self.registerButton.setTitleColor(.gray , for: .normal)
//            }
//
        registrationViewModel.bindableImage.bind { [unowned self] img in
                self.selectPhotoButton.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
            
        }
        registrationViewModel.bindableIsRegistering.bind { [unowned self] isRegistering in
            if isRegistering == true {
                self.registeringHUD.textLabel.text = "Register"
                self.registeringHUD.show(in: view)
            } else {
                self.registeringHUD.dismiss()
            }
        }
        
        
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true) // dismisses keyboard
    }
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self) // yoo will have a retain cycle.! SOR
    }
    
    @objc func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1,options: .curveEaseOut) {
            self.view.transform = .identity
        }
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        print("keyboard will show")
        // how to figure out how tall the keyboard actually is
        //print(notification)
        guard let value = notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        print(keyboardFrame.height)
        // let's try to figure out how tall the gap is from the register button to the bottom of the screen.
        let bottomSpace = view.frame.height - overallStackView.frame.origin.y - overallStackView.frame.height
        print(view.frame.height)
        print(overallStackView.frame.origin.y)
        print(overallStackView.frame.height)
        
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference)
    }
    
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            selectPhotoButton,
            fullNameTextField,
            emailTextField,
            passwordTextField,
            registerButton
        ])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    lazy var overallStackView = UIStackView(arrangedSubviews: [
       selectPhotoButton,
       verticalStackView
    ])

    // yan dondurgumuzde axis nolucagini belirlemek icin hazir fonks kullandik.
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.verticalSizeClass == .compact {
            overallStackView.axis = .horizontal
        } else {
            overallStackView.axis = .vertical
        }
    }
    
    // MARK:- Private
    fileprivate func setupLayout() {
        view.addSubview(overallStackView)
        overallStackView.axis = .vertical
        selectPhotoButton.widthAnchor.constraint(equalToConstant: 275).isActive = true
        overallStackView.spacing = 8
        overallStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 32, bottom: 0, right: 32))
        overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    
    let gradientLayer = CAGradientLayer()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds//gorunumun ekrana yayilmasini sagladik.
    }

    fileprivate func setupGradientLayer() {
        
        let topColor = UIColor(cgColor: CGColor(red: 253, green: 91, blue: 95, alpha: 0.5))
        let bottomColor = UIColor(cgColor: CGColor(red: 229, green: 0, blue: 114, alpha: 0.5))
        // make sure to user cgColor.
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds//gorunumun ekrana yayilmasini sagladik.
    }
    
}
