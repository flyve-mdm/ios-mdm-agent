/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * FormSelectorCell.swift is part of flyve-mdm-ios
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
 * @date      05/08/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit

class FormSelectorCell: FormBaseCell {
    
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        label.textColor = self.contentView.tintColor
        
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)
        label.textColor = .gray
        label.textAlignment = .right
        
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    override func configure() {
        super.configure()
        
        accessoryType = .disclosureIndicator
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        contentView.addSubview(separatorView)
        
        titleLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive =  true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive =  true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive =  true
        
        valueLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        valueLabel.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 16).isActive =  true
        valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive =  true
        valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive =  true
        valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive =  true
        
        separatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        separatorView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive =  true
        separatorView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive =  true
        separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive =  true
    }
    
    override func update() {
        super.update()
        
        titleLabel.text = row?.title
        
        var title: String?
        if let multipleValues = row?.value as? [AnyObject] {
            var multipleValuesTitle = ""
            for (index, selectedValue) in multipleValues.enumerated() {
                guard let selectedValueTitle = row?.configuration.selection.optionTitleClosure?(selectedValue) else { continue }
                if index != 0 {
                    multipleValuesTitle += ", "
                }
                multipleValuesTitle += selectedValueTitle
            }
            title = multipleValuesTitle
        } else if let singleValue = row?.option {
            title = row?.configuration.selection.optionTitleClosure?(singleValue)
        }
        
        if let title = title, title.characters.count > 0 {
            valueLabel.text = title
        } else {
            valueLabel.text = row?.configuration.cell.placeholder
        }
    }
    
    override class func formViewController(_ formViewController: FormViewController, didSelectRow selectedRow: FormBaseCell) {
        guard let row = selectedRow as? FormSelectorCell else { return }
        
        formViewController.view.endEditing(true)
        
        var selectorControllerClass: UIViewController.Type
        
        if let controllerClass = row.row?.configuration.selection.controllerClass as? UIViewController.Type {
            selectorControllerClass = controllerClass
        } else { // fallback to default cell class
            selectorControllerClass = FormOptionsSelectorController.self
        }
        
        let selectorController = selectorControllerClass.init()
        guard let formRowDescriptorViewController = selectorController as? FormSelector else { return }
        
        formRowDescriptorViewController.formCell = row
        formViewController.navigationController?.pushViewController(selectorController, animated: true)
    }
}
