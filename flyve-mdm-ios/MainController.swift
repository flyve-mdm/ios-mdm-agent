/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * MainController.swift is part of flyve-mdm-ios
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
 * @date      13/07/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit
import CocoaMQTT
import CoreLocation

class MainController: UIViewController {
    
    var mqtt: CocoaMQTT?
    var userInfo = [String: String]()
    var mdmAgent = [String: Any]()
    var topic = ""
    let cellId = "cellId"
    var location:Location!
    
    init(mdmAgent: [String: Any]) {
        
        self.mdmAgent = mdmAgent
        
        if let topic = mdmAgent["topic"] as? String {
            self.topic = topic
        }
        
        if let dataUserObject = getStorage(key: "dataUser") as? [String: String] {
            userInfo = dataUserObject
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()

        setupViews()
        addConstraints()
        
        if let broker = mdmAgent["broker"] as? String,
            let port = mdmAgent["port"] as? UInt16,
            let user = userInfo["_serial"],
            let password = mdmAgent["mqttpasswd"] as? String,
            !broker.isEmpty, !user.isEmpty, !password.isEmpty {
            
            connectBroker(host: broker, port: port, user: user, password: password)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupViews() {
        
        view.backgroundColor = .background
        view.addSubview(statusView)
        statusView.addSubview(loadingIndicatorView)
        view.addSubview(logoImageView)
        view.addSubview(mainTableView)
    }
    
    func addConstraints() {
        
        statusView.topAnchor.constraint(equalTo: view.topAnchor, constant: 22.0).isActive = true
        statusView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -14.0).isActive = true
        statusView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        statusView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        loadingIndicatorView.centerXAnchor.constraint(equalTo: statusView.centerXAnchor).isActive = true
        loadingIndicatorView.centerYAnchor.constraint(equalTo: statusView.centerYAnchor).isActive = true
        loadingIndicatorView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        loadingIndicatorView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 72).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        mainTableView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48).isActive = true
        mainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mainTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    lazy var logoImageView: UIImageView = {
        
        let imageView = UIImageView(image: UIImage(named: "logo"))
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        
        let multiTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.showLog))
        multiTap.numberOfTapsRequired = 10
        imageView.addGestureRecognizer(multiTap)
        
        return imageView
    }()
    
    lazy var mainTableView: UITableView = {
        
        let table = UITableView(frame: .zero, style: .plain)
        
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.tableFooterView = UIView()
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 100
        
        table.register(MainCell.self, forCellReuseIdentifier: self.cellId)
        
        return table
        
    }()
    
    let loadingIndicatorView: UIActivityIndicatorView = {
        
        let loading = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.hidesWhenStopped = true
        
        return loading
    }()
    
    let statusView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5.0
        view.backgroundColor = .clear
        
        return view
        
    }()
    
    func showLog() {

    }
    
    func goLogController() {
        navigationController?.pushViewController(TopicLogController(), animated: true)
    }
    
    func goEnrollmentController() {
        UIApplication.shared.keyWindow?.rootViewController = UINavigationController(rootViewController: ViewController(userToken: "", invitationToken: ""))
    }
}

extension MainController: UITableViewDelegate {

}

extension MainController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! MainCell
        
        if indexPath.row == 0 {
            cell.titleLabel.text = "title_ supervised".localized.uppercased()
            
        } else if indexPath.row == 1 {
            cell.titleLabel.text = "title_user".localized.uppercased()
            cell.descriptionLabel.text = "\(userInfo["firstname"] ?? "") \(userInfo["lastname"] ?? "")"
            cell.detailLabel.text = "\(userInfo["_email"] ?? "Email")"
            
        } else if indexPath.row == 2 {
            cell.titleLabel.text = "title_resources".uppercased()
            
        } else if indexPath.row == 3 {
            cell.titleLabel.text = "log_report".localized.uppercased()
            cell.openBotton.addTarget(self, action: #selector(self.goLogController), for: .touchUpInside)
            
        }

        return cell
    }
}

extension MainController: CocoaMQTTDelegate {
    
    func connectBroker(host: String, port: UInt16, user: String, password: String) {
        
        self.mqttSetting(host: host, port: port, username: user, password: "\(password)")
        
        self.mqtt!.connect()
        
        loadingIndicatorView.startAnimating()
        statusView.backgroundColor = .clear
    }
    
    func mqttSetting(host: String, port: UInt16, username: String, password: String) {

        mqtt = CocoaMQTT(clientID: username, host: host, port: port)
        mqtt!.username = username
        mqtt!.password = password
        mqtt!.willMessage = CocoaMQTTWill(topic: "\(topic)/Status/Offline", message: "offline")
        mqtt!.keepAlive = 60
        mqtt!.delegate = self
        mqtt!.enableSSL = true

    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {

        completionHandler(true)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnect host: String, port: Int) {
        print("didConnect \(host):\(port)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("didConnectAck: \(ack)，rawValue: \(ack.rawValue)")
        
        if ack == .accept {
            
            mqtt.subscribe("\(topic)/#", qos: CocoaMQTTQOS.qos1)
            print("Subscribed to topic \(String(describing: topic))/#")
        }
        
        loadingIndicatorView.stopAnimating()
        
        if mqtt.connState == .connected {
            
            statusView.backgroundColor = .green
            
        } else {
            statusView.backgroundColor = .red
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
        
        var messageBroker: [String: String]? = [String: String]()
        
        if let data = message.string?.data(using: .utf8) {
            do {
                messageBroker = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
                //(with: data, options: []) as? [String: Any])
            } catch {
                print(error.localizedDescription)
            }
            print(messageBroker ?? "Empty")
            if let messageQuery: String = messageBroker?["query"] {
                if messageQuery == "Ping" {
                    replyPing()

                } else if messageQuery == "Geolocate" {
                    location = Location()
                    location.delegate = self
                    location.getCurrentLocation()
                }
            } else if let messageUnenroll: String = messageBroker?["unenroll"] {
                if messageUnenroll == "now" {
                    replyUnenroll()
                }
            }
        }
    }
    
    func replyPing() {
        let topicPing = "\(topic)/Status/Ping"
        mqtt?.publish(topicPing, withString: "!")
    }
    
    func replyUnenroll() {
        let topicUnenroll = "\(topic)/Status/Unenroll"
        let answer = "{\"unenroll\": \"unenrolled\"}"
        mqtt?.publish(topicUnenroll, withString: answer)
        mqtt?.disconnect()
        removeAllStorage()
        goEnrollmentController()
    }
    
    func replyGeolocate(latitude: Double, longitude: Double, datetime: Int) {
        let topicGeolocation = "\(topic)/Status/Geolocation"
        let answer = "{\"latitude\":\(latitude),\"longitude\":\(longitude),\"datetime\":\(datetime)}"
        mqtt?.publish(topicGeolocation, withString: answer)
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
        statusView.backgroundColor = .red
    }
}

extension MainController: LocationDelegate {
    
    func currentLocation(coordinate: CLLocationCoordinate2D) {
        
        let date = Date()
        let datetime = Int(date.timeIntervalSince1970/1000)
        
        replyGeolocate(latitude: coordinate.latitude, longitude: coordinate.longitude, datetime: datetime)
    }
}

class MainCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCellSelectionStyle.none
        backgroundColor = .clear
        setupView()
        addConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func setupView() {
        
        contentView.addSubview(lineView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(photoImageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(openBotton)
    }
    
    func addConstraints() {
        
        lineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        lineView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        lineView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        photoImageView.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        photoImageView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        photoImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: lineView.topAnchor, constant: -16).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32).isActive = true
        
        descriptionLabel.bottomAnchor.constraint(equalTo: photoImageView.centerYAnchor).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 16).isActive = true
        
        detailLabel.topAnchor.constraint(equalTo: photoImageView.centerYAnchor).isActive = true
        detailLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 16).isActive = true
        
        openBotton.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor).isActive = true
        openBotton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
    }
    
    let lineView: UIView = {
        
        let line = UIView()
        
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .gray
        
        return line
    }()
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.autoresizingMask = [.flexibleWidth,
                                      .flexibleHeight]
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0.5
        imageView.layer.cornerRadius = 10
        imageView.layer.borderColor = UIColor.gray.cgColor
        
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightRegular)
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightLight)
        
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightThin)
        
        return label
    }()
    
    lazy var openBotton: UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("open".localized.uppercased(), for: .normal)
        
        return button
    }()
}
