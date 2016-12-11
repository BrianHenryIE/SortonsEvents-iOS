//
//  FacebookUrlTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 04/12/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import XCTest
@testable import SortonsEvents

class FacebookUrlTests: XCTestCase {

    // should catch internal Facebook links and send users to the app itself

    func testRegularUrl() {
        let regular = "http://www.example.com"
        let regularUrl = URL(string: "http://www.example.com")!

        let output = FacebookUrl(from: regular)

        XCTAssertEqual(output.safariUrl!, regularUrl)
        XCTAssertNil(output.appUrl)
    }

    func testFacebookUrlString() {
        let facebookLink = "https://www.facebook.com/BrianHenryIE"

        let facebookLinkUrl = URL(string: "https://www.facebook.com/BrianHenryIE")!

        let output = FacebookUrl(from: facebookLink)

        XCTAssertEqual(output.safariUrl!, facebookLinkUrl)
        XCTAssertNil(output.appUrl) // TODO: nil for now, but an async graph call in future
    }

    func testHashtag() {

        let hashtag = "https://www.facebook.com/hashtag/leinsterrugby?source=embed"
        let hashtagUrl = URL(string: hashtag)!

        let output = FacebookUrl(from: hashtag)

        XCTAssertEqual(output.safariUrl!, hashtagUrl)
        XCTAssertNil(output.appUrl)
    }

    func testComment() {

        let comment = "https://www.facebook.com/DCULawSociety/posts/1536987909651954"

        let commentSafariUrl = URL(string: comment)!

        let commentAppUrl = URL(string: "fb://profile/1536987909651954")!

        let output = FacebookUrl(from: comment)

        XCTAssertEqual(output.safariUrl!, commentSafariUrl)
        XCTAssertEqual(output.appUrl!, commentAppUrl)
    }

    func testEvent() {

        let event = "https://www.facebook.com/events/227112494391045/"

        let eventSafariUrl = URL(string: event)!

        let eventAppUrl = URL(string: "fb://profile/227112494391045")!

        let output = FacebookUrl(from: event)

        XCTAssertEqual(output.safariUrl!, eventSafariUrl)
        XCTAssertEqual(output.appUrl!, eventAppUrl)
    }

    func testPhoto() {

        // swiftlint:disable:next line_length
        let photo = "https://www.facebook.com/dcubbs/photos/ms.c.eJw9kMkRBDEIAzPa4hbkn9gabObZJYQbg80gAddCEf1wOZuzahkJZVF9nBAKc8NlJR7eXMmH5fWVtfucOy81OfnjU~_j3FB~;PPJ6Pmk8u8tjHN3lz195nycs1fVuO6nlUPsb4WqxvX3TmZfMcH3y~_yZPz3nNMuu~;rUzE52WWj67~;~;acSzL~_IPqrdKlA~-~-.bps.a.714472445397923.1073741841.564756210369548/714472675397900/?type=3"

        let photoSafariUrl = URL(string: photo)!
        let photoAppUrl = URL(string: "fb://profile/714472675397900")!

        let output = FacebookUrl(from: photo)

        XCTAssertEqual(output.safariUrl!, photoSafariUrl)
        XCTAssertEqual(output.appUrl!, photoAppUrl)
    }

    // TO BE CONSIDERED:

    func testShareButton() {

//        let shareButtton = "https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fwww.facebook.com%2Fevents%2F224228118004603%2F&display=popup&ref=plugin&src=post"
//        let shareButttonUrl = URL(string: shareButtton)
//        
//        let output = FacebookUrl(from: shareButtton)
//        
//        XCTAssertEqual(output.safariUrl!, shareButttonUrl)
//        XCTAssertNil(output.appUrl)
    }

    // LIKE?  - don't want to be prompted to log in!

    // "see more" in text

    // Interested button on events!

}
