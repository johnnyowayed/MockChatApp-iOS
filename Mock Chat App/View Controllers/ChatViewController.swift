//
//  ChatViewController.swift
//  Mobile Chat Test
//
//  Created by Johnny Owayed on 8/11/20.
//  Copyright © 2020 Johnny Owayed. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var chatView: ChatView!
    
    var array_Messages = [MessageModel]()
    var chatListModel = ChatListModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.chatView.chatListModel = self.chatListModel
        self.chatView.setupView()
        self.chatView.reloadData()
    }
}
