//
//  ChatMessageModel.swift
//  Mobile Chat Test
//
//  Created by Johnny Owayed on 8/11/20.
//  Copyright © 2020 Johnny Owayed. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import UIKit

class MessageModel: RealmHelper {
    
    @objc dynamic var id = UUID.init().uuidString
    @objc dynamic var messageText = ""
    @objc dynamic var senderId = ""
    @objc dynamic var receiverId = ""
    @objc dynamic var date: Date! = nil
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    class func create(withMessage message:String, senderId:String, receiveId:String) -> MessageModel {
        
        let messageModel = MessageModel()
        messageModel.messageText = message
        messageModel.senderId = senderId
        messageModel.receiverId = receiveId
        messageModel.date = Date()

        return messageModel
    }
}
