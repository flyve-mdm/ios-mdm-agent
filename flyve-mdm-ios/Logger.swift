/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * Logger.swift is part of flyve-mdm-ios
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
 * @date      16/08/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios-agent
 * @link      https://flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import Foundation

/// Enum for showing the type of Log Types
enum LogEvent {

    case trace, debug, info, warning, error
    
    var description: String {
        return String(describing: self).uppercased()
    }
}

/// Logger class
class Logger {
    // MARK: Properties
    /// date format
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    /// date formatter
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    // MARK: Methods
    /**
     Logs a message with a trace severity level.
     
     - parameter message: The message to log
     - parameter event: The the type of Log Types
     - parameter file: The file in which the log happens
     - parameter line: The line at which the log happens
     - parameter column: The column at which the log happens
     - parameter function: The function in which the log happens
     */
    class func log(message: String,
                   event: LogEvent,
                   fileName: String = #file,
                   line: Int = #line,
                   column: Int = #column,
                   funcName: String = #function) {
        
        print("\(Date().toString()) \(event.description): \(sourceFileName(filePath: fileName)) \(funcName) line: \(line) column: \(column) -> \(message)")
    }
    
    /**
     Get file name source
     
     - parameter filePath: The file path source
     */
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}

internal extension Date {
    /**
     Get date formatter to string
     
     - return: date formatter to string
     */

    func toString() -> String {
        return Logger.dateFormatter.string(from: self as Date)
    }
}
