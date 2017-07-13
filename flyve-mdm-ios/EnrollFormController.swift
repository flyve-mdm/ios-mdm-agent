/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * RegisterFormController.swift is part of flyve-mdm-ios
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
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios
 * @link      https://.flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit

class EnrollFormController: UIViewController {
    
    var userInfo = ["firstName": "","lastName": "", "phone": "", "email": ""]
    
    let cellIdMain = "cellIdMain"
    
    var countPhone = 0
    var countEmail = 0
    
    override func loadView() {
        super.loadView()
        
        self.setupViews()
        self.addConstraints()
    }
    
    func setupViews() {
        
        self.view.backgroundColor = .white
        
        self.navigationController?.isNavigationBarHidden = false
        
        
        let saveButton = UIBarButtonItem(title: "Done",
                                         style: UIBarButtonItemStyle.plain,
                                         target: self,
                                         action: #selector(self.done))
        
        self.navigationItem.title = "Enrollment"
        self.navigationItem.rightBarButtonItem = saveButton

        self.view.addSubview(self.enrollTableView)
        
    }
    
    func addConstraints() {
        
        self.enrollTableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.enrollTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.enrollTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.enrollTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }
    
    lazy var enrollTableView: UITableView = {
        
        let table = UITableView(frame: .zero, style: .plain)
        
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.tableFooterView = UIView()
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 100
        table.isEditing = true
        table.allowsSelectionDuringEditing = true
        table.isScrollEnabled = false
        
        table.register(MainInfoCell.self, forCellReuseIdentifier: self.cellIdMain)
        
        return table
        
    }()
    
    lazy var enrollButton: UIButton = {
        
        let button = UIButton(type: .custom)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.backgroundColor = UIColor.init(red: 64.0/255.0, green: 186.0/255.0, blue: 179.0/255.0, alpha: 1.0).cgColor
        button.setTitle("Enroll", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(self.enroll), for: .touchUpInside)
        return button
    }()
    
    func enroll() {
        
        guard let email = self.userInfo["email"], let phone = self.userInfo["phone"], let first = self.userInfo["firstName"], let last = self.userInfo["lastName"], !email.isEmpty, !phone.isEmpty, !first.isEmpty, !last.isEmpty else {
            return
        }
        
        let dataUser: [String: String] = ["_email": email, "firstname": first, "lastname": last]
        
        let notificationData = NotificationCenter.default
        
        notificationData.post(name: NSNotification.Name(rawValue: "setDataEnroll"), object: nil, userInfo: dataUser)
        
        self.dismiss(animated: true, completion: nil)
    
    }
    
    func done() {
        
        self.enroll()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension EnrollFormController: UITableViewDelegate {
    
}

extension EnrollFormController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdMain, for: indexPath) as! MainInfoCell
        cell.firstNameTextField.tag = 0
        cell.lastNameTextField.tag = 1
        return cell
        
    }
}

class MainInfoCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.contentView.backgroundColor = .clear
        self.setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func setupView() {
        
        backgroundColor = .white
        
        contentView.addSubview(self.photoBotton)
        contentView.addSubview(self.firstNameTextField)
        contentView.addSubview(self.lastNameTextField)
        
        addConstraints()
    }
    
    func addConstraints() {
        
        self.photoBotton.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        self.photoBotton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        self.photoBotton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16).isActive = true
        self.photoBotton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -48).isActive = true
        self.photoBotton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8).isActive = true
        
        self.firstNameTextField.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4).isActive = true
        self.firstNameTextField.bottomAnchor.constraint(equalTo: self.photoBotton.centerYAnchor, constant: -4).isActive = true
        self.firstNameTextField.leadingAnchor.constraint(equalTo: self.photoBotton.trailingAnchor, constant: 8).isActive = true
        self.firstNameTextField.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        
        self.lastNameTextField.topAnchor.constraint(equalTo: self.photoBotton.centerYAnchor, constant: 4).isActive = true
        self.lastNameTextField.leadingAnchor.constraint(equalTo: self.photoBotton.trailingAnchor, constant: 8).isActive = true
        self.lastNameTextField.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.lastNameTextField.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -36).isActive = true
    }
    
    lazy var photoBotton: UIButton = {
        
        let button = UIButton(type: UIButtonType.custom)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 30
        button.backgroundColor = UIColor.background
        button.addTarget(self, action: #selector(self.selectPhoto), for: .touchUpInside)
        
        return button
    }()
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.autoresizingMask = [.flexibleWidth,
                                      .flexibleHeight]
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let firstNameTextField: UITextField = {
        let text = UITextField()
        
        text.translatesAutoresizingMaskIntoConstraints = false
        text.placeholder = "First name"
        text.clearButtonMode = UITextFieldViewMode.whileEditing
        text.textColor = .gray
        text.keyboardType = .default
        
        text.borderStyle = .none
        text.layer.backgroundColor = UIColor.white.cgColor
        
        text.layer.masksToBounds = false
        text.layer.shadowColor = UIColor.lightGray.cgColor
        text.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        text.layer.shadowOpacity = 1.0
        text.layer.shadowRadius = 0.0
        
        return text
    }()
    
    let lastNameTextField: UITextField = {
        let text = UITextField()
        
        text.translatesAutoresizingMaskIntoConstraints = false
        text.placeholder = "Last name"
        text.clearButtonMode = UITextFieldViewMode.whileEditing
        text.textColor = .gray
        text.keyboardType = .default
        
        text.borderStyle = .none
        text.layer.backgroundColor = UIColor.white.cgColor
        
        text.layer.masksToBounds = false
        text.layer.shadowColor = UIColor.lightGray.cgColor
        text.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        text.layer.shadowOpacity = 1.0
        text.layer.shadowRadius = 0.0
        
        return text
    }()
    
    func selectPhoto() {
        
    }
}
