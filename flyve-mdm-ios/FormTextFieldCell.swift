/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * FieldTextCell.swift is part of flyve-mdm-ios
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

class FormTextFieldCell: FormBaseCell {
    
    // MARK: Cell views
    
    let typeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("mobile", for: .normal)
        return button
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    let textField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        
        return text
    }()
    
    // MARK: Properties
    
    fileprivate var customConstraints: [AnyObject] = []
    
    // MARK: FormBaseCell
    
    func setupViews() {
        
        selectionStyle = .none

        textField.addTarget(self, action: #selector(FormTextFieldCell.editingChanged(_:)), for: .editingChanged)
        contentView.addSubview(typeButton)
        contentView.addSubview(separatorView)
        contentView.addSubview(textField)
    }
    
    func addConstraints() {
        
        typeButton.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        typeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        separatorView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        separatorView.widthAnchor.constraint(equalToConstant: 0.5).isActive = true
        separatorView.leftAnchor.constraint(equalTo: typeButton.rightAnchor, constant: 8.0).isActive = true
        
        textField.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        textField.leftAnchor.constraint(equalTo: separatorView.rightAnchor, constant: 8.0).isActive = true
        
    }
    
    override func configure() {
        super.configure()
        setupViews()
        addConstraints()
    }
    
    override func update() {
        super.update()
        
        if let showsInputToolbar = row?.configuration.cell.showsInputToolbar, showsInputToolbar && textField.inputAccessoryView == nil {
            textField.inputAccessoryView = inputAccesoryView()
        }
        
        typeButton.setTitle("work", for: .normal)
        textField.text = row?.value as? String
        textField.placeholder = row?.configuration.cell.placeholder
        
        textField.isSecureTextEntry = false
        textField.clearButtonMode = .whileEditing
        
        if let type = row?.type {
            switch type {
            case .text:
                textField.autocorrectionType = .default
                textField.autocapitalizationType = .sentences
                textField.keyboardType = .default
            case .number:
                textField.keyboardType = .numberPad
            case .numbersAndPunctuation:
                textField.keyboardType = .numbersAndPunctuation
            case .decimal:
                textField.keyboardType = .decimalPad
            case .name:
                textField.autocorrectionType = .no
                textField.autocapitalizationType = .words
                textField.keyboardType = .default
            case .phone:
                textField.keyboardType = .phonePad
            case .namePhone:
                textField.autocorrectionType = .no
                textField.autocapitalizationType = .words
                textField.keyboardType = .namePhonePad
            case .url:
                textField.autocorrectionType = .no
                textField.autocapitalizationType = .none
                textField.keyboardType = .URL
            case .twitter:
                textField.autocorrectionType = .no
                textField.autocapitalizationType = .none
                textField.keyboardType = .twitter
            case .email:
                textField.autocorrectionType = .no
                textField.autocapitalizationType = .none
                textField.keyboardType = .emailAddress
            case .asciiCapable:
                textField.autocorrectionType = .no
                textField.autocapitalizationType = .none
                textField.keyboardType = .asciiCapable
            case .password:
                textField.isSecureTextEntry = true
                textField.clearsOnBeginEditing = false
            default:
                break
            }
        }
    }
    
//    open override func constraintsViews() -> [String : UIView] {
//        var views = ["textField": textField]
//
//        return views
//    }
//
//    open override func defaultVisualConstraints() -> [String] {
//        return ["H:[imageView]-[titleLabel]-[textField]-16-|"]
//    }
    
    open override func firstResponderElement() -> UIResponder? {
        return textField
    }
    
    open override class func formRowCanBecomeFirstResponder() -> Bool {
        return true
    }
    
    // MARK: Actions
    
    internal func editingChanged(_ sender: UITextField) {
        guard let text = sender.text, text.characters.count > 0 else { row?.value = nil; update(); return }
        row?.value = text as AnyObject
    }
}
