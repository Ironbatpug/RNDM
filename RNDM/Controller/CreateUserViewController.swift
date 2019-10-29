//
//  CreateUserViewController.swift
//  RNDM
//
//  Created by Molnár Csaba on 2019. 10. 27..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import UIKit
import Firebase

class CreateUserViewController: UIViewController {
    @IBOutlet weak var emailtxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var createUserBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func createUserBtnPressed(_ sender: Any) {
        guard let email = emailtxt.text, let password = passwordTxt.text, let username = userNameTxt.text else { return }
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                debugPrint("error creating a user: \(error)")
            } else {
                let changeRequest = authResult?.user.createProfileChangeRequest()
                changeRequest?.displayName = username
                changeRequest?.commitChanges(completion: { (error) in
                    if let error = error {
                        debugPrint("error creating a user: \(error)")
                    }
                })
                guard let userId = authResult?.user.uid else { return }
                
                Firestore.firestore().collection(USERS_REF).document(userId).setData([
                    USER_NAME : username,
                    DATE_CREATED : FieldValue.serverTimestamp()
                    ], completion: { (error) in
                        if let error = error {
                            debugPrint("error creating a user: \(error)")
                        } else {
                            self.dismiss(animated: true, completion: nil)
                        }
                })
            }
        }
    }
    
    @IBAction func canceBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
