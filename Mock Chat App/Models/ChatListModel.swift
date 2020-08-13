//
//  ChatListModel.swift
//  Mobile Chat Test
//
//  Created by Johnny Owayed on 8/11/20.
//  Copyright © 2020 Johnny Owayed. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import UIKit

class ChatListModel: RealmHelper {
    
    @objc dynamic var id = UUID.init().uuidString
    @objc dynamic var userName = ""
    @objc dynamic var date: Date? = nil
    @objc dynamic var profilePicture: Data? = nil
    let messages = List<MessageModel>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    class func create(withUserName username:String) -> ChatListModel {
        
        let chatListModel = ChatListModel()
        chatListModel.userName = username

        return chatListModel
    }
    
    func appendMessage(withMessage message:MessageModel) {
        self.messages.append(message)
        self.saveOrUpdate()
    }
    
    @objc class func currentList() -> [ChatListModel] {
        if (ChatListModel.hasObjects()) {
            return ChatListModel.allObjects()
        } else {
            return [ChatListModel]()
        }
    }
}
