/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * FormRow.swift is part of flyve-mdm-ios
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

class FormRow {
    
    // MARK: Types
    
    public enum RowType {
        case unknown
        case title
        case info
        case label
        case text
        case url
        case number
        case numbersAndPunctuation
        case decimal
        case name
        case phone
        case namePhone
        case email
        case twitter
        case asciiCapable
        case password
        case button
        case booleanSwitch
        case booleanCheck
        case segmentedControl
        case picker
        case date
        case time
        case dateAndTime
        case stepper
        case slider
        case multipleSelector
        case multilineText
    }
    
    public struct CellConfiguration {
        public var cellClass: AnyClass?
        public var appearance: [String: AnyObject]
        public var placeholder: String?
        public var showsInputToolbar: Bool
        public var required: Bool
        public var willUpdateClosure: ((FormRow) -> Void)?
        public var didUpdateClosure: ((FormRow) -> Void)?
        public var visualConstraintsClosure: ((FormBaseCell) -> [String])?
        
        public init() {
            cellClass = nil
            appearance = [:]
            placeholder = nil
            showsInputToolbar = false
            required = true
            willUpdateClosure = nil
            didUpdateClosure = nil
            visualConstraintsClosure = nil
        }
    }
    
    public struct SelectionConfiguration {
        public var controllerClass: AnyClass?
        public var options: [AnyObject]
        public var optionTitleClosure: ((AnyObject) -> String)?
        public var allowsMultipleSelection: Bool
        
        public init() {
            controllerClass = nil
            options = []
            optionTitleClosure = nil
            allowsMultipleSelection = false
        }
    }
    
    public struct ButtonConfiguration {
        public var didSelectClosure: ((FormRow) -> Void)?
        
        public init() {
            didSelectClosure = nil
        }
    }
    
    public struct StepperConfiguration {
        public var maximumValue: Double
        public var minimumValue: Double
        public var steps: Double
        public var continuous: Bool
        
        public init() {
            maximumValue = 0.0
            minimumValue = 0.0
            steps = 0.0
            continuous = false
        }
    }
    
    public struct DateConfiguration {
        public var dateFormatter: DateFormatter?
    }
    
    public struct RowConfiguration {
        public var cell: CellConfiguration
        public var selection: SelectionConfiguration
        public var button: ButtonConfiguration
        public var stepper: StepperConfiguration
        public var date: DateConfiguration
        public var userInfo: [String : AnyObject]
        
        init() {
            cell = CellConfiguration()
            selection = SelectionConfiguration()
            button = ButtonConfiguration()
            stepper = StepperConfiguration()
            date = DateConfiguration()
            userInfo = [:]
        }
    }
    
    // MARK: Properties
    
    public let tag: String
    public let type: RowType
    public var edit: UITableViewCellEditingStyle
    public var title: String?
    
    public var value: AnyObject? {
        willSet {
            guard let willUpdateBlock = configuration.cell.willUpdateClosure else { return }
            willUpdateBlock(self)
        }
        didSet {
            guard let didUpdateBlock = configuration.cell.didUpdateClosure else { return }
            didUpdateBlock(self)
        }
    }
    
    public var configuration: RowConfiguration
    
    // MARK: Init
    
    public init(tag: String, type: RowType, edit: UITableViewCellEditingStyle, title: String, configuration: RowConfiguration) {
        self.tag = tag
        self.type = type
        self.edit = edit
        self.title = title
        self.configuration = configuration
    }
    
    public init(tag: String, type: RowType, edit: UITableViewCellEditingStyle, title: String) {
        self.tag = tag
        self.type = type
        self.edit = edit
        self.title = title
        self.configuration = RowConfiguration()
    }
}
