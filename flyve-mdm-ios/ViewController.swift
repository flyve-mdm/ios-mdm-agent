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
    
    var userToken: String?
    var invitationToken: String?
    
    init(userToken: String, invitationToken: String) {
        self.userToken = userToken
        self.invitationToken = invitationToken
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        if let _userToken = self.userToken {
            
            self.httpRequest = HttpRequest()
            self.httpRequest?.requestInitSession(userToken: _userToken)
            self.httpRequest?.delegate = self
        }
        
        
    }
}

extension ViewController: HttpRequestDelegate {
    
    func responseInitSession(data: [String: AnyObject]) {
        
        if let session_token = data["session_token"] as? String {
            
            sessionToken = session_token
            
            self.httpRequest?.requestGetFullSession()
        }
    }
    
    func errorInitSession(error: [String: AnyObject]) {
        
        print(error["message"] as? String ?? "")
    }
    
    func responseGetFullSession(data: [String: AnyObject]) {
        
        if let profiles_id = (data["session"]?["glpiactiveprofile"] as? [String: AnyObject])?["id"] as? Int, let guest_profiles_id = data["session"]?["plugin_flyvemdm_guest_profiles_id"] as? Int {
            
            if profiles_id == guest_profiles_id {
                
                self.httpRequest?.requestChangeActiveProfile(profilesID: "\(profiles_id)")
            }
        }
    }
    
    func errorGetFullSession(error: [String: AnyObject]) {
        
        print(error["message"] as? String ?? "")
    }
    
    func responseChangeActiveProfile() {
        
        var jsonDictionary = [String: AnyObject]()
        var inputDictionary = [String: String]()
        
        inputDictionary["_email"] = "hector@apps42.mobi"
        inputDictionary["_invitation_token"] = self.invitationToken
        inputDictionary["_serial"] = "0123456ATDJ-045"
        inputDictionary["csr"] = ""
        inputDictionary["firstname"] = "Hector"
        inputDictionary["lastname"] = "Rondon"
        inputDictionary["version"] = "0.99.0"
        
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
        }
    }
    
    func errorChangeActiveProfile(error: [String: AnyObject]) {
        
        print(error["message"] as? String ?? "")
    }
    
    func responsePluginFlyvemdmAgent(data: [String: AnyObject]) {
        
        if let id = data["id"] as? Int {
            
            self.httpRequest?.requestGetPluginFlyvemdmAgent(agentID: "\(id)")
        }

    }
    
    func errorPluginFlyvemdmAgent(error: [String: AnyObject]) {
        
        print(error["message"] as? String ?? "")
        
        if let msg = error["message"] as? String {
            
            if msg == "[\"ERROR_GLPI_ADD\",\"Invitation is not pending\"]" {
                
                self.httpRequest?.requestGetPluginFlyvemdmAgent(agentID: "38")
            }
        }

    }
    
    func responseGetPluginFlyvemdmAgent(data: [String: AnyObject]) {

        self.connectServer()
    }
    
    func errorGetPluginFlyvemdmAgent(error: [String: AnyObject]) {
        
        print(error["message"] as? String ?? "")
    }
}

extension ViewController: CocoaMQTTDelegate {
    
    func connectServer() {
        
        self.mqttSetting(host: "demo.flyve.org", port: 1883, username: "rafa", password: "azlknvjkfbsdklfdsgfd")
        
        self.mqtt!.connect()
    }
    
    func mqttSetting(host: String, port: UInt16, username: String, password: String) {
        
        let clientID = String(ProcessInfo().processIdentifier)
        mqtt = CocoaMQTT(clientID: clientID, host: "demo.flyve.org", port: 1883)
        mqtt!.username = "rafa"
        mqtt!.password = "azlknvjkfbsdklfdsgfd"
        mqtt!.willMessage = CocoaMQTTWill(topic: "/offline", message: "offline")
        mqtt!.keepAlive = 60
        mqtt!.delegate = self
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnect host: String, port: Int) {
        print("didConnect \(host):\(port)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("didConnectAck: \(ack)，rawValue: \(ack.rawValue)")
        
        if ack == .accept {
            mqtt.subscribe("/test", qos: CocoaMQTTQOS.qos0)
            
//            let chatViewController = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController
//            chatViewController?.mqtt = mqtt
//            navigationController!.pushViewController(chatViewController!, animated: true)
        }
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didPublishMessage with message: \(String(describing: message.string!))")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("didPublishAck with id: \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        print("didReceivedMessage: \(String(describing: message.string)) with id \(id)")
        
//        let name = NSNotification.Name(rawValue: "MQTTMessageNotification" + animal!)
//        NotificationCenter.default.post(name: name, object: self, userInfo: ["message": message.string!, "topic": message.topic])
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
