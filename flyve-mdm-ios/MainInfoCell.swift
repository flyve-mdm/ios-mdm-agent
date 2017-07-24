/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * MainInfoCell.swift is part of flyve-mdm-ios
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
 * @date      24/07/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit

class MainInfoCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.contentView.backgroundColor = .clear
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func setupView() {

        backgroundColor = .white

        contentView.addSubview(self.photoBotton)
        contentView.addSubview(self.firstNameTextField)
        contentView.addSubview(self.lastNameTextField)

        addConstraints()
    }

    func addConstraints() {

        self.photoBotton.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        self.photoBotton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        self.photoBotton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16).isActive = true
        self.photoBotton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -48).isActive = true
        self.photoBotton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8).isActive = true

        self.firstNameTextField.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4).isActive = true
        self.firstNameTextField.bottomAnchor.constraint(equalTo: self.photoBotton.centerYAnchor, constant: -4).isActive = true
        self.firstNameTextField.leadingAnchor.constraint(equalTo: self.photoBotton.trailingAnchor, constant: 8).isActive = true
        self.firstNameTextField.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true

        self.lastNameTextField.topAnchor.constraint(equalTo: self.photoBotton.centerYAnchor, constant: 4).isActive = true
        self.lastNameTextField.leadingAnchor.constraint(equalTo: self.photoBotton.trailingAnchor, constant: 8).isActive = true
        self.lastNameTextField.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.lastNameTextField.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -36).isActive = true
    }

    lazy var photoBotton: UIButton = {

        let button = UIButton(type: UIButtonType.custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 30
        button.backgroundColor = UIColor.background
        button.addTarget(self, action: #selector(self.selectPhoto), for: .touchUpInside)

        return button
    }()

    let photoImageView: UIImageView = {

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.autoresizingMask = [.flexibleWidth,
                                      .flexibleHeight]
        imageView.clipsToBounds = true
        return imageView
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

    func selectPhoto() {

    }
}
