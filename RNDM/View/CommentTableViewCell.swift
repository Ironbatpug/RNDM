//
//  CommentTableViewCell.swift
//  RNDM
//
//  Created by Molnár Csaba on 2019. 10. 29..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import UIKit
import Firebase

protocol CommentDelegate {
    func commentOptionsTapped(comment: Comment)
}

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var commentTxt: UILabel!
    @IBOutlet weak var optionsImg: UIImageView!
    
    private var comment: Comment!
    private var delegate: CommentDelegate?
    
    func configureCell(comment : Comment, delegate: CommentDelegate?) {
        optionsImg.isHidden = true
        self.delegate = delegate
        self.comment = comment
        userName.text = comment.userName
        commentTxt.text = comment.commentTxt
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, hh:mm"
        date.text = formatter.string(from: comment.timestamp)
        
        if comment.userId == Auth.auth().currentUser?.uid {
            optionsImg.isHidden = false
            optionsImg.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(commentOptionsTapped))
            optionsImg.addGestureRecognizer(tap)
        }
    }
    
    @objc func commentOptionsTapped() {
        delegate?.commentOptionsTapped(comment: comment)
    }
}
