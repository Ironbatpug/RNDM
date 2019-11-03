//
//  UpdateCommentViewController.swift
//  RNDM
//
//  Created by Molnár Csaba on 2019. 11. 03..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import UIKit
import Firebase
class UpdateCommentViewController: UIViewController {

    @IBOutlet weak var commentTxt: UITextView!
    @IBOutlet weak var updateBtn: UIButton!
    
    var commentData : (comment: Comment, thought: Thought)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTxt.text = commentData.comment.commentTxt
    }
    

    @IBAction func updateTapped(_ sender: Any) {
        Firestore.firestore().collection(THOUGHT_REF).document(commentData.thought.documentId).collection(COMMENTS_REF).document(commentData.comment.documentId).updateData([commentTxt : commentTxt.text]) { (error) in
            if let error = error {
                debugPrint("unable to update comment: \(error)")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
