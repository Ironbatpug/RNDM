//
//  CommentsViewController.swift
//  RNDM
//
//  Created by Molnár Csaba on 2019. 10. 29..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController {
    @IBOutlet weak var addcomment: UITextField!
    @IBOutlet weak var commentTxtField: UITextField!
    @IBOutlet weak var keyboardView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var thought: Thought!
    
    private var comments = [Comment]()


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func addcommentPressed(_ sender: Any) {
    }
}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
        cell.configureCell(comment: comments[indexPath.row])
        
        return UITableViewCell()
    }
    
    
}
