//
//  AddThoughtViewController.swift
//  RNDM
//
//  Created by Molnár Csaba on 2019. 10. 27..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import UIKit

class AddThoughtViewController: UIViewController {
    @IBOutlet weak var categorySegment: UISegmentedControl!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var thoughtTxtA: UITextView!
    @IBOutlet weak var postBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postBtn.layer.cornerRadius = 4
        thoughtTxtA.layer.cornerRadius = 4
        thoughtTxtA.text = "My random thought..."
        thoughtTxtA.textColor = UIColor.lightGray
        
    }
    
    @IBAction func categoryChanged(_ sender: Any) {
    }
    
    @IBAction func postBtnTapped(_ sender: Any) {
    }
}

extension AddThoughtViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.darkGray
    }
}
