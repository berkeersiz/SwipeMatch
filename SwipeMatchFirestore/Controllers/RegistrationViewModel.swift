//
//  RegistrationViewModel.swift
//  SwipeMatchFirestore
//
//  Created by Berke Ersiz on 1.11.2023.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class RegistrationViewModel {
    
    
    var bindableImage = Bindable<UIImage>()
    var bindableIsRegistering = Bindable<Bool>()
    var bindableIsFormValid = Bindable<Bool>()

    
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
            self.saveImageToFirebase(completion: completion)
            // only upload images to firebase storage once you are authorized.
            
        }
    }
    
    fileprivate func saveImageToFirebase(completion: @escaping (Error?) ->()) { //neden escaping ekledik.
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("images")
        let filename = UUID().uuidString
        let imageReference = mediaFolder.child("\(filename).jpg")
        //let fileName = UUID().uuidString
        //let ref = Storage.storage().reference(withPath: "/images/\(fileName)")
        let imgData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ??  Data()
        imageReference.putData(imgData, metadata: nil, completion: { (_, err) in
            
            if let err = err {
                completion(err)
                return // bail
            }
            
            
            print("Finished uploading image to storage")
            imageReference.downloadURL(completion: { (url, err) in
                if let err = err {
                    completion(err)
                    return
                }
                
                self.bindableIsRegistering.value = false
                print("Download url of our image is:", url?.absoluteString ?? "")
                // store the download url into Firestore next lesson
                
                
                let imageUrl = url?.absoluteString ?? ""
                self.saveInfoToFirestore(imageUrl: imageUrl, completion: completion)
            })
            
        })
    }
    
    fileprivate func saveInfoToFirestore(imageUrl: String, completion: @escaping(Error?) -> ()) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData = ["fullName": fullName ?? "", "uid": uid, "imageUrl1": imageUrl]
        
        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
            if let err = err {
                completion(err)
                return
            }
            completion(nil)
        }
    }
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
//        isFormValidObserver?(isFormValid)
    }
    
    //var bindableIsFormValid = Bindable<Bool>()//ogren!!
    
    // Reactive programming
    //var isFormValidObserver: ((Bool) -> ())?
    
}
//Escaping??
//self.showHUDWithError nasil completion error donustu? 
