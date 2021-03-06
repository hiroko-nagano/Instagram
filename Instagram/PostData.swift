//
//  PostData.swift
//  Instagram
//
//  Created by hiroko nagano on 2020/08/25.
//  Copyright © 2020 hiroko.nagano. All rights reserved.
//

import UIKit
import Firebase

class PostData: NSObject {
    var id: String
    var name: String?
    var caption: String?
    var date: Date?
    var likes: [String] = []
    var isLiked: Bool = false
    var coments: [String] = []
    
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        let postDic = document.data()
        self.name = postDic["name"] as? String
        self.caption = postDic["caption"] as? String       
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        
        if let likes = postDic["likes"] as? [String] {
            self.likes = likes
        }
        
        if let coments = postDic["coments"] as? [String] {
            self.coments = coments
        }
        
       
        
        if let myid = Auth.auth().currentUser?.uid {
            //likesの配列の中にmyidが含まれているかチェックすることで、自分がいいねを押しているか判断
            if self.likes.firstIndex(of: myid) != nil {
                //myidがあれば、いいねを押していると認識する
                self.isLiked = true
            }
        }
        
    }

}
