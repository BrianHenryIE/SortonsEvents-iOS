//
//  NetworkWorker.swift
//  Sortons Events
//
//  Created by Brian Henry on 05/03/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

protocol NetworkProtocol {
    func fetch<T: SortonsNW & ImmutableMappable>
        (_ fomoId: String, completionHandler: @escaping (_ result: Result<[T]>) -> Void)
}

class NetworkWorker<T: SortonsNW & ImmutableMappable>: NetworkProtocol {

    func fetch<T: SortonsNW & ImmutableMappable>
        (_ fomoId: String, completionHandler: @escaping (_ result: Result<[T]>) -> Void) {

        let endpoint = "\(T.endpointBase)\(fomoId)"
        let keyPath = T.keyPath

        Alamofire.request(endpoint).responseJSON { response in
            if let result = response.result.value,
                let jsonDict = result as? NSDictionary,
                let data = jsonDict.object(forKey: keyPath),
                let array = try? Mapper<T>().mapArray(JSONObject: data) {
                    completionHandler(Result<[T]>.success(array))
            } else {
                let ERROR_CODE = 101
                let error = NSError(domain: "ie.sortons.event.networkerror", code: ERROR_CODE, userInfo: nil)
                completionHandler(Result<[T]>.failure(error))
            }
        }

        // This NetworkWorker could be a little neater if AlamofireObjectmapper supported 
        // the (beta) immutable feature of ObjectMapper
        // https://github.com/tristanhimmelman/AlamofireObjectMapper/issues/181
        // Alamofire.request(endpoint).responseArray(keyPath: keyPath) {
        //     (response: DataResponse<[T]>) in
        //         completionHandler(response.result)
        // }
    }
}
