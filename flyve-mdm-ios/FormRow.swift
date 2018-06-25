/*
 * LICENSE
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
 * @author    Hector Rondon <hrondon@teclib.com>
 * @date      03/08/17
 * @copyright Copyright © 2017-2018 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/ios-mdm-agent
 * @link      http://flyve.org/ios-mdm-agent
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import UIKit

/// FormRow class
public class FormRow {
    
    // MARK: Types
    
    /// enumerate type row
    public enum RowType {
        /// `title`
        case title
        /// `info`
        case info
        /// `phone`
        case phone
        /// `email`
        case email
        /// `text`
        case text
        /// `number`
        case number
        /// `password`
        case password
        /// `multipleSelector`
        case multipleSelector
    }
    
    /// structure cell configuration
    public struct CellConfiguration {
        /// `cellClass`
        public var cellClass: AnyClass?
        /// `appearance`
        public var appearance: [String: AnyObject]
        /// `placeholder`
        public var placeholder: String?
        /// `showsInputToolbar`
        public var showsInputToolbar: Bool
        /// `required`
        public var required: Bool
        /// `willUpdateClosure: ((FormRow) -> Void)?`
        public var willUpdateClosure: ((FormRow) -> Void)?
        /// `didUpdateClosure: ((FormRow) -> Void)?`
        public var didUpdateClosure: ((FormRow) -> Void)?
        /// `visualConstraintsClosure: ((FormBaseCell) -> [String])?`
        public var visualConstraintsClosure: ((FormBaseCell) -> [String])?
        
        /// init method
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
    
    /// structure selection configuration
    public struct SelectionConfiguration {
        /// `controllerClass`
        public var controllerClass: AnyClass?
        /// `options`
        public var options: [AnyObject]
        /// `optionTitleClosure: ((AnyObject) -> String)?`
        public var optionTitleClosure: ((AnyObject) -> String)?
        /// `allowsMultipleSelection`
        public var allowsMultipleSelection: Bool
        
        /// init method
        public init() {
            controllerClass = nil
            options = []
            optionTitleClosure = nil
            allowsMultipleSelection = false
        }
    }
    
    /// structure button configuration
    public struct ButtonConfiguration {
        /// `didSelectClosure: ((FormRow) -> Void)?`
        public var didSelectClosure: ((FormRow) -> Void)?
        
        /// init method
        public init() {
            didSelectClosure = nil
        }
    }
    
    /// structure stepper configuration
    public struct StepperConfiguration {
        /// `maximumValue`
        public var maximumValue: Double
        /// `minimumValue`
        public var minimumValue: Double
        /// `steps`
        public var steps: Double
        /// `continuous`
        public var continuous: Bool
        
        /// init method
        public init() {
            maximumValue = 0.0
            minimumValue = 0.0
            steps = 0.0
            continuous = false
        }
    }
    
    /// structure date configuration
    public struct DateConfiguration {
        /// `dateFormatter`
        public var dateFormatter: DateFormatter?
    }
    
    /// structure row configuration
    public struct RowConfiguration {
        /// `cell`
        public var cell: CellConfiguration
        /// `selection`
        public var selection: SelectionConfiguration
        /// `button`
        public var button: ButtonConfiguration
        /// `stepper`
        public var stepper: StepperConfiguration
        /// `date`
        public var date: DateConfiguration
        /// `userInfo`
        public var userInfo: [String : AnyObject]
        
        /// init method
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
    /// `tag`
    public let tag: String
    /// `type`
    public let type: RowType
    /// `edit`
    public var edit: UITableViewCellEditingStyle
    /// `title`
    public var title: String?
    /// `option`
    public var option: AnyObject? {
        willSet {
            guard let willUpdateBlock = configuration.cell.willUpdateClosure else { return }
            willUpdateBlock(self)
        }
        didSet {
            guard let didUpdateBlock = configuration.cell.didUpdateClosure else { return }
            didUpdateBlock(self)
        }
    }
    /// `value`
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
    
    /// configuration
    public var configuration: RowConfiguration
    
    // MARK: Init
    
    /// init method
    public init(tag: String, type: RowType, edit: UITableViewCellEditingStyle, title: String, configuration: RowConfiguration) {
        self.tag = tag
        self.type = type
        self.edit = edit
        self.title = title
        self.configuration = configuration
    }
    
    /// init method
    public init(tag: String, type: RowType, edit: UITableViewCellEditingStyle, title: String) {
        self.tag = tag
        self.type = type
        self.edit = edit
        self.title = title
        self.configuration = RowConfiguration()
    }
}
