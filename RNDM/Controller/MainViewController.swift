//
//  MainViewController.swift
//  RNDM
//
//  Created by Molnár Csaba on 2019. 10. 27..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    
    private var thoughts = [Thought]()
    private var thoughtCollectionRef: CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
        thoughtCollectionRef = Firestore.firestore().collection(THOUGHT_REF)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        thoughtCollectionRef.getDocuments { (snapshot, error) in
            if let error = error {
                debugPrint("error fetching data: \(error)")
            } else {
                guard let snapshot = snapshot else { return }
                for document in snapshot.documents {
                    let data = document.data()
                    let username = data[USERNAME] as? String ?? "Anonymous"
                    let timestamp = data[TIMESTAMP] as? Date ?? Date()
                    let numLikes = data[NUMLIKES] as? Int ?? 0
                    let numComments = data[NUMCOMMENTS] as? Int ?? 0
                    let thoughtTxt = data[THOUGHTTXT] as? String ?? "blabla"
                    let documentId = document.documentID
                    
                    let thought = Thought(userName: username, timestamp: timestamp, toughtTxt: thoughtTxt, numLikes: numLikes, numComments: numComments, documentId: documentId)
                    self.thoughts.append(thought)
                }
                self.tableView.reloadData()
            }
        }
    }
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thoughts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ThoughtTableViewCell", for: indexPath) as? ThoughtTableViewCell {
            cell.configureCell(thougt: thoughts[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
