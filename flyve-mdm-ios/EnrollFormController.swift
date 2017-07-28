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

    var userInfo = ["firstname": "", "lastname": "", "phone": "", "_email": ""]
    var edit = false
    let cellIdMain = "cellIdMain"
    let cellIdTitle = "cellIdTitle"
    let cellIdField = "cellIdField"

    var countPhone = 0
    var countEmail = 0

    override func loadView() {
        super.loadView()
        print(userInfo)
        print(edit)
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
        if edit {
            let cancelButton = UIBarButtonItem(title: "Cancel",
                                             style: UIBarButtonItemStyle.plain,
                                             target: self,
                                             action: #selector(self.cancel))
            
            self.navigationItem.leftBarButtonItem = cancelButton
            self.navigationItem.title = "Edit user"
            
            
        } else {
            self.navigationItem.title = "Enrollment"
        }
        
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
        table.register(TitleInfoCell.self, forCellReuseIdentifier: self.cellIdTitle)
        table.register(FieldInfoCell.self, forCellReuseIdentifier: self.cellIdField)

        return table
    }()

    lazy var enrollButton: UIButton = {

        let button = UIButton(type: .custom)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.backgroundColor = UIColor.init(red: 64.0/255.0, green: 186.0/255.0, blue: 179.0/255.0, alpha: 1.0).cgColor
        button.setTitle("enroll".localized, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(self.enroll), for: .touchUpInside)
        return button
    }()

    func enroll() {

        guard let email = self.userInfo["_email"], let phone = self.userInfo["phone"], let first = self.userInfo["firstname"], let last = self.userInfo["lastname"], !email.isEmpty, !phone.isEmpty, !first.isEmpty, !last.isEmpty else {
            return
        }
        
        if edit {
            setStorage(value: self.userInfo as AnyObject, key: "dataUser")
            let notificationData = NotificationCenter.default
            notificationData.post(name: NSNotification.Name(rawValue: "editUser"), object: nil, userInfo: nil)
        } else {
            
            let dataUser: [String: String] = ["_email": email, "phone": phone, "firstname": first, "lastname": last]
            let notificationData = NotificationCenter.default
            notificationData.post(name: NSNotification.Name(rawValue: "setDataEnroll"), object: nil, userInfo: dataUser)
        }

        self.dismiss(animated: true, completion: nil)
    }

    func done() {

        dismissKeyboard()

        let indexPathName: NSIndexPath = NSIndexPath(row: 0, section: 0)
        let indexPathPhone: NSIndexPath = NSIndexPath(row: 0, section: 1)
        let indexPathEmail: NSIndexPath = NSIndexPath(row: 0, section: 3)

        let cellName  = enrollTableView.cellForRow(at: indexPathName as IndexPath) as? MainInfoCell
        let cellPhone  = enrollTableView.cellForRow(at: indexPathPhone as IndexPath) as? FieldInfoCell
        let cellEmail  = enrollTableView.cellForRow(at: indexPathEmail as IndexPath) as? FieldInfoCell

        self.userInfo["firstname"] = cellName?.firstNameTextField.text
        self.userInfo["lastname"] = cellName?.lastNameTextField.text
        self.userInfo["phone"] = cellPhone?.textField.text ?? ""
        self.userInfo["_email"] = cellEmail?.textField.text ?? ""
        
        enroll()
    }
    
    func cancel() {
        dismissKeyboard()
        self.dismiss(animated: true, completion: nil)
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension EnrollFormController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 2 {

            if countPhone > 0 { return }

            countPhone += 1

            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath(row: countPhone-1, section: 1)], with: .automatic)
            tableView.endUpdates()

        } else if indexPath.section == 4 {

            if countEmail > 0 { return }

            countEmail += 1

            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath(row: countEmail-1, section: 3)], with: .automatic)
            tableView.endUpdates()
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section == 1 || indexPath.section == 3 {
            return .delete

        } else if indexPath.section == 2 || indexPath.section == 4 {
            return .insert

        } else {
            return .none
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            
            if !edit {

                if indexPath.section == 1 {
                    countPhone = 0
                } else if indexPath.section == 3 {
                    countEmail = 0
                }
            
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
        } else if editingStyle == .insert {

            if indexPath.section == 2 {

                if countPhone > 0 { return }

                countPhone += 1

                tableView.beginUpdates()
                tableView.insertRows(at: [IndexPath(row: countPhone-1, section: 1)], with: .automatic)
                tableView.endUpdates()

            } else if indexPath.section == 4 {

                if countEmail > 0 { return }

                countEmail += 1

                tableView.beginUpdates()
                tableView.insertRows(at: [IndexPath(row: countEmail-1, section: 3)], with: .automatic)
                tableView.endUpdates()
            }
        }
    }
}

extension EnrollFormController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return 1
        } else if section == 1 {
            return countPhone
        } else if section == 2 {
            return 1
        } else if section == 3 {
            return countEmail
        } else if section == 4 {
            return 1
        } else {
            return 0
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 && indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdMain, for: indexPath) as? MainInfoCell
            cell?.firstNameTextField.tag = 0
            
            if userInfo["firstname"] != "" {
                cell?.firstNameTextField.text = userInfo["firstname"]
            }

            cell?.lastNameTextField.tag = 1
            
            if userInfo["lastname"] != "" {
                cell?.lastNameTextField.text = userInfo["lastname"]
            }

            return cell!

        } else {

            if indexPath.section == 2 || indexPath.section == 4 {

                let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdTitle, for: indexPath) as? TitleInfoCell

                if indexPath.section == 2 {
                    cell?.titleLabel.text = "add_phone".localized

                } else {
                    cell?.titleLabel.text = "add_email".localized

                }

                return cell!

            } else {

                let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdField, for: indexPath) as? FieldInfoCell

                if indexPath.section == 1 {
                    cell?.textField.text = userInfo["phone"] ?? ""
                    cell?.textField.placeholder = "phone".localized
                    cell?.textField.tag = 2
                    cell?.textField.keyboardType = .phonePad

                } else {
                    if edit {
                        cell?.textField.isEnabled = false
                    }
                    cell?.textField.text = userInfo["_email"] ?? ""
                    cell?.textField.placeholder = "Email".localized
                    cell?.textField.tag = 3
                    cell?.textField.keyboardType = .emailAddress
                }

                return cell!
            }
        }
    }
}
