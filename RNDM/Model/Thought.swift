//
//  Thought.swift
//  RNDM
//
//  Created by Molnár Csaba on 2019. 10. 27..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import Foundation
import Firebase

class Thought {
    private(set) var userName: String!
    private(set) var timestamp: Date!
    private(set) var toughtTxt: String!
    private(set) var numLikes: Int!
    private(set) var numComments: Int!
    private(set) var documentId: String!
    
    init(userName: String, timestamp: Date, toughtTxt: String, numLikes: Int, numComments: Int, documentId: String) {
        self.userName = userName
        self.timestamp = timestamp
        self.toughtTxt = toughtTxt
        self.numLikes = numLikes
        self.numComments = numComments
        self.documentId = documentId
    }
    
    class func parseData(snapshot: QuerySnapshot?) -> [Thought] {
        var thoughts = [Thought]()
        guard let snapshot = snapshot else { return thoughts}
        for document in snapshot.documents {
            let data = document.data()
            let username = data[USERNAME] as? String ?? "Anonymous"
            let timestamp = data[TIMESTAMP] as? Date ?? Date()
            let numLikes = data[NUMLIKES] as? Int ?? 0
            let numComments = data[NUMCOMMENTS] as? Int ?? 0
            let thoughtTxt = data[THOUGHTTXT] as? String ?? "blabla"
            let documentId = document.documentID
            
            let thought = Thought(userName: username, timestamp: timestamp, toughtTxt: thoughtTxt, numLikes: numLikes, numComments: numComments, documentId: documentId)
            thoughts.append(thought)
        }
            
            return thoughts
    }
}
