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
        rowInfo.configuration.cell.appearance = ["firstNameTextField.text": (userInfo?["firstname"] ?? "") as AnyObject,
                                                 "lastNameTextField.text": (userInfo?["lastname"] ?? "") as AnyObject]
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
        sectionPhone.headerViewHeight = 16.0
        sectionPhone.footerViewHeight = CGFloat.leastNormalMagnitude
        
        if let phone: String = userInfo?["phone"] {
            let rowPhone = FormRow(tag: "phone", type: .phone, edit: .delete, title: "phone".localized)
            rowPhone.configuration.cell.placeholder = "phone".localized
            rowPhone.configuration.cell.appearance = ["textField.placeholder": "phone".localized as AnyObject,
                                                     "textField.text": phone as AnyObject]
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
        sectionEmail.headerViewHeight = 16.0
        sectionEmail.footerViewHeight = CGFloat.leastNormalMagnitude
        
        if let email: String = userInfo?["_email"] {
            let rowEmail = FormRow(tag: "email", type: .phone, edit: .delete, title: "email".localized)
            rowEmail.configuration.cell.placeholder = "phone".localized
            rowEmail.configuration.cell.appearance = ["textField.placeholder": "email".localized as AnyObject,
                                                     "textField.text": email as AnyObject]
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
    
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
}
