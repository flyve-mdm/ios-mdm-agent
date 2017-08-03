/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * UserInfoController.swift is part of flyve-mdm-ios
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
 * @date      02/08/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit

class FormViewController: UITableViewController {
    
    private static var __once: () = {
        FormViewController.defaultCellClasses[.title] = FormTitleCell.self
        FormViewController.defaultCellClasses[.info] = FormInfoCell.self
        FormViewController.defaultCellClasses[.phone] = FormTextFieldCell.self
        FormViewController.defaultCellClasses[.email] = FormTextFieldCell.self

        FormViewController.defaultCellClasses[.text] = FormTextFieldCell.self
        FormViewController.defaultCellClasses[.label] = FormTextFieldCell.self
        FormViewController.defaultCellClasses[.number] = FormTextFieldCell.self
        FormViewController.defaultCellClasses[.numbersAndPunctuation] = FormTextFieldCell.self
        FormViewController.defaultCellClasses[.decimal] = FormTextFieldCell.self
        FormViewController.defaultCellClasses[.url] = FormTextFieldCell.self
        FormViewController.defaultCellClasses[.twitter] = FormTextFieldCell.self
        FormViewController.defaultCellClasses[.namePhone] = FormTextFieldCell.self
        FormViewController.defaultCellClasses[.asciiCapable] = FormTextFieldCell.self
        FormViewController.defaultCellClasses[.password] = FormTextFieldCell.self
        FormViewController.defaultCellClasses[.button] = FormTextFieldCell.self
        FormViewController.defaultCellClasses[.booleanSwitch] = FormTextFieldCell.self
        FormViewController.defaultCellClasses[.booleanCheck] = FormTextFieldCell.self
        FormViewController.defaultCellClasses[.segmentedControl] = FormTextFieldCell.self
        FormViewController.defaultCellClasses[.picker] = FormTextFieldCell.self
        FormViewController.defaultCellClasses[.date] = FormTextFieldCell.self
        FormViewController.defaultCellClasses[.time] = FormTextFieldCell.self
        FormViewController.defaultCellClasses[.dateAndTime] = FormTextFieldCell.self
        FormViewController.defaultCellClasses[.stepper] = FormTextFieldCell.self
        FormViewController.defaultCellClasses[.slider] = FormTextFieldCell.self
        FormViewController.defaultCellClasses[.multipleSelector] = FormTextFieldCell.self
        FormViewController.defaultCellClasses[.multilineText] = FormTextFieldCell.self
    }()
    
    // MARK: Class variables
    
    fileprivate static var onceDefaultCellClass: Int = 0
    fileprivate static var defaultCellClasses: [FormRow.RowType : FormBaseCell.Type] = [:]
    
    // MARK: Properties
    
    var form = Form()
    
    // MARK: Init
    
    convenience init() {
        self.init(style: .grouped)
    }
    
    convenience init(form: Form) {
        self.init(style: .grouped)
        self.form = form
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = form.title
    }
    
    // MARK: Public interface
    
    func valueForTag(_ tag: String) -> AnyObject? {
        for section in form.sections {
            for row in section.rows {
                if row.tag == tag {
                    return row.value
                }
            }
        }
        return nil
    }
    
    func setValue(_ value: AnyObject, forTag tag: String) {
        for (sectionIndex, section) in form.sections.enumerated() {
            for (rowIndex, row) in section.rows.enumerated() {
                if row.tag == tag {
                    form.sections[sectionIndex].rows[rowIndex].value = value
                    if let cell = self.tableView.cellForRow(at: IndexPath(row: rowIndex, section: sectionIndex)) as? FormBaseCell {
                        cell.update()
                    }
                    return
                }
            }
        }
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return form.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return form.sections[section].rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = formRowDescriptorAtIndexPath(indexPath)
        
        let formBaseCellClass = formBaseCellClassFromRowDescriptor(row)
        
        let reuseIdentifier = NSStringFromClass(formBaseCellClass!)
        
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? FormBaseCell
        if cell == nil {
            cell = formBaseCellClass?.init(style: .default, reuseIdentifier: reuseIdentifier)
            cell?.formViewController = self
            cell?.configure()
        }
        
        cell?.row = row
        
        // apply cell custom design
        for (keyPath, value) in row.configuration.cell.appearance {
            cell?.setValue(value, forKeyPath: keyPath)
        }
        return cell!
    }
    
    open override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return form.sections[section].headerTitle
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return form.sections[section].footerTitle
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let headerView = form.sections[section].headerView else { return nil }
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let footerView = form.sections[section].footerView else { return nil }
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let headerView = form.sections[section].headerView, headerView.translatesAutoresizingMaskIntoConstraints else {
            return form.sections[section].headerViewHeight
        }
        return headerView.frame.size.height
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let footerView = form.sections[section].footerView, footerView.translatesAutoresizingMaskIntoConstraints else {
            return form.sections[section].footerViewHeight
        }
        return footerView.frame.size.height
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        let row = formRowDescriptorAtIndexPath(indexPath)
        return row.edit
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rowDescriptor = formRowDescriptorAtIndexPath(indexPath)
        
        if let selectedRow = tableView.cellForRow(at: indexPath) as? FormBaseCell {
            if let formBaseCellClass = formBaseCellClassFromRowDescriptor(rowDescriptor) {
                formBaseCellClass.formViewController(self, didSelectRow: selectedRow)
            }
        }
        
        if let didSelectClosure = rowDescriptor.configuration.button.didSelectClosure {
            didSelectClosure(rowDescriptor)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    fileprivate class func defaultCellClassForRowType(_ rowType: FormRow.RowType) -> FormBaseCell.Type {
        _ = FormViewController.__once
        return FormViewController.defaultCellClasses[rowType]!
    }
    
    fileprivate func formRowDescriptorAtIndexPath(_ indexPath: IndexPath) -> FormRow {
        
        let section = form.sections[(indexPath as NSIndexPath).section]
        let rowDescriptor = section.rows[(indexPath as NSIndexPath).row]
        return rowDescriptor
    }
    
    fileprivate func formBaseCellClassFromRowDescriptor(_ rowDescriptor: FormRow) -> FormBaseCell.Type! {
        
        var formBaseCellClass: FormBaseCell.Type
        
        if let cellClass = rowDescriptor.configuration.cell.cellClass as? FormBaseCell.Type {
            formBaseCellClass = cellClass
        } else {
            formBaseCellClass = FormViewController.defaultCellClassForRowType(rowDescriptor.type)
        }
        return formBaseCellClass
    }
}
