/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * FlyveRouter.swift is part of flyve-mdm-ios
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
 * @date      06/05/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios
 * @link      https://.flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import Foundation
import Alamofire

public var baseURL = String()
public var sessionToken = String()

enum FlyveRouter: URLRequestConvertible {
    
    case initSession(String)                        //  GET    /initSession
    case getFullSession()                           //  GET    /getFullSession
    case changeActiveProfile(String)                //  GET    /changeActiveProfile
    case pluginFlyvemdmAgent([String : AnyObject])  //  POST   /pluginFlyvemdmAgent
    case getPluginFlyvemdmAgent(String)             //  GET    /getPluginFlyvemdmAgent

    var method: Alamofire.HTTPMethod {
        switch self {
        case .initSession, .getFullSession, .changeActiveProfile, .getPluginFlyvemdmAgent:
            return .get
        case .pluginFlyvemdmAgent:
            return .post
        }
    }
    
    var path: String {
        // build up and return the URL for each endpoint
        switch self {
            
        case .initSession(_ ) :
            return "/initSession"
        case .getFullSession():
            return "/getFullSession"
        case .changeActiveProfile(_ ):
            return "/changeActiveProfile"
        case .pluginFlyvemdmAgent(_ ):
            return "/PluginFlyvemdmAgent"
        case .getPluginFlyvemdmAgent(let agent_id):
            return "/PluginFlyvemdmAgent/\(agent_id)"

        }
        
    }
    
    var query: String {
        // build up and return the query for each endpoint
        switch self {
            
        case .initSession(let user_token) :
            return "user_token=\(user_token)"
        case .getFullSession():
            return ""
        case .changeActiveProfile(let profiles_id):
            return "profiles_id=\(profiles_id)"
        case .pluginFlyvemdmAgent(_ ):
            return ""
        case .getPluginFlyvemdmAgent(_ ):
            return ""
        }
        
    }
    
    /// Returns a URL request or throws if an `Error` was encountered.
    ///
    /// - throws: An `Error` if the underlying `URLRequest` is `nil`.
    ///
    /// - returns: A URL request.
    func asURLRequest() throws -> URLRequest {
        
        var strURL = String()

        if query.isEmpty {
            strURL = "\(baseURL)\(path)"
        } else {
            strURL = "\(baseURL)\(path)?\(query)"
        }
        
        let requestURL = URL(string:strURL)!
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = method.rawValue
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if !sessionToken.isEmpty {
            urlRequest.setValue("\(sessionToken)", forHTTPHeaderField: "Session-Token")
        }
        
        switch self {
        case .pluginFlyvemdmAgent(let parameters):
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
        default:
            return urlRequest
        }
    }
}
