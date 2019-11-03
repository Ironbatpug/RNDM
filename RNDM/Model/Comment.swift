//
//  Comment.swift
//  RNDM
//
//  Created by Molnár Csaba on 2019. 10. 29..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import Foundation
import Firebase

class Comment {
    private(set) var userName: String!
    private(set) var timestamp: Date!
    private(set) var commentTxt: String!
    private(set) var documentId: String!

    private(set) var userId: String!

    
    init(userName: String, timestamp: Date, commentTxt: String, documentId: String, userId: String) {
        self.userName = userName
        self.timestamp = timestamp
        self.commentTxt = commentTxt
        self.documentId = documentId
        self.userId = userId
    }
    
    class func parseData(snapshot: QuerySnapshot?) -> [Comment] {
        var comments = [Comment]()
        guard let snapshot = snapshot else { return comments}
        for document in snapshot.documents {
            let data = document.data()
            let username = data[USERNAME] as? String ?? "Anonymous"
            print()
            let postTimestamp = data["timestamp"] as? Timestamp ?? nil
            let timestamp = Date(timeIntervalSince1970: Double(postTimestamp!.seconds/1))
            let documentId = document.documentID
            let commentTxt = data[COMMENT] as? String ?? "blabla"
            
            let userId = data[USERID] as? String ?? ""
            
            let comment = Comment(userName: username, timestamp: timestamp, commentTxt: commentTxt, documentId: documentId,userId: userId)
            comments.append(comment)
        }
        
        return comments
    }
}
