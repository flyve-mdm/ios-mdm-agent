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
    
    override func loadView() {
        super.loadView()
        
        self.setupViews()
        self.addConstraints()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func setupViews() {
        
        self.view.backgroundColor = .background

        self.navigationController?.isNavigationBarHidden = false
        
        let saveButton = UIBarButtonItem(title: "Done",
                                         style: UIBarButtonItemStyle.plain,
                                         target: self,
                                         action: #selector(self.enroll))

        self.navigationItem.rightBarButtonItem = saveButton
        self.view.addSubview(self.emailTextField)
        self.view.addSubview(self.firstNameTextField)
        self.view.addSubview(self.lastNameTextField)
        self.view.addSubview(self.enrollButton)
        
    }
    
    func addConstraints() {
        
        self.emailTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 64).isActive = true
        self.emailTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24).isActive = true
        self.emailTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true
        
        self.firstNameTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 8).isActive = true
        self.firstNameTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24).isActive = true
        self.firstNameTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true
        
        self.lastNameTextField.topAnchor.constraint(equalTo: self.firstNameTextField.bottomAnchor, constant: 8).isActive = true
        self.lastNameTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24).isActive = true
        self.lastNameTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true
        
        self.enrollButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24).isActive = true
        self.enrollButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24).isActive = true
        self.enrollButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true
        
        self.enrollButton.heightAnchor.constraint(equalToConstant: 50)
    }
    
    let emailTextField: UITextField = {
        
        let text = UITextField()
        
        text.translatesAutoresizingMaskIntoConstraints = false
        text.placeholder = "Email"
        text.textColor = .gray
        text.borderStyle = .roundedRect
        text.keyboardType = .emailAddress
        
        return text
    }()
    
    let firstNameTextField: UITextField = {
        
        let text = UITextField()
        
        text.translatesAutoresizingMaskIntoConstraints = false
        text.placeholder = "First name"
        text.textColor = .gray
        text.borderStyle = .roundedRect
        text.keyboardType = .default
        
        return text
    }()
    
    let lastNameTextField: UITextField = {
        
        let text = UITextField()
        
        text.translatesAutoresizingMaskIntoConstraints = false
        text.placeholder = "Last name"
        text.textColor = .gray
        text.borderStyle = .roundedRect
        text.keyboardType = .default
        
        return text
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
        
        guard let email = self.emailTextField.text, let first = self.firstNameTextField.text, let last = self.lastNameTextField.text, !email.isEmpty, !first.isEmpty, !last.isEmpty else {
            return
        }
        
        let dataUser: [String: String] = ["_email": email, "firstname": first, "lastname": last]
        
        let notificationData = NotificationCenter.default
        
        notificationData.post(name: NSNotification.Name(rawValue: "setDataEnroll"), object: nil, userInfo: dataUser)
        
        self.dismiss(animated: true, completion: nil)
    
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
