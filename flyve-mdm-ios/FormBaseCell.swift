/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * FormBaseCell.swift is part of flyve-mdm-ios
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

open class FormBaseCell: UITableViewCell {
    
    // MARK: Properties
    
    open var row: FormRow? {
        didSet {
            self.update()
        }
    }
    
    weak var formViewController: FormViewController?
    
    fileprivate var customConstraints: [NSLayoutConstraint] = []
    
    // MARK: Init
    
    public required override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Public interface
    
    open func configure() {
        /// override
    }
    
    open func update() {
        /// override
    }
    
    open func defaultVisualConstraints() -> [String] {
        /// override
        return []
    }
    
    open func constraintsViews() -> [String : UIView] {
        /// override
        return [:]
    }
    
    open func firstResponderElement() -> UIResponder? {
        /// override
        return nil
    }
    
    open func inputAccesoryView() -> UIToolbar {
        
        let actionBar = UIToolbar()
        actionBar.isTranslucent = true
        actionBar.sizeToFit()
        actionBar.barStyle = .default
        
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .done, target: self, action: #selector(FormBaseCell.handleDoneAction(_:)))
        
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        actionBar.items = [flexible, doneButton]
        
        return actionBar
    }
    
    internal func handleDoneAction(_: UIBarButtonItem) {
        firstResponderElement()?.resignFirstResponder()
    }
    
    open class func formRowCanBecomeFirstResponder() -> Bool {
        return false
    }
    
    class func formViewController(_ formViewController: FormViewController, didSelectRow: FormBaseCell) {
    }
    
    // MARK: Constraints
    
    open override func updateConstraints() {
        if customConstraints.count > 0 {
            contentView.removeConstraints(customConstraints)
        }
        
        let views = constraintsViews()
        
        customConstraints.removeAll()
        
        var visualConstraints = [String]()
        
        if let visualConstraintsClosure = row?.configuration.cell.visualConstraintsClosure {
            visualConstraints = visualConstraintsClosure(self)
        } else {
            visualConstraints = defaultVisualConstraints()
        }
        
        for visualConstraint in visualConstraints {
            let constraints = NSLayoutConstraint.constraints(withVisualFormat: visualConstraint, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
            for constraint in constraints {
                customConstraints.append(constraint)
            }
        }
        
        contentView.addConstraints(customConstraints)
        super.updateConstraints()
    }
}
