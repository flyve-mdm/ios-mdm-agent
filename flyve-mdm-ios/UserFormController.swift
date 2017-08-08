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
    
    var userInfo: [String: AnyObject]?
    var edit: Bool?
    
    init(style: UITableViewStyle, userInfo: [String: AnyObject], edit: Bool) {
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
        
        form.title = "title_user".localized
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
        let info = ["firstname": userInfo?["firstname"] as? String ?? "", "lastname": userInfo?["lastname"] as? String ?? ""]
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
        
        if let phones: [AnyObject] = userInfo?["phone"] as? [AnyObject] {
            
            for phone in phones {
                
                let rowPhone = FormRow(tag: "phone", type: .phone, edit: .delete, title: "phone".localized)
                rowPhone.configuration.cell.placeholder = "phone".localized
                rowPhone.value = phone["phone"] as AnyObject
                rowPhone.option = phone["type"] as AnyObject
                rowPhone.configuration.selection.options = (arrPhones as [String]) as [AnyObject]
                rowPhone.configuration.selection.allowsMultipleSelection = false
                rowPhone.configuration.selection.optionTitleClosure = { value in
                    guard let option = value as? String else { return "" }
                    return option
                }
                
                sectionPhone.rows.append(rowPhone)
            }
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
        
        if let email: String = userInfo?["_email"] as? String {
            let rowEmail = FormRow(tag: "email", type: .phone, edit: .delete, title: "email".localized)
            rowEmail.configuration.cell.placeholder = "email".localized
            rowEmail.value = email as AnyObject
            rowEmail.option = 1 as AnyObject
            rowEmail.configuration.selection.options = ([0, 1, 2, 3] as [Int]) as [AnyObject]
            rowEmail.configuration.selection.allowsMultipleSelection = false
            rowEmail.configuration.selection.optionTitleClosure = { value in
                guard let option = value as? Int else { return "" }
                switch option {
                case 0:
                    return "home"
                case 1:
                    return "work"
                case 2:
                    return "iCloud"
                case 3:
                    return "other"
                default:
                    return ""
                }
            }
            
            sectionEmail.rows.append(rowEmail)
        }
        
        // Section Language
        let sectionLanguage = FormSection(headerTitle: nil, footerTitle: nil)
        sectionLanguage.headerViewHeight = 32.0
        sectionLanguage.footerViewHeight = CGFloat.leastNormalMagnitude
        
        let rowLanguage = FormRow(tag: "language", type: .multipleSelector, edit: .none, title: "language".localized)
        if let language: String = userInfo?["language"] as? String {
            rowLanguage.option = language as AnyObject
        }
        rowLanguage.configuration.selection.options = (["English", "French", "Spanish"] as [String]) as [AnyObject]
        rowLanguage.configuration.selection.allowsMultipleSelection = false
        rowLanguage.configuration.selection.optionTitleClosure = { value in
            guard let option = value as? String else { return "" }
            return option
        }
        
        sectionLanguage.rows.append(rowLanguage)
        
        // Section Password
        let sectionPassword = FormSection(headerTitle: nil, footerTitle: nil)
        sectionPassword.headerViewHeight = 32.0
        sectionPassword.footerViewHeight = CGFloat.leastNormalMagnitude
        
        let rowCurrentPassword = FormRow(tag: "current_password", type: .password, edit: .none, title: "current_password".localized)
        rowCurrentPassword.configuration.cell.placeholder = "current_password".localized
        
        sectionPassword.rows.append(rowCurrentPassword)
        
        let rowNewPassword = FormRow(tag: "new_password", type: .password, edit: .none, title: "new_password".localized)
        rowNewPassword.configuration.cell.placeholder = "new_password".localized
        
        sectionPassword.rows.append(rowNewPassword)
        
        let rowConfirmPassword = FormRow(tag: "confirm_password", type: .password, edit: .none, title: "confirm_password".localized)
        rowConfirmPassword.configuration.cell.placeholder = "confirm_password".localized
        
        sectionPassword.rows.append(rowConfirmPassword)
        
        // Section Administrative number
        let sectionAdminNumber = FormSection(headerTitle: nil, footerTitle: nil)
        sectionAdminNumber.headerViewHeight = 32.0
        sectionAdminNumber.footerViewHeight = CGFloat.leastNormalMagnitude
        
        let rowAdminNumber = FormRow(tag: "admin_number", type: .number, edit: .none, title: "admin_number".localized)
        rowAdminNumber.configuration.cell.placeholder = "admin_number".localized
        if let adminNumber: String = userInfo?["admin_number"] as? String {
            rowAdminNumber.value = adminNumber as AnyObject
        }
        sectionAdminNumber.rows.append(rowAdminNumber)
        
        // Add sections to form
        form.sections = [sectionInfo,
                         sectionPhone,
                         sectionTitlePhone,
                         sectionEmail,
                         sectionTitleEmail,
                         sectionLanguage,
                         sectionPassword,
                         sectionAdminNumber]
    }

    func addPhone() {
        
        if form.sections[1].rows.count < 3 {
            let rowPhone = FormRow(tag: "phone", type: .phone, edit: .delete, title: "phone".localized)
            rowPhone.configuration.cell.placeholder = "phone".localized
            rowPhone.option = arrPhones[0] as AnyObject
            rowPhone.configuration.selection.options = (arrPhones as [String]) as [AnyObject]
            rowPhone.configuration.selection.allowsMultipleSelection = false
            rowPhone.configuration.selection.optionTitleClosure = { value in
                guard let option = value as? String else { return "" }
                return option
            }
            
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
                    userInfo?["firstname"] = first as AnyObject
                }
                
                if let last = info["lastname"] as? String {
                    userInfo?["lastname"] = last as AnyObject
                }
            }
        }
        
        var arrPhone = [AnyObject]()
        
        for phone in form.sections[1].rows where phone.value != nil {
            var modelPhone = [String: String]()
            
            modelPhone["type"] = phone.option as? String ?? ""
            modelPhone["phone"] = phone.value as? String ?? ""
            arrPhone.append(modelPhone as AnyObject)
        }
        
        userInfo?["phone"] = arrPhone as AnyObject
        
        if form.sections[3].rows.count > 0 {
            
            if let email: String = form.sections[3].rows[0].value as? String {
                userInfo?["_email"] = email as AnyObject
            }
        }
        
        if form.sections[5].rows.count > 0 {
            
            if let language: AnyObject = form.sections[5].rows[0].option {

                userInfo?["language"] = form.sections[5].rows[0].configuration.selection.optionTitleClosure?(language as AnyObject) as AnyObject
            }
        }
        
        if form.sections[7].rows.count > 0 {
            
            if let adminNumber: String = form.sections[7].rows[0].value as? String {
                
                userInfo?["admin_number"] = adminNumber as AnyObject
            } else {
                userInfo?["admin_number"] = "" as AnyObject
            }
        }
        
        setStorage(value: self.userInfo! as AnyObject, key: "dataUser")
        
        let notificationData = NotificationCenter.default
        notificationData.post(name: NSNotification.Name(rawValue: "editUser"), object: nil, userInfo: nil)
        
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
