/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * MainCell.swift is part of flyve-mdm-ios
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
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-agent
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit

/// MainCell class
class MainCell: UITableViewCell {
    
    // MARK: Init
    /// `overrride init`
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = UITableViewCellSelectionStyle.none
        backgroundColor = .clear
        setupView()
        addConstraints()
    }

    /// `overrride init`
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// `overrride layoutSubviews()`, uses the constraints to determine the size and position of any subviews
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    /// Set up the initial configuration of the cell view
    func setupView() {

        contentView.addSubview(lineView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(photoImageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(openBotton)
    }

    /// Add the constraints of the view
    func addConstraints() {

        lineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        lineView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        lineView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true

        photoImageView.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        photoImageView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        photoImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: lineView.topAnchor, constant: -16).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32).isActive = true

        descriptionLabel.bottomAnchor.constraint(equalTo: photoImageView.centerYAnchor).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 16).isActive = true

        detailLabel.topAnchor.constraint(equalTo: photoImageView.centerYAnchor).isActive = true
        detailLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 16).isActive = true

        openBotton.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor).isActive = true
        openBotton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
    }

    // MARK: Properties
    /// This property contains the configurations for the line view
    let lineView: UIView = {

        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .gray

        return line
    }()

    /// This property contains the configurations for the photo image view
    let photoImageView: UIImageView = {

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0.5
        imageView.layer.cornerRadius = 10
        imageView.layer.borderColor = UIColor.gray.cgColor

        return imageView
    }()

    /// titleLabel `UILabel`
    let titleLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightRegular)

        return label
    }()

    /// descriptionLabel `UILabel`
    let descriptionLabel: UILabel = {

        let label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightLight)

        return label
    }()
    
    /// detailLabel `UILabel`
    let detailLabel: UILabel = {

        let label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightThin)

        return label
    }()
    
    /// openBotton `UIButton`
    lazy var openBotton: UIButton = {

        let button = UIButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("open", comment: "").uppercased(), for: .normal)

        return button
    }()
}
