/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * EnrollFormController.swift is part of flyve-mdm-ios
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
 * @date      09/08/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-agent
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit

/// EnrollFormController allow get user information for enrollment process
class EnrollFormController: FormViewController {
    
    // MARK: Properties
    
    /// user information storage
    var userInfo = [String: AnyObject]()
    
    // MARK: Init
    
    /// Load the customized view that the controller manages
    override func loadView() {
        super.loadView()
        
        setupViews()
        loadForm()
    }
    
    /// Setup initial configuration view
    func setupViews() {
        
        form.title = NSLocalizedString("enrollment", comment: "")
        self.view.backgroundColor = .white

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("done", comment: ""),
                                                                 style: UIBarButtonItemStyle.plain,
                                                                 target: self,
                                                                 action: #selector(self.done))
    }
    
    /// Load Form information
    func loadForm() {
        // Section info user
        let sectionInfo = FormSection(headerTitle: nil, footerTitle: nil)
        sectionInfo.headerViewHeight = CGFloat.leastNormalMagnitude
        sectionInfo.footerViewHeight = CGFloat.leastNormalMagnitude
        
        let rowInfo = FormRow(tag: "info", type: .info, edit: .none, title: NSLocalizedString("info", comment: ""))
        let info = ["firstname": "", "lastname": ""]
        rowInfo.value = info as AnyObject
        sectionInfo.rows.append(rowInfo)
        
        // Section phone number
        let sectionTitlePhone = FormSection(headerTitle: nil, footerTitle: nil)
        sectionTitlePhone.headerViewHeight = CGFloat.leastNormalMagnitude
        sectionTitlePhone.footerViewHeight = CGFloat.leastNormalMagnitude
        
        let rowTitlePhone = FormRow(tag: "titlePhone", type: .title, edit: .insert, title: NSLocalizedString("add_phone", comment: ""))
        rowTitlePhone.configuration.button.didSelectClosure = { _ in
            self.addPhone()
        }
        
        sectionTitlePhone.rows.append(rowTitlePhone)
        
        let sectionPhone = FormSection(headerTitle: nil, footerTitle: nil)
        sectionPhone.headerViewHeight = 32.0
        sectionPhone.footerViewHeight = CGFloat.leastNormalMagnitude
        
        // Section email address
        let sectionTitleEmail = FormSection(headerTitle: nil, footerTitle: nil)
        sectionTitleEmail.headerViewHeight = CGFloat.leastNormalMagnitude
        sectionTitleEmail.footerViewHeight = CGFloat.leastNormalMagnitude
        
        let rowTitleEmail = FormRow(tag: "titleEmail", type: .title, edit: .insert, title: NSLocalizedString("add_email", comment: ""))
        rowTitleEmail.configuration.button.didSelectClosure = { _ in
            self.addEmail()
        }
        
        sectionTitleEmail.rows.append(rowTitleEmail)
        
        let sectionEmail = FormSection(headerTitle: nil, footerTitle: nil)
        sectionEmail.headerViewHeight = 32.0
        sectionEmail.footerViewHeight = CGFloat.leastNormalMagnitude
        
        // Section Language
        let sectionLanguage = FormSection(headerTitle: nil, footerTitle: nil)
        sectionLanguage.headerViewHeight = 32.0
        sectionLanguage.footerViewHeight = CGFloat.leastNormalMagnitude
        
        let rowLanguage = FormRow(tag: "language", type: .multipleSelector, edit: .none, title: NSLocalizedString("language", comment: ""))
        if let firstLanguage = LANGUAGES.first {
            rowLanguage.option = firstLanguage as AnyObject
        }
        rowLanguage.configuration.selection.options = (LANGUAGES as [String]) as [AnyObject]
        rowLanguage.configuration.selection.allowsMultipleSelection = false
        rowLanguage.configuration.selection.optionTitleClosure = { value in
            guard let option = value as? String else { return "" }
            return option
        }
        
        sectionLanguage.rows.append(rowLanguage)
        
        // Add sections to form
        form.sections = [sectionInfo,
                         sectionPhone,
                         sectionTitlePhone,
                         sectionEmail,
                         sectionTitleEmail,
                         sectionLanguage]
    }
    
    // MARK: Methods
    
    /// Add new phone number to form
    func addPhone() {
        if form.sections[1].rows.count < 1 {
            let rowPhone = FormRow(tag: "phone", type: .phone, edit: .delete, title: NSLocalizedString("phone", comment: ""))
            rowPhone.configuration.cell.placeholder = NSLocalizedString("phone", comment: "")
            rowPhone.option = PHONES.first as AnyObject
            rowPhone.configuration.selection.options = (PHONES as [String]) as [AnyObject]
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
    
    /// Add new email number to form
    func addEmail() {
        if form.sections[3].rows.count < 1 {
            let rowEmail = FormRow(tag: "email", type: .email, edit: .delete, title: NSLocalizedString("email", comment: ""))
            rowEmail.configuration.cell.placeholder = NSLocalizedString("email", comment: "")
            rowEmail.configuration.cell.placeholder = NSLocalizedString("email", comment: "")
            rowEmail.option = EMAILS.first as AnyObject
            rowEmail.configuration.selection.options = (EMAILS as [String]) as [AnyObject]
            rowEmail.configuration.selection.allowsMultipleSelection = false
            rowEmail.configuration.selection.optionTitleClosure = { value in
                guard let option = value as? String else { return "" }
                return option
            }
            
            form.sections[3].rows.append(rowEmail)
            
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath(row: form.sections[3].rows.count - 1, section: 3)], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    /// Validate user information for after save it
    func done() {
        dismissKeyboard()
        
        // get main user information
        if form.sections[0].rows.count > 0 {
            
            if let info = form.sections[0].rows[0].value {
                
                if let first = info["firstname"] as? String {
                    userInfo["firstname"] = first as AnyObject
                }
                
                if let last = info["lastname"] as? String {
                    userInfo["lastname"] = last as AnyObject
                }
            }
        }
        
        // get phone numbers
        var arrPhone = [AnyObject]()
        
        for phone in form.sections[1].rows where phone.value != nil {
            var modelPhone = [String: String]()
            
            modelPhone["type"] = phone.option as? String ?? ""
            modelPhone["phone"] = phone.value as? String ?? ""
            arrPhone.append(modelPhone as AnyObject)
        }
        
        if arrPhone.count > 0 {
            userInfo["phones"] = arrPhone as AnyObject
        } else {
            return
        }

        // get email address
        var arrEmail = [AnyObject]()
        
        for email in form.sections[3].rows where email.value != nil {
            var modelEmail = [String: String]()
            
            modelEmail["type"] = email.option as? String ?? ""
            modelEmail["email"] = email.value as? String ?? ""
            arrEmail.append(modelEmail as AnyObject)
        }
        
        if arrEmail.count > 0 {
            userInfo["emails"] = arrEmail as AnyObject
        } else {
            return
        }
        
        // get selected language
        if form.sections[5].rows.count > 0 {
            
            if let language: AnyObject = form.sections[5].rows[0].option {
                
                userInfo["language"] = form.sections[5].rows[0].configuration.selection.optionTitleClosure?(language as AnyObject) as AnyObject
            }
        }
        
        // notify user modification to setDataEnroll
        let notificationData = NotificationCenter.default
        notificationData.post(name: NSNotification.Name(rawValue: "setDataEnroll"), object: nil, userInfo: userInfo)
        
        dismiss(animated: true, completion: nil)
    }
    
    /// dismiss Keyboard when it's visible
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
