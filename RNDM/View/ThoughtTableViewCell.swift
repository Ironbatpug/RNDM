//
//  ThoughtTableViewCell.swift
//  RNDM
//
//  Created by Molnár Csaba on 2019. 10. 27..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import UIKit

class ThoughtTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var thoughtsLbl: UILabel!
    @IBOutlet weak var likesImage: UIImageView!
    @IBOutlet weak var likesNumberLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(thougt : Thought) {
        guard let time = thougt.timestamp  else { return }
        guard let numLikes = thougt.numLikes  else { return }

        usernameLbl.text = thougt.userName
        dateLbl.text = String(describing: time)
        thoughtsLbl.text = thougt.toughtTxt
        likesNumberLbl.text = String(describing: numLikes)
    }

}
