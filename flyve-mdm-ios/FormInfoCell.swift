/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * FormInfoCell.swift is part of flyve-mdm-ios
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
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit

class FormInfoCell: FormBaseCell {
    
    // MARK: Cell views
    
    lazy var photoBotton: UIButton = {
        
        let button = UIButton(type: UIButtonType.custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 30
        button.backgroundColor = UIColor.background
        
        return button
    }()
    
    let firstNameTextField: UITextField = {
        
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.placeholder = "first_name".localized
        text.tag = 0
        text.clearButtonMode = UITextFieldViewMode.whileEditing
        text.textColor = .gray
        text.keyboardType = .default
        text.borderStyle = .none
        text.layer.backgroundColor = UIColor.white.cgColor
        text.layer.masksToBounds = false
        text.layer.shadowColor = UIColor.lightGray.cgColor
        text.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        text.layer.shadowOpacity = 1.0
        text.layer.shadowRadius = 0.0
        
        return text
    }()
    
    let lastNameTextField: UITextField = {
        
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.placeholder = "last_name".localized
        text.tag = 1
        text.clearButtonMode = UITextFieldViewMode.whileEditing
        text.textColor = .gray
        text.keyboardType = .default
        text.borderStyle = .none
        text.layer.backgroundColor = UIColor.white.cgColor
        text.layer.masksToBounds = false
        text.layer.shadowColor = UIColor.lightGray.cgColor
        text.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        text.layer.shadowOpacity = 1.0
        text.layer.shadowRadius = 0.0
        
        return text
    }()
    
    func setupViews() {
        contentView.addSubview(photoBotton)
        contentView.addSubview(firstNameTextField)
        contentView.addSubview(lastNameTextField)
    }
    
    func addConstraints() {
        photoBotton.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        photoBotton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        photoBotton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        photoBotton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        photoBotton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        
        firstNameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        firstNameTextField.bottomAnchor.constraint(equalTo: photoBotton.centerYAnchor, constant: -4).isActive = true
        firstNameTextField.leftAnchor.constraint(equalTo: photoBotton.rightAnchor, constant: 8).isActive = true
        firstNameTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        
        lastNameTextField.topAnchor.constraint(equalTo: photoBotton.centerYAnchor, constant: 4).isActive = true
        lastNameTextField.leftAnchor.constraint(equalTo: photoBotton.rightAnchor, constant: 8).isActive = true
        lastNameTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        lastNameTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
    }
    
    override func configure() {
        super.configure()
        
        setupViews()
        addConstraints()
        
        firstNameTextField.addTarget(self, action: #selector(FormInfoCell.editingChanged(_:)), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(FormInfoCell.editingChanged(_:)), for: .editingChanged)
    }
    
    override func update() {
        super.update()
        
        if let first = row?.value?["firstname"] as? String, !first.isEmpty {
            firstNameTextField.text = first
        }
        
        if let last = row?.value?["lastname"] as? String, !last.isEmpty {
            lastNameTextField.text = last
        }
    }
    
    open override func firstResponderElement() -> UIResponder? {
        return firstNameTextField
    }
    
    open override class func formRowCanBecomeFirstResponder() -> Bool {
        return true
    }
    
    // MARK: Actions
    
    internal func editingChanged(_ sender: UITextField) {
        guard let text = sender.text, text.characters.count > 0 else { row?.value = nil; update(); return }
        
        if var rowValue = row?.value as? [String: String] {
            
            if sender.tag == 0 {
                rowValue["firstname"] = text
                row?.value = rowValue as AnyObject
            }
            
            if sender.tag == 1 {
                rowValue["lastname"] = text
                row?.value = rowValue as AnyObject
            }
        }
    }
}
