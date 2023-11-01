//
//  RegistrationViewModel.swift
//  SwipeMatchFirestore
//
//  Created by Berke Ersiz on 1.11.2023.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class RegistrationViewModel {
    
    
    var bindableImage = Bindable<UIImage>()
    var bindableIsRegistering = Bindable<Bool>()
//    var image: UIImage? {
//        didSet {
//            imageObserver?(image)
//        }
//    }
//    var imageObserver: ((UIImage?) -> ())?
    
    var fullName: String? {
        didSet {
            checkFormValidity()
        }
    }
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    
    func performRegistration(completion: @escaping (Error?) -> ()){
        guard let email = email else {return}
        guard let password = password else {return}
        bindableIsRegistering.value = true
        Auth.auth().createUser(withEmail: email, password: password)
        { (res, err) in
            
            if let err = err {
                print(err)
                completion(err)
                return
            }
            print("succuuessfully registered user:", res?.user.uid ?? "")
            
            // only upload images to firebase storage once you are authorized.
            let fileName = UUID().uuidString
            let ref = Storage.storage().reference(withPath: "/images/\(fileName)")
            let imgData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ??  Data()
            ref.putData(imgData) { _, err in
                if let err = err {
                    completion(err)
                    //self.showHUDWithError(error: err)
                    return
                }
                print("finish uploading image to storage.")
                ref.downloadURL { url, err in
                    if let err = err {
                        completion(err)
                        //self.showHUDWithError(error: err)
                        return
                    }
                    self.bindableIsRegistering.value = false
                    print("download url out of our img is:", url?.absoluteString ?? "")
                }
            }
        }
    }
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
//        isFormValidObserver?(isFormValid)
    }
    
    var bindableIsFormValid = Bindable<Bool>()//ogren!! 
    
    // Reactive programming
    //var isFormValidObserver: ((Bool) -> ())?
    
}
//Escaping??
//self.showHUDWithError nasil completion error donustu? 
