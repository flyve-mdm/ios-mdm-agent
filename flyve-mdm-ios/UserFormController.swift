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
    }
    
    func loadForm() {
        
        let sectionName = FormSection(headerTitle: nil, footerTitle: nil)
        let rowName = FormRow(tag: "info", type: .info, edit: .none, title: "info".localized)
        
        sectionName.rows.append(rowName)
        
        let sectionPhone = FormSection(headerTitle: nil, footerTitle: nil)
        
        let sectionTitlePhone = FormSection(headerTitle: nil, footerTitle: nil)
        let rowTitlePhone = FormRow(tag: "titlePhone", type: .title, edit: .insert, title: "add_phone".localized)
        rowTitlePhone.configuration.button.didSelectClosure = { _ in
            self.addPhone()
        }
        sectionTitlePhone.rows.append(rowTitlePhone)
        
        let sectionEmail = FormSection(headerTitle: nil, footerTitle: nil)
        
        let sectionTitleEmail = FormSection(headerTitle: nil, footerTitle: nil)
        let rowTitleEmail = FormRow(tag: "titleEmail", type: .title, edit: .insert, title: "add_email".localized)
        rowTitleEmail.configuration.button.didSelectClosure = { _ in
            self.addEmail()
        }
        sectionTitleEmail.rows.append(rowTitleEmail)
        
        form.sections = [sectionName, sectionPhone, sectionTitlePhone, sectionEmail, sectionTitleEmail]
    }

    func addPhone() {
        
        let rowPhone = FormRow(tag: "phone", type: .phone, edit: .delete, title: "phone".localized)
        rowPhone.configuration.cell.placeholder = "phone".localized
        form.sections[0].rows.append(rowPhone)
        
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: form.sections[0].rows.count - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    func addEmail() {
        
        let rowEmail = FormRow(tag: "email", type: .email, edit: .delete, title: "email".localized)
        rowEmail.configuration.cell.placeholder = "email".localized
        form.sections[2].rows.append(rowEmail)
        
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: form.sections[2].rows.count - 1, section: 2)], with: .automatic)
        tableView.endUpdates()
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
}
