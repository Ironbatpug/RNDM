//
//  CommentsViewController.swift
//  RNDM
//
//  Created by Molnár Csaba on 2019. 10. 29..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import UIKit
import Firebase

class CommentsViewController: UIViewController {
    @IBOutlet weak var addcomment: UITextField!
    @IBOutlet weak var commentTxtField: UITextField!
    @IBOutlet weak var keyboardView: UIView!
    @IBOutlet weak var tableView: UITableView!

    var thought: Thought!
    private var comments = [Comment]()
    var thoughtRef: DocumentReference!
    let fireStore = Firestore.firestore()
    var userName: String!
    var commentsListener: ListenerRegistration!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        thoughtRef = fireStore.collection(THOUGHT_REF).document(thought.documentId)
        if let name = Auth.auth().currentUser?.displayName {
            userName = name
        }
        
        self.keyboardView.bindToKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        commentsListener = fireStore.collection(THOUGHT_REF).document(self.thought.documentId).collection(COMMENTS_REF).order(by: TIMESTAMP, descending: false).addSnapshotListener({ (snapshot, error) in
            guard let snapshot = snapshot else {
                debugPrint("error fetching comment \(error)")
                return
            }
            self.comments.removeAll()
            self.comments = Comment.parseData(snapshot: snapshot)
            self.tableView.reloadData()
        })
    }
    
    @IBAction func addcommentPressed(_ sender: Any) {
        guard let commentTxt = addcomment.text else { return }
        
        fireStore.runTransaction({ (transaction, error) -> Any? in
            let thoughtDocument: DocumentSnapshot
            do {
                try thoughtDocument = transaction.getDocument(Firestore.firestore().collection(THOUGHT_REF).document(self.thought.documentId))
            } catch let error as NSError {
                debugPrint("error getting the document \(error)")
                return nil
            }
            
            guard let oldNumComment = thoughtDocument.data()?[NUMCOMMENTS] as? Int else { return nil}
            
            transaction.updateData([NUMCOMMENTS : oldNumComment + 1], forDocument: self.thoughtRef)
            
            let newCommentRef = self.fireStore.collection(THOUGHT_REF).document(self.thought.documentId).collection(COMMENTS_REF).document()
            transaction.setData([
                COMMENT : commentTxt,
                TIMESTAMP: FieldValue.serverTimestamp(),
                USERNAME: self.userName,
                USERID: Auth.auth().currentUser?.uid ?? ""
            ], forDocument: newCommentRef)
            return nil
        }) { (object, error) in
            if let error = error {
                debugPrint("Transaction Failed: \(error)")
            } else {
                self.addcomment.text = ""
                self.addcomment.resignFirstResponder()
            }
        }
    }
}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
        cell.configureCell(comment: comments[indexPath.row], delegate: self)
        
        return cell
    }
}

extension CommentsViewController: CommentDelegate {
    func commentOptionsTapped(comment: Comment) {
        let alert = UIAlertController(title: "Edit Comment", message: "You can delete or edit", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete Comment", style: .default) { (action) in
            
            self.fireStore.runTransaction({ (transaction, error) -> Any? in
                let thoughtDocument: DocumentSnapshot
                do {
                    try thoughtDocument = transaction.getDocument(Firestore.firestore().collection(THOUGHT_REF).document(self.thought.documentId))
                } catch let error as NSError {
                    debugPrint("error getting the document \(error)")
                    return nil
                }
                
                guard let oldNumComment = thoughtDocument.data()?[NUMCOMMENTS] as? Int else { return nil}
                
                transaction.updateData([NUMCOMMENTS : oldNumComment - 1], forDocument: self.thoughtRef)
                
                let commentRef = self.fireStore.collection(THOUGHT_REF).document(self.thought.documentId).collection(COMMENTS_REF).document(comment.documentId)
                transaction.deleteDocument(commentRef)
                return nil
            }) { (object, error) in
                if let error = error {
                    debugPrint("Transaction Failed: \(error)")
                } else {
                    alert.dismiss(animated: true, completion: nil)
                }
            }
            //deleting a single document, which do not need transactions
//            self.fireStore.collection(THOUGHT_REF).document(self.thought.documentId).collection(COMMENTS_REF).document(comment.documentId).delete { (error) in
//                if let error = error {
//                    debugPrint("Unable to delete comment: \(error)")
//                } else {
//                    alert.dismiss(animated: true, completion: nil)
//                }
//            }
        }
        let editAction = UIAlertAction(title: "Edit Comment", style: .default) { (action) in
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(editAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    
}
