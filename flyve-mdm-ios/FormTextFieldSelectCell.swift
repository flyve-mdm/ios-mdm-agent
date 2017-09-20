/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * FormTextFieldSelectCell.swift is part of flyve-mdm-ios
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
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-agent
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit

/// FormTextFieldSelectCell class
class FormTextFieldSelectCell: FormBaseCell {
    
    // MARK: Properties
    /// `customConstraints`
    fileprivate var customConstraints: [AnyObject] = []
    
    // MARK: Cell views
    /// This property contains the configuration of the type button
    let typeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// This property contains the configuration of the vertical view
    let verticalView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    /// This property contains the configuration of the separator view
    let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    /// This property contains the configuration of the text field
    let textField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.clearButtonMode = UITextFieldViewMode.whileEditing
        text.textColor = .gray
        text.keyboardType = .default
        text.borderStyle = .none

        return text
    }()
    
    /// `setupViews()`
    func setupViews() {
        
        selectionStyle = .none

        contentView.addSubview(typeButton)
        contentView.addSubview(verticalView)
        contentView.addSubview(textField)
        contentView.addSubview(separatorView)
    }
    
    /// `addConstraints()`
    func addConstraints() {
        
        typeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        typeButton.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        typeButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive =  true
        typeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive =  true
        
        verticalView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        verticalView.widthAnchor.constraint(equalToConstant: 0.5).isActive = true
        verticalView.leftAnchor.constraint(equalTo: typeButton.rightAnchor, constant: 8.0).isActive = true
        
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textField.leftAnchor.constraint(equalTo: verticalView.rightAnchor, constant: 8).isActive =  true
        textField.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive =  true
        textField.topAnchor.constraint(equalTo: contentView.topAnchor).isActive =  true
        textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive =  true
        
        separatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        separatorView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: -24).isActive =  true
        separatorView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive =  true
        separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive =  true
    }
    
    /// `override configure()`
    override func configure() {
        super.configure()
        setupViews()
        addConstraints()
        
        textField.addTarget(self, action: #selector(FormTextFieldSelectCell.editingChanged(_:)), for: .editingChanged)
        typeButton.addTarget(self, action: #selector(showOptions(_:)), for: .touchUpInside)
    }
    
    /// `override update()`
    override func update() {
        super.update()
        
        if let showsInputToolbar = row?.configuration.cell.showsInputToolbar, showsInputToolbar && textField.inputAccessoryView == nil {
            textField.inputAccessoryView = inputAccesoryView()
        }
        
        if let singleValue = row?.option {
            typeButton.setTitle(row?.configuration.selection.optionTitleClosure?(singleValue), for: .normal)
        }

        textField.text = row?.value as? String
        textField.placeholder = row?.configuration.cell.placeholder
        
        textField.isSecureTextEntry = false
        textField.clearButtonMode = .whileEditing
        
        if let type = row?.type {
            switch type {
            case .phone:
                textField.keyboardType = .phonePad
            case .email:
                textField.autocorrectionType = .no
                textField.autocapitalizationType = .none
                textField.keyboardType = .emailAddress
            default:
                break
            }
        }
    }
    
    /// `override firstResponderElement()`
    open override func firstResponderElement() -> UIResponder? {
        return textField
    }
    
    /// `override formRowCanBecomeFirstResponder()`
    open override class func formRowCanBecomeFirstResponder() -> Bool {
        return true
    }
    
    // MARK: Actions
    /// `editingChanged(_ sender: UITextField)`
    internal func editingChanged(_ sender: UITextField) {
        guard let text = sender.text, text.characters.count > 0 else { row?.value = nil; update(); return }
        row?.value = text as AnyObject
    }
    
    /// open option list controller
    func showOptions(_ sender: UIButton) {
        
        formViewController?.view.endEditing(true)
        
        var selectorControllerClass: UIViewController.Type
        
        if let controllerClass = row?.configuration.selection.controllerClass as? UIViewController.Type {
            selectorControllerClass = controllerClass
        } else { // fallback to default cell class
            selectorControllerClass = FormOptionsSelectorController.self
        }
        
        let selectorController = selectorControllerClass.init()
        guard let formRowViewController = selectorController as? FormSelector else { return }
        
        formRowViewController.formCell = self
        formViewController?.navigationController?.pushViewController(selectorController, animated: true)
    }
}
