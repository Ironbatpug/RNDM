//
//  ThoughtTableViewCell.swift
//  RNDM
//
//  Created by Molnár Csaba on 2019. 10. 27..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import UIKit
import Firebase

class ThoughtTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var thoughtsLbl: UILabel!
    @IBOutlet weak var likesImage: UIImageView!
    @IBOutlet weak var likesNumberLbl: UILabel!
    
    private var thought: Thought!
    
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

    func configureCell(thougt : Thought) {
        self.thought = thougt
        guard let time = thougt.timestamp  else { return }
        guard let numLikes = thougt.numLikes  else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, hh:mm"

        usernameLbl.text = thougt.userName
        dateLbl.text = formatter.string(from: time)
        thoughtsLbl.text = thougt.toughtTxt
        likesNumberLbl.text = String(describing: numLikes)
    }

}
