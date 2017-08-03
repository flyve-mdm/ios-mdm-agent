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
 * @copyright   Copyright © 2017 Teclib. All rights reserved.
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
        text.clearButtonMode = UITextFieldViewMode.whileEditing
        text.textColor = .gray
        text.keyboardType = .default
        text.borderStyle = .none
        text.layer.backgroundColor = UIColor.white.cgColor
        text.layer.masksToBounds = false
        text.layer.shadowColor = UIColor.lightGray.cgColor
        text.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        text.layer.shadowOpacity = 1.0
        text.layer.shadowRadius = 0.0
        
        return text
    }()
    
    let lastNameTextField: UITextField = {
        
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.placeholder = "last_name".localized
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
    // MARK: FormBaseCell
    
    override func configure() {
        super.configure()
        
        contentView.addSubview(photoBotton)
        contentView.addSubview(firstNameTextField)
        contentView.addSubview(lastNameTextField)
        
        photoBotton.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        photoBotton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        photoBotton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        photoBotton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -48).isActive = true
        photoBotton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        
        firstNameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        firstNameTextField.bottomAnchor.constraint(equalTo: photoBotton.centerYAnchor, constant: -4).isActive = true
        firstNameTextField.leadingAnchor.constraint(equalTo: photoBotton.trailingAnchor, constant: 8).isActive = true
        firstNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        lastNameTextField.topAnchor.constraint(equalTo: photoBotton.centerYAnchor, constant: 4).isActive = true
        lastNameTextField.leadingAnchor.constraint(equalTo: photoBotton.trailingAnchor, constant: 8).isActive = true
        lastNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        lastNameTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -36).isActive = true
    }
    
    override func update() {
        super.update()
        
//        titleLabel.text = row?.title
    }
    
//    override func constraintsViews() -> [String : UIView] {
//        return ["titleLabel": titleLabel]
//    }
//    
//    override func defaultVisualConstraints() -> [String] {
//        return ["H:|-16-[titleLabel]-16-|"]
//    }
}
