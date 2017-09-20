/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * FormTextFieldCell.swift is part of flyve-mdm-ios
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
 * @date      08/08/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-agent
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit

/// FormTextFieldCell class
class FormTextFieldCell: FormBaseCell {
    
    // MARK: Properties
    /// `customConstraints`
    fileprivate var customConstraints: [AnyObject] = []
    
    // MARK: Cell views
    /// This property contains the configuration of the separtor view
    let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    /// This property contains the configuration for the text field
    let textField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.clearButtonMode = UITextFieldViewMode.whileEditing
        text.textColor = .gray
        text.keyboardType = .default
        text.borderStyle = .none
        
        return text
    }()
    
    /// Set up the initial configuration of the cell's view
    func setupViews() {
        
        selectionStyle = .none

        contentView.addSubview(textField)
        contentView.addSubview(separatorView)
    }
    
    /// Add the constraints to the view of the cell
    func addConstraints() {

        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 46).isActive =  true
        textField.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive =  true
        textField.topAnchor.constraint(equalTo: contentView.topAnchor).isActive =  true
        textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive =  true

        separatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        separatorView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12).isActive =  true
        separatorView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive =  true
        separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive =  true
    }
    
    /// Configures the view of the cell
    override func configure() {
        super.configure()
        setupViews()
        addConstraints()
        
        textField.addTarget(self, action: #selector(FormTextFieldCell.editingChanged(_:)), for: .editingChanged)

    }
    
    /// `override update()`
    override func update() {
        super.update()
        
        if let showsInputToolbar = row?.configuration.cell.showsInputToolbar, showsInputToolbar && textField.inputAccessoryView == nil {
            textField.inputAccessoryView = inputAccesoryView()
        }
        
        textField.text = row?.value as? String
        textField.placeholder = row?.configuration.cell.placeholder
        
        textField.isSecureTextEntry = false
        textField.clearButtonMode = .whileEditing
        
        if let type = row?.type {
            switch type {
            case .password:
                textField.isSecureTextEntry = true
                textField.clearsOnBeginEditing = false
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
}
