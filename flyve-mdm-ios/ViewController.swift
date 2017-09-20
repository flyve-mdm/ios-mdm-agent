/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * ViewController.swift is part of flyve-mdm-ios
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
 * @date      03/05/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-agent
 * @link      https://.flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import Foundation
import UIKit

/// enumerate states enrollment
enum EnrollmentState {
    /// `initial`
    case initial
    /// `loading`
    case loading
    /// `success`
    case success
    /// `fail`
    case fail
}

/// ViewController class
class ViewController: UIViewController {
    // MARK: Properties
    /// `httpRequest`
    var httpRequest: HttpRequest?
    /// ``
    var mdmAgent = [String: Any]()
    /// `userToken`
    var userToken: String?
    /// `invitationToken`
    var invitationToken: String?
    /// `topic`
    var topic: String?
    
    /// This property contains the configuration of the logo image view
    let logoImageView: UIImageView = {
        
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    /// This property contains the configuration of the message label
    let messageLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("message_init", comment: "")
        label.sizeToFit()
        label.numberOfLines = 0
        label.minimumScaleFactor = 14.0
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.textColor = .gray
        
        return label
    }()
    
    /// This property contains the configuration of the title label
    let titleLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("enroll_device", comment: "")
        label.font = UIFont.systemFont(ofSize: 36.0, weight: UIFontWeightLight)
        label.sizeToFit()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.textColor = .black
        
        return label
    }()
    
    /// statusLabel `UILabel`
    let statusLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.sizeToFit()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.textColor = .gray
        
        return label
    }()
    
    /// UIButton `UIButton`
    lazy var urlBotton: UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("https://flyve-mdm.com", for: .normal)
        button.addTarget(self, action: #selector(self.openURL), for: .touchUpInside)
        
        return button
    }()
    
    /// enrollBotton `UIButton`
    lazy var enrollBotton: UIButton = {
        
        let button = UIButton(type: UIButtonType.custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 45
        button.backgroundColor = UIColor.main
        button.addTarget(self, action: #selector(self.enroll), for: .touchUpInside)
        
        return button
    }()
    
    /// playImageView `UIImageView`
    let playImageView: UIImageView = {
        
        let imageView = UIImageView(image: UIImage(named: "play"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    /// loadingIndicatorView `UIActivityIndicatorView`
    let loadingIndicatorView: UIActivityIndicatorView = {
        
        let loading = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.hidesWhenStopped = true
        
        return loading
    }()

    // MARK: Init
    /// init method
    init(userToken: String, invitationToken: String?) {
        self.userToken = userToken
        self.invitationToken = invitationToken

        super.init(nibName: nil, bundle: nil)
    }
    
    /// init method
    init(mdmAgent: [String: Any]) {

        self.mdmAgent = mdmAgent

        super.init(nibName: nil, bundle: nil)
    }

    /// init method
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// `override viewWillAppear(_ animated: Bool) `
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    /// `override loadView()`
    override func loadView() {
        super.loadView()

        let notificationData = NotificationCenter.default
        notificationData.addObserver(self, selector: #selector(self.sendDataEnroll), name: NSNotification.Name(rawValue: "setDataEnroll"), object: nil)

        if (self.userToken != nil), !self.userToken!.isEmpty {
            self.setupViews()

        } else {
            self.setupViewsEmpty()
        }
    }

    /// `setupViews()`
    func setupViews() {

        self.view.backgroundColor = UIColor.background
        self.navigationController?.isNavigationBarHidden = true
        self.view.addSubview(self.messageLabel)
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.enrollBotton)
        self.enrollBotton.addSubview(self.playImageView)
        self.enrollBotton.addSubview(self.loadingIndicatorView)
        self.view.addSubview(self.statusLabel)

        self.addConstraints()
    }

    /// `addConstraints()`
    func addConstraints() {

        self.logoImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 72).isActive = true
        self.logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        self.messageLabel.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 16).isActive = true
        self.messageLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24).isActive = true
        self.messageLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true

        self.titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.titleLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 24).isActive = true

        self.messageLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.titleLabel.topAnchor, constant: -16).isActive = true

        self.enrollBotton.widthAnchor.constraint(equalToConstant: 90.0).isActive = true
        self.enrollBotton.heightAnchor.constraint(equalToConstant: 90.0).isActive = true
        self.enrollBotton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.enrollBotton.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 24).isActive = true

        self.playImageView.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        self.playImageView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        self.playImageView.centerXAnchor.constraint(equalTo: self.enrollBotton.centerXAnchor).isActive = true
        self.playImageView.centerYAnchor.constraint(equalTo: self.enrollBotton.centerYAnchor).isActive = true

        self.loadingIndicatorView.centerXAnchor.constraint(equalTo: self.enrollBotton.centerXAnchor).isActive = true
        self.loadingIndicatorView.centerYAnchor.constraint(equalTo: self.enrollBotton.centerYAnchor).isActive = true

        self.statusLabel.topAnchor.constraint(equalTo: self.enrollBotton.bottomAnchor, constant: 48).isActive = true
        self.statusLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.statusLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24).isActive = true
        self.statusLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true
        self.statusLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8).isActive = true
    }

    /// `setupViewsEmpty()`
    func setupViewsEmpty() {

        self.view.backgroundColor = UIColor.background
        self.navigationController?.isNavigationBarHidden = true
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(self.messageLabel)
        self.view.addSubview(self.urlBotton)

        self.addConstraintsEmpty()
    }

    /// `addConstraintsEmpty()`
    func addConstraintsEmpty() {

        self.logoImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 72).isActive = true
        self.logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        self.messageLabel.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 24).isActive = true
        self.messageLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24).isActive = true
        self.messageLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true

        self.urlBotton.topAnchor.constraint(equalTo: self.messageLabel.bottomAnchor, constant: 48).isActive = true
        self.urlBotton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    /// Open URL Flyve MDM
    func openURL() {
        guard let url = URL(string: "https://flyve-mdm.com") else { return }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    /// Start to enroll process
    func enroll() {

        self.httpRequest = HttpRequest()
        self.httpRequest?.requestInitSession(userToken: self.userToken!)
        self.httpRequest?.delegate = self
        self.enrollState(.loading)
    }

    /**
     Set enrollment states
     
     - parameter state: enumerate type EnrollmentState
     */
    func enrollState(_ state: EnrollmentState) {

        switch state {
        case .initial:
            self.titleLabel.text = NSLocalizedString("enroll_device", comment: "")
            self.enrollBotton.backgroundColor = UIColor.main
            self.enrollBotton.isUserInteractionEnabled = true
            self.playImageView.image = UIImage(named: "play")
            self.playImageView.isHidden = false
            self.loadingIndicatorView.stopAnimating()
            self.statusLabel.text = ""

        case .loading:
            self.titleLabel.text = NSLocalizedString("enroll_device", comment: "")
            self.enrollBotton.backgroundColor = UIColor.loading
            self.enrollBotton.isUserInteractionEnabled = false
            self.playImageView.isHidden = true
            self.loadingIndicatorView.startAnimating()
            self.statusLabel.text = NSLocalizedString("loading", comment: "")

        case .success:
            self.enrollBotton.backgroundColor = UIColor.main
            self.enrollBotton.isUserInteractionEnabled = false
            self.playImageView.image = UIImage(named: "")
            self.playImageView.image = UIImage(named: "success")
            self.playImageView.isHidden = false
            self.loadingIndicatorView.stopAnimating()
            self.statusLabel.text = NSLocalizedString("success", comment: "")

        case .fail:
            self.titleLabel.text = NSLocalizedString("enroll_fail", comment: "")
            self.enrollBotton.backgroundColor = UIColor.fail
            self.enrollBotton.isUserInteractionEnabled = false
            self.playImageView.isHidden = true
            self.loadingIndicatorView.stopAnimating()
            self.statusLabel.text = ""

            delay {
                self.enrollState(.initial)
            }
        }
    }
}

// MARK: HttpRequestDelegate
extension ViewController: HttpRequestDelegate {

    /// `responseInitSession`
    func responseInitSession(data: [String: AnyObject]) {

        if let session_token = data["session_token"] as? String {
            SESSION_TOKEN = session_token
            self.httpRequest?.requestGetFullSession()
        }
    }
    
    /// `errorInitSession`
    func errorInitSession(error: [String: String]) {

        self.enrollState(.fail)
        self.statusLabel.text = "\(error["message"] ?? "")"
    }

    /// `responseGetFullSession`
    func responseGetFullSession(data: [String: AnyObject]) {

        if let profiles_id = (data["session"]?["glpiactiveprofile"] as? [String: AnyObject])?["id"] as? Int, let guest_profiles_id = data["session"]?["plugin_flyvemdm_guest_profiles_id"] as? Int {

            if profiles_id == guest_profiles_id {
                self.httpRequest?.requestChangeActiveProfile(profilesID: "\(profiles_id)")
                
                if let entity = data["session"]?["glpiactive_entity"] as? Int {
                    self.httpRequest?.requestPluginFlyvemdmEntityConfig(entityID: "\(entity)")
                }

            } else {
                self.statusLabel.text = NSLocalizedString("error_profile", comment: "")
            }
        } else {
            self.statusLabel.text = NSLocalizedString("error_profile", comment: "")
        }
    }

    /// `errorGetFullSession`
    func errorGetFullSession(error: [String: String]) {

        self.enrollState(.fail)
        self.statusLabel.text = "\(error["message"] ?? "")"
    }
    
    /// `responsePluginFlyvemdmEntityConfig`
    func responsePluginFlyvemdmEntityConfig(data: [String : AnyObject]) {
        setStorage(value: data as AnyObject, key: "supervisor")
    }
    
    /// `errorPluginFlyvemdmEntityConfig`
    func errorPluginFlyvemdmEntityConfig(error: [String : String]) {
        Logger.log(message: error["message"] ?? "", type: .error)
    }
    
    /// `responseChangeActiveProfile`
    func responseChangeActiveProfile() {
        self.present(UINavigationController(rootViewController: EnrollFormController()), animated: true, completion: nil)
    }
    
    /// send data enrollment
    func sendDataEnroll(notification: NSNotification) {

        var jsonDictionary = [String: AnyObject]()
        var inputDictionary = [String: String]()
        var userDictionary = [String: AnyObject]()
        
        if let email = (notification.userInfo?["emails"] as? [AnyObject])?.first?["email"] as? String, !email.isEmpty {
            inputDictionary["_email"] = email
        }
        
        if let phone = (notification.userInfo?["phones"] as? [AnyObject])?.first?["phone"] as? String, !phone.isEmpty {
            inputDictionary["phone"] = phone
        }

        inputDictionary["_invitation_token"] = self.invitationToken
        inputDictionary["_serial"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
        inputDictionary["_uuid"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
        inputDictionary["csr"] = ""
        inputDictionary["firstname"] = notification.userInfo?["firstname"] as? String ?? ""
        inputDictionary["lastname"] = notification.userInfo?["lastname"] as? String ?? ""
        inputDictionary["type"] = "apple"

        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            inputDictionary["version"] = version
        }

        jsonDictionary["input"] = inputDictionary as AnyObject
        
        if let userInfo = notification.userInfo as? [String : AnyObject] {
            userDictionary["firstname"] = userInfo["firstname"]
            userDictionary["lastname"] = userInfo["lastname"]
            userDictionary["language"] = userInfo["language"]
            userDictionary["emails"] = userInfo["emails"]
            userDictionary["phones"] = userInfo["phones"]
        }
        
        let enrollInfo = EnrollModel(data: inputDictionary as [String : AnyObject])
        setStorage(value: enrollInfo as AnyObject, key: "enroll")
        
        let user = UserModel(data: userDictionary)
        setStorage(value: user as AnyObject, key: "dataUser")

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data
            // you can now cast it with the right type
            if let dictFromJSON = decoded as? [String : AnyObject] {
                // use dictFromJSON
                self.httpRequest?.requestPluginFlyvemdmAgent(parameters: dictFromJSON)
            }
        } catch {
            Logger.log(message: error.localizedDescription, type: .error)
            debugPrint(error.localizedDescription)
            self.loadingIndicatorView.stopAnimating()
        }
    }
    
    /// `errorChangeActiveProfile`
    func errorChangeActiveProfile(error: [String: String]) {

        UserDefaults.standard.set(nil, forKey: "dataUser")
        self.enrollState(.fail)
        self.statusLabel.text = "\(error["message"] ?? "")"
    }
    
    /// `responsePluginFlyvemdmAgent`
    func responsePluginFlyvemdmAgent(data: [String: AnyObject]) {

        if let id = data["id"] as? Int {
            self.httpRequest?.requestGetPluginFlyvemdmAgent(agentID: "\(id)")
        }
    }
    
    /// `errorPluginFlyvemdmAgent`
    func errorPluginFlyvemdmAgent(error: [String: String]) {

        self.enrollState(.fail)
        self.statusLabel.text = "\(error["message"] ?? "")"
        Logger.log(message: error["message"] ?? "", type: .error)
    }

    /// `responseGetPluginFlyvemdmAgent`
    func responseGetPluginFlyvemdmAgent(data: [String: AnyObject]) {

        setStorage(value: data as AnyObject, key: "mdmAgent")
        self.enrollState(.success)

        delay {
            self.goMainController()
        }
    }

    /// `errorGetPluginFlyvemdmAgent`
    func errorGetPluginFlyvemdmAgent(error: [String: String]) {

        self.enrollState(.fail)
        self.statusLabel.text = "\(error["message"] ?? "")"
        Logger.log(message: error["message"] ?? "", type: .error)
    }

    /// go Main screen Controller
    func goMainController() {

        if let mdmAgentObject = getStorage(key: "mdmAgent") as? [String: AnyObject] {
            UIApplication.shared.keyWindow?.rootViewController = UINavigationController(rootViewController: MainController(mdmAgent: mdmAgentObject))
        }
    }
}
