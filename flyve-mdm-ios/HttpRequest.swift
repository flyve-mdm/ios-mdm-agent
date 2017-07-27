/*
 *   Copyright © 2017 Teclib. All rights reserved.
 *
 * HttpRequest.swift is part of flyve-mdm-ios
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
 * @date      05/05/17
 * @copyright Copyright © 2017 Teclib. All rights reserved.
 * @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
 * @link      https://github.com/flyve-mdm/flyve-mdm-ios
 * @link      https://.flyve-mdm.com
 * ------------------------------------------------------------------------------
 */

import Foundation
import Alamofire

@objc protocol HttpRequestDelegate {
    @objc optional func responseInitSession(data: [String: AnyObject])
    @objc optional func errorInitSession(error: [String: String])

    @objc optional func responseGetFullSession(data: [String: AnyObject])
    @objc optional func errorGetFullSession(error: [String: String])

    @objc optional func responseChangeActiveProfile()
    @objc optional func errorChangeActiveProfile(error: [String: String])

    @objc optional func responsePluginFlyvemdmAgent(data: [String: AnyObject])
    @objc optional func errorPluginFlyvemdmAgent(error: [String: String])

    @objc optional func responseGetPluginFlyvemdmAgent(data: [String: AnyObject])
    @objc optional func errorGetPluginFlyvemdmAgent(error: [String: String])
}

class HttpRequest: NSObject {

    weak var delegate: HttpRequestDelegate?

    func requestInitSession(userToken: String) {

        let request = Alamofire.request(FlyveRouter.initSession(userToken))
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let result = response.result.value {

                        self.delegate?.responseInitSession!(data: result as? [String: AnyObject] ?? [String: AnyObject]())
                    }
                case .failure(_ ):
                    self.delegate?.errorInitSession!(error: self.handlerError(response))
                }
        }
        debugPrint(request)
    }

    func requestGetFullSession() {

        let request = Alamofire.request(FlyveRouter.getFullSession())
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let result = response.result.value {
                        self.delegate?.responseGetFullSession!(data: result as? [String: AnyObject] ?? [String: AnyObject]())
                    }
                case .failure(_ ):
                    self.delegate?.errorGetFullSession!(error: self.handlerError(response))
                }
        }
        debugPrint(request)
    }

    func requestChangeActiveProfile(profilesID: String) {

        let request = Alamofire.request(FlyveRouter.changeActiveProfile(profilesID))
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch response.result {
                case .success:
                    self.delegate?.responseChangeActiveProfile!()
                case .failure(_ ):

                    var errorDescription = String()

                    if let data = response.data {
                        errorDescription = String(data: data, encoding: String.Encoding.utf8) ?? ""
                    }

                    self.delegate?.errorChangeActiveProfile!(error: ["error": response.error as? String ?? "", "message": errorDescription as String])
                }
        }
        debugPrint(request)
    }

    func requestPluginFlyvemdmAgent(parameters: [String : AnyObject]) {

        let request = Alamofire.request(FlyveRouter.pluginFlyvemdmAgent(parameters))
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let result = response.result.value {

                        self.delegate?.responsePluginFlyvemdmAgent!(data: result as? [String: AnyObject] ?? [String: AnyObject]())
                    }
                case .failure(_ ):
                    self.delegate?.errorPluginFlyvemdmAgent!(error: self.handlerError(response))
                }
        }
        debugPrint(request)
    }

    func requestGetPluginFlyvemdmAgent(agentID: String) {

        let request = Alamofire.request(FlyveRouter.getPluginFlyvemdmAgent(agentID))
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let result = response.result.value {
                        self.delegate?.responseGetPluginFlyvemdmAgent!(data: result as? [String: AnyObject] ?? [String: AnyObject]())
                    }
                case .failure(_ ):
                    self.delegate?.errorGetPluginFlyvemdmAgent!(error: self.handlerError(response))
                }
        }
        debugPrint(request)
    }
    
    func requestPluginFlyvemdmFile(fileID: String) {
        
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        
        let request = Alamofire.download(FlyveRouter.pluginFlyvemdmFile(fileID), to: destination)
            .response { response in
                
                if let error = response.error {
                    print(error)
                }
        }
        debugPrint(request)
    }

    func handlerError(_ response: DataResponse<Any>) -> [String: String] {

        var errorObj = [String]()
        var errorDict = [String: String]()

        if let data = response.data {
            errorObj = try! JSONSerialization.jsonObject(with: data) as? [String] ?? [String]()
        }

        if errorObj.count == 2 {
            errorDict["error"] = errorObj[0]
            errorDict["message"] = errorObj[1]
        } else {
            errorDict["error"] = ""
            errorDict["message"] = ""
        }

        return errorDict
    }
}
