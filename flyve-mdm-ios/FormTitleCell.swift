/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * FormTitleCell.swift is part of flyve-mdm-ios
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

/// FormTitleCell class
class FormTitleCell: FormBaseCell {
    
    // MARK: Cell views
    
    /// This property contains the configuration of the title label
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        
        return label
    }()
    
    /// This property contains the configuration of the separator view
    let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    /// Configures the view of the cell
    override func configure() {
        super.configure()

        contentView.addSubview(titleLabel)
        contentView.addSubview(separatorView)
        
        titleLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive =  true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive =  true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive =  true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive =  true
        
        separatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        separatorView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: -24).isActive =  true
        separatorView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive =  true
        separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive =  true
    }
    
    /// `override update()`
    override func update() {
        super.update()
        
        titleLabel.text = row?.title
    }
}
