//
//  ThoughtTableViewCell.swift
//  RNDM
//
//  Created by Molnár Csaba on 2019. 10. 27..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import UIKit
import Firebase

protocol ThoughtDelegate {
    func thoughtOptionsTapped(thought: Thought)
}

class ThoughtTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var thoughtsLbl: UILabel!
    @IBOutlet weak var likesImage: UIImageView!
    @IBOutlet weak var likesNumberLbl: UILabel!
    @IBOutlet weak var commentsImage: UIImageView!
    @IBOutlet weak var commentsNumber: UILabel!
    @IBOutlet weak var optionImg: UIImageView!
    
    private var thought: Thought!
    private var delegate: ThoughtDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        likesImage.addGestureRecognizer(tap)
        likesImage.isUserInteractionEnabled = true
    }
    
    @objc func likeTapped() {
        //method one
//        Firestore.firestore().collection(THOUGHT_REF).document(thought.documentId).setData([NUMLIKES : thought.numLikes + 1], merge: true)
        
        //method two
        Firestore.firestore().document("thoughts/\(thought.documentId!)").updateData([NUMLIKES : thought.numLikes + 1])
    }

    func configureCell(thougt : Thought, delegeta: ThoughtDelegate?) {
        optionImg.isHidden = true
        self.thought = thougt
        self.delegate = delegeta
        guard let time = thougt.timestamp  else { return }
        guard let numLikes = thougt.numLikes  else { return }
        guard let commentsNumbers = thougt.numComments  else { return }

        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, hh:mm"

        usernameLbl.text = thougt.userName
        dateLbl.text = formatter.string(from: time)
        thoughtsLbl.text = thougt.toughtTxt
        likesNumberLbl.text = String(describing: numLikes)
        commentsNumber.text = String(describing: commentsNumbers)
        
        if thougt.userId == Auth.auth().currentUser?.uid {
            optionImg.isHidden = false
            optionImg.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(thoughtOptionsTapped))
            optionImg.addGestureRecognizer(tap)
        }
    }
    
    @objc func thoughtOptionsTapped() {
        delegate?.thoughtOptionsTapped(thought: thought)
    }

}
