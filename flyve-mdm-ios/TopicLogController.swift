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
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-agent
 * @link      https://.flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit
import CocoaMQTT

/// TopicLogController class
class TopicLogController: UIViewController {
    
    // MARK: Properties
    /// `mqtt`
    var mqtt: CocoaMQTT?
    /// `cellId`
    let cellId = "cellId"
    /// `bottomConstraint`
    var bottomConstraint: CGFloat = 0.0
    /// `messages`
    var messages: [LogMessage] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    /// This property contains the configuration of the table view
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
    
    // MARK: Init
    /// The navigation bar is set to be shown in view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    /// `override loadView()`
    override func loadView() {
        super.loadView()

        self.setupViews()
        self.addConstraints()

        let name = NSNotification.Name(rawValue: "MQTTMessageNotification")
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedMessage(notification:)), name: name, object: nil)
    }
    
    /// `setupViews()`
    func setupViews() {

        self.view.backgroundColor = .white
        self.navigationItem.title = NSLocalizedString("log_report", comment: "")
        self.view.addSubview(self.tableView)
    }

    /// `addConstraints()`
    func addConstraints() {

        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    // MARK: Notification
    /// `receivedMessage` notification
    func receivedMessage(notification: NSNotification) {
        let userInfo = notification.userInfo as? [String: AnyObject] ?? [String: AnyObject]()
        let content = userInfo["message"] as? String ?? String()
        let topic = userInfo["topic"] as? String ?? String()

        let logMessage = LogMessage(topic: topic, content: content)
        messages.append(logMessage)
    }
}

// MARK: UITableViewDelegate
extension TopicLogController: UITableViewDelegate {

    /**
     override `didSelectRowAt` from super class, tells the delegate that the specified row is now selected
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
}

// MARK: UITableViewDataSource
extension TopicLogController: UITableViewDataSource {
    
    /**
     override `numberOfRowsInSection` from super class, get number of row in sections
     
     - return: number of row in sections
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }

    /**
     override `cellForRowAt` from super class, Asks the data source for a cell to insert in a particular location of the table view
     
     - return: `UITableViewCell`
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as? LogCell

        cell?.messageTextView.text =  "\(self.messages.reversed()[indexPath.row].topic)\n\(self.messages.reversed()[indexPath.row].content)"

        return cell!
    }
}

/// LogCell class
class LogCell: UITableViewCell {
    
    /// init method
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.contentView.backgroundColor = .clear
        self.setupViews()
    }
    
    /// init method
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// messageTextView `UITextView`
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

    /// `setupViews()`
    func setupViews() {

        self.contentView.addSubview(self.messageTextView)

        addConstraintsView()
    }

    /// `addConstraintsView()`
    func addConstraintsView() {

        self.messageTextView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8).isActive = true
        self.messageTextView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 8).isActive = true
        self.messageTextView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -8).isActive = true
        self.messageTextView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8).isActive = true
    }
}

/// LogMessage class
class LogMessage {
    
    /// `topic`
    let topic: String
    /// `content`
    let content: String
    
    /// init method
    init(topic: String, content: String) {
        self.topic = topic
        self.content = content
    }
}
