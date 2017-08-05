/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * UserFormController.swift is part of flyve-mdm-ios
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
 * @date      03/08/17
 * @copyright   Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit

class UserFormController: FormViewController {
    
    var userInfo: [String: String]?
    var edit: Bool?
    
    init(style: UITableViewStyle, userInfo: [String: String], edit: Bool) {
        self.userInfo = userInfo
        self.edit = edit
        super.init(style: style)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        
        setupViews()
        loadForm()
    }
    
    func setupViews() {
        
        form.title = "User information"
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel".localized,
                                                                style: UIBarButtonItemStyle.plain,
                                                                target: self,
                                                                action: #selector(self.cancel))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "done".localized,
                                         style: UIBarButtonItemStyle.plain,
                                         target: self,
                                         action: #selector(self.done))
    }
    
    func loadForm() {
        // Section info user
        let sectionInfo = FormSection(headerTitle: nil, footerTitle: nil)
        sectionInfo.headerViewHeight = CGFloat.leastNormalMagnitude
        sectionInfo.footerViewHeight = CGFloat.leastNormalMagnitude

        let rowInfo = FormRow(tag: "info", type: .info, edit: .none, title: "info".localized)
        let info = ["firstname": userInfo?["firstname"] ?? "", "lastname": userInfo?["lastname"] ?? ""]
        rowInfo.value = info as AnyObject
        sectionInfo.rows.append(rowInfo)
        
        // Section phone number
        let sectionTitlePhone = FormSection(headerTitle: nil, footerTitle: nil)
        sectionTitlePhone.headerViewHeight = CGFloat.leastNormalMagnitude
        sectionTitlePhone.footerViewHeight = CGFloat.leastNormalMagnitude

        let rowTitlePhone = FormRow(tag: "titlePhone", type: .title, edit: .insert, title: "add_phone".localized)
        rowTitlePhone.configuration.button.didSelectClosure = { _ in
            self.addPhone()
        }
        
        sectionTitlePhone.rows.append(rowTitlePhone)
        
        let sectionPhone = FormSection(headerTitle: nil, footerTitle: nil)
        sectionPhone.headerViewHeight = 32.0
        sectionPhone.footerViewHeight = CGFloat.leastNormalMagnitude
        
        if let phone: String = userInfo?["phone"] {
            let rowPhone = FormRow(tag: "phone", type: .phone, edit: .delete, title: "phone".localized)
            rowPhone.configuration.cell.placeholder = "phone".localized
            rowPhone.value = phone as AnyObject
            rowPhone.option = 3 as AnyObject
            rowPhone.configuration.selection.options = ([0, 1, 2, 3, 4, 5, 6, 7, 8, 9] as [Int]) as [AnyObject]
            rowPhone.configuration.selection.allowsMultipleSelection = false
            rowPhone.configuration.selection.optionTitleClosure = { value in
                guard let option = value as? Int else { return "" }
                switch option {
                case 0:
                    return "mobile"
                case 1:
                    return "iPhone"
                case 2:
                    return "home"
                case 3:
                    return "work"
                case 4:
                    return "main"
                case 5:
                    return "home fax"
                case 6:
                    return "work fax"
                case 7:
                    return "other fax"
                case 8:
                    return "pager"
                case 9:
                    return "other"
                default:
                    return ""
                }
            }

            sectionPhone.rows.append(rowPhone)
        }
        
        // Section email address
        let sectionTitleEmail = FormSection(headerTitle: nil, footerTitle: nil)
        sectionTitleEmail.headerViewHeight = CGFloat.leastNormalMagnitude
        sectionTitleEmail.footerViewHeight = CGFloat.leastNormalMagnitude
        
        let rowTitleEmail = FormRow(tag: "titleEmail", type: .title, edit: .insert, title: "add_email".localized)
        rowTitleEmail.configuration.button.didSelectClosure = { _ in
            self.addEmail()
        }
  
        sectionTitleEmail.rows.append(rowTitleEmail)
        
        let sectionEmail = FormSection(headerTitle: nil, footerTitle: nil)
        sectionEmail.headerViewHeight = 32.0
        sectionEmail.footerViewHeight = CGFloat.leastNormalMagnitude
        
        if let email: String = userInfo?["_email"] {
            let rowEmail = FormRow(tag: "email", type: .phone, edit: .delete, title: "email".localized)
            rowEmail.configuration.cell.placeholder = "email".localized
            rowEmail.value = email as AnyObject
            
            sectionEmail.rows.append(rowEmail)
        }
        
        // Add sections to form
        form.sections = [sectionInfo, sectionPhone, sectionTitlePhone, sectionEmail, sectionTitleEmail]
    }

    func addPhone() {
        
        if form.sections[1].rows.count < 1 {
            let rowPhone = FormRow(tag: "phone", type: .phone, edit: .delete, title: "phone".localized)
            rowPhone.configuration.cell.placeholder = "phone".localized
            form.sections[1].rows.append(rowPhone)
            
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath(row: form.sections[1].rows.count - 1, section: 1)], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    func addEmail() {
        
        if form.sections[3].rows.count < 1 {
            let rowEmail = FormRow(tag: "email", type: .email, edit: .delete, title: "email".localized)
            rowEmail.configuration.cell.placeholder = "email".localized
            form.sections[3].rows.append(rowEmail)
            
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath(row: form.sections[3].rows.count - 1, section: 3)], with: .automatic)
            tableView.endUpdates()
        }
        
    }
    
    func done() {
        dismissKeyboard()
        
        if form.sections[0].rows.count > 0 {
            
            if let info = form.sections[0].rows[0].value {
                
                if let first = info["firstname"] as? String {
                    userInfo?["firstname"] = first
                }
                
                if let last = info["lastname"] as? String {
                    userInfo?["lastname"] = last
                }
            }
        }
        
        if form.sections[1].rows.count > 0 {
            
            if let phone: String = form.sections[1].rows[0].value as? String {
                userInfo?["phone"] = phone
            }
        }
        
        if form.sections[3].rows.count > 0 {
            
            if let email: String = form.sections[3].rows[0].value as? String {
                userInfo?["_email"] = email
            }
        }
        
        setStorage(value: self.userInfo! as AnyObject, key: "dataUser")
        dismiss(animated: true, completion: nil)
    }
    
    func cancel() {
        dismissKeyboard()
        dismiss(animated: true, completion: nil)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
