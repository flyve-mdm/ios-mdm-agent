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
     * @copyright   Copyright © 2017 Teclib. All rights reserved.
     * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
     * @link      https://github.com/flyve-mdm/flyve-mdm-ios
     * @link      http://www.glpi-project.org/
     * ------------------------------------------------------------------------------
     */
    
    import Foundation
    import UIKit
    import CocoaMQTT
    
    class ViewController: UIViewController {
        
        var mqtt: CocoaMQTT?
        var httpRequest: HttpRequest?
        
        var mdmAgent = [String: Any]()
        var userToken: String?
        var invitationToken: String?
        var topic:String?
        
        init(userToken: String, invitationToken: String?) {
            self.userToken = userToken
            self.invitationToken = invitationToken
            
            super.init(nibName: nil, bundle: nil)
        }
        
        init(mdmAgent: [String: Any]) {
            
            self.mdmAgent = mdmAgent
            
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func loadView() {
            super.loadView()
            
            let notificationData = NotificationCenter.default
            notificationData.addObserver(self, selector: #selector(self.sendDataEnroll), name: NSNotification.Name(rawValue: "setDataEnroll"), object: nil)
            
            if let _userToken = self.userToken, !self.userToken!.isEmpty {
                
                self.setupViews()
                
                self.httpRequest = HttpRequest()
                self.httpRequest?.requestInitSession(userToken: _userToken)
                self.httpRequest?.delegate = self
                
                self.messageLabel.text = "Request init session..."
                self.loadingIndicatorView.startAnimating()
                
            } else {
                
                if self.mdmAgent.count > 0 {
                    
                    self.topic = self.mdmAgent["topic"] as? String ?? ""
                    
                    self.mqttSetting(host: "demo.flyve.org", port: 1883, username: "rafa", password: "azlknvjkfbsdklfdsgfd")
                    
                    self.mqtt!.connect()
                    
                }
                
                self.setupViewsEmpty()
            }
        }
        
        func setupViews() {
            
            self.view.backgroundColor = .white
            
            self.view.addSubview(self.messageLabel)
            self.view.addSubview(self.logoImageView)
            self.view.addSubview(self.loadingIndicatorView)
            
            self.addConstraints()
        }
        
        func addConstraints() {
            
            
            self.logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.logoImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            
            self.messageLabel.bottomAnchor.constraint(equalTo: self.logoImageView.topAnchor, constant: -16).isActive = true
            self.messageLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24).isActive = true
            self.messageLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true
            
            self.loadingIndicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.loadingIndicatorView.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 16).isActive = true
            
        }
        
        func setupViewsEmpty() {
            
            self.view.backgroundColor = .white
            
            self.messageLabel.text = "FLYVE MDM\n\nOPEN SOURCE\nMOBILE DEVICE MANAGEMENT SOLUTION\n\nFor more information visit\nhttps://flyve-mdm.com/"
            
            self.view.addSubview(self.messageLabel)
            self.view.addSubview(self.logoImageView)
            
            self.addConstraintsEmpty()
            
            
        }
        
        func addConstraintsEmpty() {
            
            self.logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.logoImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            
            self.messageLabel.bottomAnchor.constraint(equalTo: self.logoImageView.topAnchor, constant: -16).isActive = true
            self.messageLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24).isActive = true
            self.messageLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true
            
        }
        
        let logoImageView: UIImageView = {
            
            let imageView = UIImageView(image: UIImage(named: "icon"))
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            
            return imageView
        }()
        
        let messageLabel: UILabel = {
            
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
        
        let loadingIndicatorView: UIActivityIndicatorView = {
            
            let loading = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            
            loading.translatesAutoresizingMaskIntoConstraints = false
            loading.hidesWhenStopped = true
            
            return loading
        }()
    }
    
    extension ViewController: HttpRequestDelegate {
        
        func responseInitSession(data: [String: AnyObject]) {
            
            if let session_token = data["session_token"] as? String {
                
                sessionToken = session_token
                
                self.httpRequest?.requestGetFullSession()
                
                self.messageLabel.text = "Request full session..."
            }
        }
        
        func errorInitSession(error: [String: AnyObject]) {
            
            self.messageLabel.text = "Error: \(error["message"] as? String ?? "")"
            self.loadingIndicatorView.stopAnimating()
        }
        
        func responseGetFullSession(data: [String: AnyObject]) {
            
            print(data)
            
            if let profiles_id = (data["session"]?["glpiactiveprofile"] as? [String: AnyObject])?["id"] as? Int, let guest_profiles_id = data["session"]?["plugin_flyvemdm_guest_profiles_id"] as? Int {
                
                if profiles_id == guest_profiles_id {
                    
                    self.httpRequest?.requestChangeActiveProfile(profilesID: "\(profiles_id)")
                    
                    self.messageLabel.text = "Request change active profile..."
                } else {
                    self.messageLabel.text = "Error: The device needs to change its profile"
                }
            } else {
                
                self.messageLabel.text = "Error: The device needs to change its profile"
            }
        }
        
        func errorGetFullSession(error: [String: AnyObject]) {
            
            self.messageLabel.text = "Error: \(error["message"] as? String ?? "")"
            self.loadingIndicatorView.stopAnimating()
        }
        
        func responseChangeActiveProfile() {
            
            self.present(EnrollFormController(), animated: true, completion: nil)
        }
        
        func sendDataEnroll(notification:NSNotification) {
            
            var jsonDictionary = [String: AnyObject]()
            var inputDictionary = [String: String]()
            
            inputDictionary["_email"] = notification.userInfo?["_email"] as? String ?? ""
            inputDictionary["_invitation_token"] = self.invitationToken
            inputDictionary["_serial"] = String(ProcessInfo().processIdentifier)
            inputDictionary["csr"] = ""
            inputDictionary["firstname"] = notification.userInfo?["firstname"] as? String ?? ""
            inputDictionary["lastname"] = notification.userInfo?["lastname"] as? String ?? ""
            
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                inputDictionary["version"] = version
            }
            
            jsonDictionary["input"] = inputDictionary as AnyObject
            
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
                debugPrint(error.localizedDescription)
                self.loadingIndicatorView.stopAnimating()
            }
        }
        
        func errorChangeActiveProfile(error: [String: AnyObject]) {
            
            self.messageLabel.text = "Error: \(error["message"] as? String ?? "")"
            self.loadingIndicatorView.stopAnimating()
        }
        
        func responsePluginFlyvemdmAgent(data: [String: AnyObject]) {
            
            if let id = data["id"] as? Int {
                
                self.httpRequest?.requestGetPluginFlyvemdmAgent(agentID: "\(id)")
            }
        }
        
        func errorPluginFlyvemdmAgent(error: [String: AnyObject]) {
            
            self.messageLabel.text = "Error: \(error["message"] as? String ?? "")"
            
            self.loadingIndicatorView.stopAnimating()
        }
        
        func responseGetPluginFlyvemdmAgent(data: [String: AnyObject]) {
            
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: data)
            UserDefaults.standard.set(encodedData, forKey: "mdmAgent")
            
            var mdmAgentData = [String: AnyObject]()
            
            if let mdmAgentObject = UserDefaults.standard.object(forKey: "mdmAgent") {
                
                mdmAgentData = NSKeyedUnarchiver.unarchiveObject(with: mdmAgentObject as! Data) as! [String: AnyObject]
            }
            
            self.topic = mdmAgentData["topic"] as? String ?? ""
            
            self.connectServer(host: mdmAgentData["broker"] as? String ?? "", port: mdmAgentData["port"] as? UInt16 ?? 0)
        }
        
        func errorGetPluginFlyvemdmAgent(error: [String: AnyObject]) {
            
            self.messageLabel.text = "Error: \(error["message"] as? String ?? "")"
            self.loadingIndicatorView.stopAnimating()
        }
    }
    
    extension ViewController: CocoaMQTTDelegate {
        
        func connectServer(host: String, port: UInt16) {
            
            self.mqttSetting(host: host, port: port, username: "rafa", password: "azlknvjkfbsdklfdsgfd")
            
            self.mqtt!.connect()
        }
        
        func mqttSetting(host: String, port: UInt16, username: String, password: String) {
            
            let clientID = String(ProcessInfo().processIdentifier)
            mqtt = CocoaMQTT(clientID: clientID, host: host, port: port)
            mqtt!.username = username
            mqtt!.password = password
            mqtt!.willMessage = CocoaMQTTWill(topic: "/offline", message: "offline")
            mqtt!.keepAlive = 60
            mqtt!.delegate = self
        }
        
        func mqtt(_ mqtt: CocoaMQTT, didConnect host: String, port: Int) {
            print("didConnect \(host):\(port)")
            self.messageLabel.text = "Connect \(host):\(port)"
        }
        
        func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
            print("didConnectAck: \(ack)，rawValue: \(ack.rawValue)")
            
            if ack == .accept {
                mqtt.subscribe("\(self.topic!)/#", qos: CocoaMQTTQOS.qos0)
                self.messageLabel.text = "Subscribed to topic \(String(describing: self.topic))/#"
                self.loadingIndicatorView.stopAnimating()
                
                self.navigationController?.pushViewController(TopicLogController(), animated: true)
            }
        }
        
        func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
            print("didPublishMessage with message: \(String(describing: message.string!))")
        }
        
        func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
            print("didPublishAck with id: \(id)")
        }
        
        func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
            
            let name = NSNotification.Name(rawValue: "MQTTMessageNotification")
            NotificationCenter.default.post(name: name, object: self, userInfo: ["message": message.string!, "topic": message.topic])
            
            var messagePing: [String: String]? = [String: String]()
            
            if let data = message.string?.data(using: .utf8) {
                do {
                    messagePing = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
                    //(with: data, options: []) as? [String: Any])
                } catch {
                    print(error.localizedDescription)
                }
                
                if let messageQuery: String = messagePing?["query"] {
                    
                    if messageQuery == "Ping" {
                        
                        let strMessege = "\(self.topic!)/Status/Ping"
                        mqtt.publish(strMessege, withString: "!")
                    }
                }
            }
        }
        
        func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
            print("didSubscribeTopic to \(topic)")
        }
        
        func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
            print("didUnsubscribeTopic to \(topic)")
        }
        
        func mqttDidPing(_ mqtt: CocoaMQTT) {
            print("didPing")
        }
        
        func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
            print("didReceivePong")
        }
        
        func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
            print("mqttDidDisconnect")
        }
    }
