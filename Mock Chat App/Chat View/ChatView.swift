//
//  ChatView.swift
//  Mobile Chat Test
//
//  Created by Johnny Owayed on 8/11/20.
//  Copyright © 2020 Johnny Owayed. All rights reserved.
//

import UIKit
import SnapKit
import GrowingTextView
import SwiftDate

enum TableViewCellId:String {
    case Text_Sent = "Cell-Text-Sent"
    case Text_Received = "Cell-Text-Received"
}

class ChatView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var button_Send: UIButton!
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var stackViewBottomConstraint: NSLayoutConstraint!
    
    var array_Messages = [MessageModel]()
    var chatListModel:ChatListModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        self.addGestureRecognizer(tapGesture)
        
        self.xibSetup()
        self.registerNibs()
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            if #available(iOS 11, *) {
                if keyboardHeight > 0 {
                    keyboardHeight = keyboardHeight - self.safeAreaInsets.bottom
                }
            }
            self.stackViewBottomConstraint.constant = keyboardHeight + 8
            DispatchQueue.main.async {
                self.scrollToBottom()
            }
            self.layoutIfNeeded()
        }
    }
    
    func scrollToBottom(animated:Bool? = true) {
        self.tableView.scrollToBottom(animated: animated)
    }
    
    @objc func tapGestureHandler() {
        self.endEditing(true)
    }

    private func xibSetup() {
        let view = self.loadNibView(fromNibName: "ChatView")
        self.contentView = view
        
        self.addSubview(self.contentView)
        self.sendSubviewToBack(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func setupView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.setContentOffset(CGPoint.init(x: 0, y: CGFloat.greatestFiniteMagnitude), animated: false)
        
        self.textView.delegate = self
        self.textView?.layer.cornerRadius = 8
        
        self.button_Send.isHidden = true
        
        let chatList = self.chatListModel.messages
        if !chatList.isEmpty {
            self.array_Messages = Array.init(chatList)
        }
        self.tableView.reloadData()
    }
    
    func registerNibs() {
        self.tableView.register(UINib.init(nibName: "Text-Bubble-Sent", bundle: nil), forCellReuseIdentifier: TableViewCellId.Text_Sent.rawValue)
        self.tableView.register(UINib.init(nibName: "Text-Bubble-Received", bundle: nil), forCellReuseIdentifier: TableViewCellId.Text_Received.rawValue)
    }
    
    private func loadNibView(fromNibName nibName: String) -> UIView {
        let nib = loadNibFile(nibName: nibName)
        let foundItems = nib.instantiate(withOwner: self, options: nil)
        return (foundItems.first as! UIView)
    }
    
    private func loadNibFile(nibName: String) -> UINib {
        let bundle = Bundle(for: type(of: self) as AnyClass)
        let nib:UINib = UINib.init(nibName: nibName, bundle: bundle)
        return nib
    }
    
    func reloadData() {
        self.tableView.reloadData()
        self.scrollToBottom()
    }
    
    func generateEcho() {
        let echoText = self.array_Messages.last?.messageText ?? ""
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
           let userData = self.chatListModel
           let messageModel = MessageModel.create(withMessage: echoText, senderId: userData?.id ?? "", receiveId: "Me" )
           for _ in 0...1 {
               RealmHelper.write {
                   self.chatListModel.appendMessage(withMessage: messageModel)
               }
               self.array_Messages.append(messageModel)
               self.tableView.reloadData()
               self.scrollToBottom()
           }
        }
    }
}

// MARK: - IBActions
extension ChatView {
    @IBAction func sendButtonPressed(_ sender: Any) {
        let userData = self.chatListModel
        let messageModel = MessageModel.create(withMessage: self.textView.text ?? "", senderId: "Me", receiveId: userData?.id ?? "")
        RealmHelper.write {
            self.chatListModel.appendMessage(withMessage: messageModel)
        }
        self.array_Messages.append(messageModel)
        self.tableView.reloadData()
        self.textView.text = ""
        self.scrollToBottom()
        self.button_Send.isHidden = true
        self.generateEcho()
    }
}

// MARK: - TableView Delegate & DataSource
extension ChatView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let messageModel = self.array_Messages[indexPath.row]
        
        if self.chatListModel.id == array_Messages[indexPath.row].senderId {
            cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellId.Text_Received.rawValue, for: indexPath)
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellId.Text_Sent.rawValue, for: indexPath)
        }
        
        cell.selectionStyle = .none
        
        let textView = (cell.viewWithTag(1) as? UITextView)
        let timeLabel = (cell.viewWithTag(2) as? UILabel)
        let bubbleView = cell.viewWithTag(3)
        
        textView?.text = nil
        timeLabel?.text = nil
        
        textView?.text = messageModel.messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let dateString = Utils.fetchFormatedDateString(date: messageModel.date)
        timeLabel?.text = dateString
        
        bubbleView?.layer.cornerRadius = 8
        
        if self.chatListModel.id == array_Messages[indexPath.row].senderId {
            if self.traitCollection.userInterfaceStyle == .dark {
                bubbleView?.backgroundColor = .darkGray
            } else {
                bubbleView?.backgroundColor = .lightGray
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return self.array_Messages.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

// MARK: - GrowingTextView Delegate
extension ChatView: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
            self.layoutIfNeeded()
        }, completion: nil)
    }
}

//MARK: - UITextView Delegate
extension ChatView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
             self.button_Send.isHidden = false
        } else{
            self.button_Send.isHidden = true
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
}
