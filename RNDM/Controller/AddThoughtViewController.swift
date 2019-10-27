//
//  AddThoughtViewController.swift
//  RNDM
//
//  Created by Molnár Csaba on 2019. 10. 27..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import UIKit
import Firebase

class AddThoughtViewController: UIViewController {
    @IBOutlet weak var categorySegment: UISegmentedControl!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var thoughtTxtA: UITextView!
    @IBOutlet weak var postBtn: UIButton!
    
    private var selectedCategory = ThoughtCategory.funny.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postBtn.layer.cornerRadius = 4
        thoughtTxtA.layer.cornerRadius = 4
        thoughtTxtA.text = "My random thought..."
        thoughtTxtA.textColor = UIColor.lightGray
        thoughtTxtA.delegate = self
        
    }
    
    @IBAction func categoryChanged(_ sender: Any) {
        switch categorySegment.selectedSegmentIndex {
        case 0:
            selectedCategory = ThoughtCategory.funny.rawValue
        case 1:
            selectedCategory = ThoughtCategory.serious.rawValue
        case 2:
            selectedCategory = ThoughtCategory.crazy.rawValue
        default :
            selectedCategory = ThoughtCategory.funny.rawValue
        }
    }
    
    @IBAction func postBtnTapped(_ sender: Any) {
        guard let username = userNameTxt.text else { return }
        guard let thoughtTxt = thoughtTxtA.text else { return }
        Firestore.firestore().collection(THOUGHT_REF).addDocument(data: [
            CATEGORY : selectedCategory,
            NUMCOMMENTS : 0,
            NUMLIKES : 0,
            THOUGHTTXT : thoughtTxt,
            TIMESTAMP : FieldValue.serverTimestamp(),
            USERNAME : username
        ]) { (error) in
            if let error = error {
                debugPrint("Error adding document_ \(error)")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension AddThoughtViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.darkGray
    }
}
