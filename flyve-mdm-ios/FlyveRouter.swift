/*
 * LICENSE
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
 * @author    Hector Rondon <hrondon@teclib.com>
 * @date      06/05/17
 * @copyright Copyright © 2017-2018 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/ios-mdm-agent
 * @link      http://flyve.org/ios-mdm-agent
 * @link      https://.flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import Foundation
import Alamofire

/// enumerate endpoints methods
enum FlyveRouter: URLRequestConvertible {

    ///  GET    /initSession
    case initSession(String)
    ///  GET    /getFullSession
    case getFullSession()
    ///  POST   /changeActiveProfile
    case changeActiveProfile(String)
    ///  POST   /pluginFlyvemdmAgent
    case pluginFlyvemdmAgent([String : AnyObject])
    ///  GET    /getPluginFlyvemdmAgent
    case getPluginFlyvemdmAgent(String)
    ///  GET    /PluginFlyvemdmFile
    case pluginFlyvemdmFile(String)
    ///  GET    /PluginFlyvemdmEntityConfig
    case pluginFlyvemdmEntityConfig(String)
    
    /// get HTTP Method
    var method: Alamofire.HTTPMethod {
        switch self {
        case .initSession, .getFullSession, .getPluginFlyvemdmAgent, .pluginFlyvemdmFile, .pluginFlyvemdmEntityConfig:
            return .get
        case .pluginFlyvemdmAgent, .changeActiveProfile:
            return .post
        }
    }

    /// build up and return the URL for each endpoint
    var path: String {
        
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
        case .pluginFlyvemdmFile(let file_id):
            return "/PluginFlyvemdmFile/\(file_id)"
        case .pluginFlyvemdmEntityConfig(let entity_id):
            return "/PluginFlyvemdmFile/\(entity_id)"
        }
    }
    
    /// build up and return the query for each endpoint
    var query: String {
        
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
        case .pluginFlyvemdmFile(_ ):
            return ""
        case .pluginFlyvemdmEntityConfig(_ ):
            return ""
        }
    }
    
    /**
     Returns a URL request or throws if an `Error` was encountered
     
     - throws: An `Error` if the underlying `URLRequest` is `nil`.
     - returns: A URL request.
     */
    func asURLRequest() throws -> URLRequest {
        var strURL = String()
        
        if let deeplink = getStorage(key: "deeplink") as? DeepLinkModel {
            if query.isEmpty {
                strURL = "\(deeplink.url)\(path)"
            } else {
                strURL = "\(deeplink.url)\(path)?\(query)"
            }
        }

        let requestURL = URL(string:strURL)!
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if !SESSION_TOKEN.isEmpty {
            urlRequest.setValue("\(SESSION_TOKEN)", forHTTPHeaderField: "Session-Token")
        }
        
        switch self {
        case .pluginFlyvemdmFile(_ ):
            urlRequest.setValue("application/octet-stream", forHTTPHeaderField: "Accept")
        default:
            break
        }

        switch self {
        case .pluginFlyvemdmAgent(let parameters):
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
        default:
            return urlRequest
        }
    }
}
