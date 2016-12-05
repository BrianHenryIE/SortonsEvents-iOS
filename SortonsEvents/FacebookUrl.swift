//
//  FacebookUrl.swift
//  SortonsEvents
//
//  Created by Brian Henry on 04/12/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import Foundation

struct FacebookUrl {
    
    let appUrl: URL?
    let safariUrl: URL?
    
    let redirectRegex = "https://www.facebook.com/l.php\\?u=(.*)&h="
    let postRegex = "https://.*.facebook.com/.*/posts/(\\d*)"
    let eventRegex = "https://.*.facebook.com/events/(\\d*)"
    let photoRegex = "/(\\d*)/\\?"
    
    init(from inputUrl: String) {
        
        // Non-Facebook URL
        guard inputUrl.hasPrefix("https://www.facebook.com") || inputUrl.hasPrefix("https://m.facebook.com") else {
            appUrl = nil
            safariUrl = URL(string: inputUrl)
            return
        }

        // A redirect URL
        let redirectUrls = inputUrl.matchingStrings(regex: redirectRegex)
        if redirectUrls.count > 0 {
            let cleanUrlString = redirectUrls[0][1].removingPercentEncoding!
            safariUrl = URL(string: cleanUrlString)
            appUrl = nil
            return
        }
        
        //
        
        
        // comments
        let postUrls = inputUrl.matchingStrings(regex: postRegex)
        if postUrls.count > 0 {
            let cleanUrlString = "fb://profile/\(postUrls[0][1])"
            appUrl = URL(string: cleanUrlString)
            safariUrl = URL(string: inputUrl)
            return
        }

        // event
        let eventUrls = inputUrl.matchingStrings(regex: eventRegex)
        if eventUrls.count > 0 {
            let cleanUrlString = "fb://profile/\(eventUrls[0][1])"
            appUrl = URL(string: cleanUrlString)
            safariUrl = URL(string: inputUrl)
            return
        }
        
        // photo
        let photoUrls = inputUrl.matchingStrings(regex: photoRegex)
        if photoUrls.count > 0 {
            let cleanUrlString = "fb://profile/\(photoUrls[0][1])"
            appUrl = URL(string: cleanUrlString)
            safariUrl = URL(string: inputUrl)
            return
        }
        
        appUrl = nil
        safariUrl = URL(string: inputUrl)
    }
    
    func facebookUrlToAppUrl(url: String) -> (url: String, appUrl: String?) {
        
        guard url.hasPrefix("https://www.facebook.com") || url.hasPrefix("https://m.facebook.com") else { return (url: url, appUrl: nil) }
        
        // remove from &refsrc=
        
        // facebook.com/events/12345676/?a=
        
        // photos!
        
        
        return (url: url, appUrl: "fb://profile")
    }
}

// http://stackoverflow.com/questions/27880650/swift-extract-regex-matches
extension String {
    func matchingStrings(regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map { result.rangeAt($0).location != NSNotFound
                ? nsString.substring(with: result.rangeAt($0))
                : ""
            }
        }
    }
}
