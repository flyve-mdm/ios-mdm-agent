/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * SupervisorController.swift is part of flyve-mdm-ios
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
 * @date      31/07/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-agent
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit
import MessageUI

/// SupervisorController class
class SupervisorController: UIViewController {
    
    // MARK: Properties
    /// `cellIdMain`
    let cellIdMain = "cellIdMain"
    /// `cellIdInfo`
    let cellIdInfo = "cellIdInfo"
    /// `supervisor`
    var supervisor = [String: AnyObject]()
    /// `httpRequest`
    var httpRequest: HttpRequest?
    /// `cellIentitydMain`
    var entity = ""
    
    /// supervisorTableView `UITableView`
    lazy var supervisorTableView: UITableView = {
        
        let table = UITableView(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.tableFooterView = UIView()
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 100
        table.isScrollEnabled = false
        table.register(SupervisorMainCell.self, forCellReuseIdentifier: self.cellIdMain)
        table.register(SupervisorInfoCell.self, forCellReuseIdentifier: self.cellIdInfo)
        
        return table
    }()
    
    // MARK: Init
    /// `override viewWillAppear(_ animated: Bool)`
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    /// `override loadView()`
    override func loadView() {
        
        if let supervisorObject = getStorage(key: "supervisor") as? [String: AnyObject] {
            supervisor = supervisorObject
        }
        
        if let deeplink = getStorage(key: "deeplink") as? DeepLinkModel {
            httpRequest = HttpRequest()
            httpRequest?.requestInitSession(userToken: deeplink.userToken)
            httpRequest?.delegate = self
        }
        
        super.loadView()
        self.setupViews()
        self.addConstraints()
    }
    
    /// `setupViews()`
    func setupViews() {
        self.view.backgroundColor = .white
        
        let saveButton = UIBarButtonItem(title: "share".localized,
                                         style: UIBarButtonItemStyle.plain,
                                         target: self,
                                         action: #selector(self.share))
        
        let cancelButton = UIBarButtonItem(title: "cancel".localized,
                                           style: UIBarButtonItemStyle.plain,
                                           target: self,
                                           action: #selector(self.cancel))
        
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationItem.leftBarButtonItem = cancelButton

        self.view.addSubview(self.supervisorTableView)
    }
    
    /// `addConstraints()`
    func addConstraints() {
        supervisorTableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        supervisorTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        supervisorTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        supervisorTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }
    
    /// back main screen
    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// share support information
    func share() {
        
        let shareText = "\(supervisor["support_name"] as? String ?? "support name")\n\(supervisor["support_email"] as? String ?? "support email")\n\(supervisor["support_phone"] as? String ?? "support phone")"
        
        let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
        present(vc, animated: true)
    }
    
    /// call support phone number
    func call() {
        guard let number = URL(string: "tel://" + "\(supervisor["support_phone"] as? String ?? "")") else { return }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(number)
        } else {
            UIApplication.shared.openURL(number)
        }
    }
    
    /// send sms message to support pnone number
    func message() {

        if let phoneNumber = supervisor["support_phone"] as? String {
            
            let composer = MFMessageComposeViewController()
            
            if MFMessageComposeViewController.canSendText() {
                composer.messageComposeDelegate = self
                composer.recipients = [phoneNumber]
                present(composer, animated: true, completion: nil)
            }
        }
    }
    
    /// send email to support
    func email() {
        
        if let email = supervisor["support_email"] as? String {
            
            let composer = MFMailComposeViewController()
            
            if MFMailComposeViewController.canSendMail() {
                composer.mailComposeDelegate = self
                composer.setToRecipients([email])
                present(composer, animated: true, completion: nil)
            }
        }
    }
}

// MARK: HttpRequestDelegate
extension SupervisorController: HttpRequestDelegate {
    
    /// `responseInitSession`
    func responseInitSession(data: [String: AnyObject]) {
        
        if let session_token = data["session_token"] as? String {
            SESSION_TOKEN = session_token
            httpRequest?.requestGetFullSession()
        }
    }
    
    /// `errorInitSession`
    func errorInitSession(error: [String: String]) {
        Logger.log(message: error["message"] ?? "", type: .error)
    }
    /// `responseGetFullSession`
    func responseGetFullSession(data: [String: AnyObject]) {
        
        if let profiles_id = (data["session"]?["glpiactiveprofile"] as? [String: AnyObject])?["id"] as? Int, let guest_profiles_id = data["session"]?["plugin_flyvemdm_guest_profiles_id"] as? Int {
            
            if profiles_id == guest_profiles_id {
                httpRequest?.requestChangeActiveProfile(profilesID: "\(profiles_id)")
                
                if let entity = data["session"]?["glpiactive_entity"] as? Int {
                    self.entity = "\(entity)"
                }
                
            } else {
                print("Error: Change active profile")
            }
        } else {
            print("Error: Change active profile")
        }
    }
    
    /// `errorGetFullSession`
    func errorGetFullSession(error: [String: String]) {
        Logger.log(message: error["message"] ?? "", type: .error)
    }
    
    /// `responseChangeActiveProfile`
    func responseChangeActiveProfile() {
        
        self.httpRequest?.requestPluginFlyvemdmEntityConfig(entityID: entity)
    }
    
    /// `errorChangeActiveProfile`
    func errorChangeActiveProfile(error: [String: String]) {
        Logger.log(message: error["message"] ?? "", type: .error)
    }
    
    /// `responsePluginFlyvemdmEntityConfig`
    func responsePluginFlyvemdmEntityConfig(data: [String : AnyObject]) {

        setStorage(value: data as AnyObject, key: "supervisor")
    }
    
    /// `errorPluginFlyvemdmEntityConfig`
    func errorPluginFlyvemdmEntityConfig(error: [String : String]) {
        Logger.log(message: error["message"] ?? "", type: .error)
    }
}

// MARK: MFMailComposeViewControllerDelegate
extension SupervisorController: MFMailComposeViewControllerDelegate {
    
    /// implemente delegate `didFinishWith`
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: MFMessageComposeViewControllerDelegate
extension SupervisorController: MFMessageComposeViewControllerDelegate {
    
    /// implemente delegate `didFinishWith`
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: UITableViewDelegate
extension SupervisorController: UITableViewDelegate {
    
    // MARK: UITableViewDelegate
    /**
     override `didSelectRowAt` from super class, tells the delegate that the specified row is now selected
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: UITableViewDataSource
extension SupervisorController: UITableViewDataSource {
    
    /**
     override `numberOfRowsInSection` from super class, get number of row in sections
     
     - return: number of row in sections
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    /**
     override `cellForRowAt` from super class, Asks the data source for a cell to insert in a particular location of the table view
     
     - return: `UITableViewCell`
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdMain, for: indexPath) as? SupervisorMainCell
            
            cell?.nameLabel.text = supervisor["support_name"] as? String ?? "Support name"
            cell?.detailLabel.text = ""
            
            return cell!

        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdInfo, for: indexPath) as? SupervisorInfoCell
            
            if indexPath.row == 1 {
                cell?.nameLabel.text = supervisor["support_phone"] as? String ?? "Phone number"
                
                cell?.firstBotton.image = UIImage(named: "call")?.withRenderingMode(.alwaysTemplate)
                
                let tapGestureCall = UITapGestureRecognizer(target: self, action: #selector(self.call))
                cell?.firstBotton.addGestureRecognizer(tapGestureCall)
                
                cell?.secondBotton.image = UIImage(named: "message")?.withRenderingMode(.alwaysTemplate)
                
                let tapGestureMessage = UITapGestureRecognizer(target: self, action: #selector(self.message))
                cell?.secondBotton.addGestureRecognizer(tapGestureMessage)
                
            } else if indexPath.row == 2 {
                cell?.nameLabel.text = supervisor["support_website"] as? String ?? "Web site"
            } else if indexPath.row == 3 {
                cell?.nameLabel.text = supervisor["support_email"] as? String ?? "Email"
                
                cell?.firstBotton.image = UIImage(named: "email")?.withRenderingMode(.alwaysTemplate)
                
                let tapGestureCall = UITapGestureRecognizer(target: self, action: #selector(self.email))
                cell?.firstBotton.addGestureRecognizer(tapGestureCall)

            } else if indexPath.row == 4 {
                cell?.nameLabel.text = supervisor["support_address"] as? String ?? "Address"
                cell?.nameLabel.numberOfLines = 0
                cell?.footerView.isHidden = true
            }
            return cell!
        }
    }
}

/// SupervisorMainCell class
class SupervisorMainCell: UITableViewCell {
    
    // MARK: Properties
    /// photoImageView `UIImageView`
    let photoImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.autoresizingMask = [.flexibleWidth,
                                      .flexibleHeight]
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.backgroundColor = UIColor.background
        
        return imageView
    }()
    
    /// nameLabel `UILabel`
    let nameLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        
        return label
    }()
    
    /// detailLabel `UILabel`
    let detailLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        
        return label
    }()
    
    // MARK: Init
    /// `override init method`
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.contentView.backgroundColor = .clear
        setupView()
    }
    
    /// `override init method`
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// `override layoutSubviews()`
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    /// `setupView()`
    func setupView() {
        
        backgroundColor = .white
        
        contentView.addSubview(photoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(detailLabel)
        
        addConstraints()
    }
    
    /// `addConstraints()`
    func addConstraints() {
        
        photoImageView.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        photoImageView.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true

        nameLabel.bottomAnchor.constraint(equalTo: photoImageView.centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 16).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        detailLabel.topAnchor.constraint(equalTo: photoImageView.centerYAnchor).isActive = true
        detailLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 16).isActive = true
        detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
}

/// SupervisorInfoCell class
class SupervisorInfoCell: UITableViewCell {
    
    // MARK: Properties
    /// firstBotton `UIImageView`
    lazy var firstBotton: UIImageView = {
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.autoresizingMask = [.flexibleWidth,
                                      .flexibleHeight]
        imageView.clipsToBounds = true
        imageView.tintColor = self.tintColor
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    /// secondBotton `UIImageView`
    lazy var secondBotton: UIImageView = {
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.autoresizingMask = [.flexibleWidth,
                                      .flexibleHeight]
        imageView.clipsToBounds = true
        imageView.tintColor = self.tintColor
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    /// nameLabel `UILabel`
    let nameLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        
        return label
    }()
    
    /// footerView `UIView`
    let footerView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        
        return view
    }()
    
    // MARK: Init
    /// `override init`
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.contentView.backgroundColor = .clear
        setupView()
    }
    
    /// `override init`
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// `override layoutSubviews()`
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    /// `setupView()`
    func setupView() {
        
        backgroundColor = .clear
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(firstBotton)
        contentView.addSubview(secondBotton)
        contentView.addSubview(footerView)
        
        addConstraints()
    }
    
    /// `addConstraints()`
    func addConstraints() {
        
        nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        nameLabel.rightAnchor.constraint(lessThanOrEqualTo: secondBotton.leftAnchor, constant: -8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        firstBotton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        firstBotton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        firstBotton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        firstBotton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        secondBotton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        secondBotton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        secondBotton.rightAnchor.constraint(equalTo: firstBotton.leftAnchor, constant: -16).isActive = true
        secondBotton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        footerView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        footerView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        footerView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        footerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
