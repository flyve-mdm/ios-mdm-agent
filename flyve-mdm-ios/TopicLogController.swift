/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * TopicLogController.swift is part of flyve-mdm-ios
 *
 * flyve-mdm-ios is a subproject of Flyve MDM. Flyve MDM is a mobile
 * device management software.
 *
 * flyve-mdm-ios is free software: you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 3
 * of the License, or (at your option) any later version.
 *
 * flyve-mdm-ios is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * ------------------------------------------------------------------------------
 * @author    Hector Rondon
 * @date      10/05/17
 * @copyright   Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios
 * @link      http://www.glpi-project.org/
 * ------------------------------------------------------------------------------
 */

import UIKit
import CocoaMQTT

class TopicLogController: UIViewController {
    
    var mqtt: CocoaMQTT?
    
    let cellId = "cellId"
    
    var bottomConstraint: CGFloat = 0.0
    
    var messages: [LogMessage] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var tableView: UITableView = {
        
        let table = UITableView(frame: .zero, style: .plain)
        
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        table.tableFooterView = UIView()
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 50
        
        table.register(LogCell.self, forCellReuseIdentifier: self.cellId)
        
        return table
        
    }()
    
    override func loadView() {
        super.loadView()
        
        self.setupViews()
        self.addConstraints()
        
        let name = NSNotification.Name(rawValue: "MQTTMessageNotification")
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedMessage(notification:)), name: name, object: nil)
    }
    
    func setupViews() {
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.tableView)
    }
    
    func addConstraints() {
        
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }

    func receivedMessage(notification: NSNotification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let content = userInfo["message"] as! String
        let topic = userInfo["topic"] as! String

        let logMessage = LogMessage(topic: topic, content: content)
        messages.append(logMessage)
    }
}

extension TopicLogController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
}

extension TopicLogController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! LogCell

        cell.messageTextView.text =  "\(self.messages.reversed()[indexPath.row].topic)\n\(self.messages.reversed()[indexPath.row].content)"
        
        return cell
    }
}

class LogCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.contentView.backgroundColor = .clear
        self.setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let messageTextView: UITextView = {
        
        let textView = UITextView()
        
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = UIColor.gray
        textView.backgroundColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        
        return textView
    }()
    
    func setupViews() {
        
        self.contentView.addSubview(self.messageTextView)
        
        addConstraintsView()
    }
    
    func addConstraintsView() {
        
        self.messageTextView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8).isActive = true
        self.messageTextView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 8).isActive = true
        self.messageTextView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -8).isActive = true
        self.messageTextView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8).isActive = true
    }
}

class LogMessage {
    
    let topic: String
    let content: String
    
    init(topic: String, content: String) {
        self.topic = topic
        self.content = content
    }
}
