//
//  FacebookUrlTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 04/12/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

@testable import SortonsEvents

import XCTest

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
        XCTAssertNil(output.appUrl)
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

    func testRedirect() {

        // swiftlint:disable:next line_length
        let testUrl = "https://l.facebook.com/l.php?u=https%3A%2F%2Fwww.futurelearn.com%2Fcourses%2Fexercise-prescription%2F3&h=ATOUjWnxzolALe5qru7UaS8HfapY4BHBRZvsx5xF4eXyx3zUyck4AGzbY4XyUYQmixrY3NFML2cMrdX8qvs1H9VfjJgjYm2LlqfBIdBJ6YFNsyOuTRDBxRvFFt3K4OjmBPiVelE&enc=AZMYaBtFyZ3GKZkONX8Z4t0gXwJTe2nKisOW8Q22MDh411BBGW7lCnf6IwAKefQSLSlUPh9AERwafPjnMw1T0F5Z-uQVvOgnMxud3Qu4j1bKpwMue-ygopH4LULtuauUeFxm8DLvG3-no3WKuRzHNSnL77i2NykPA0giWnRVE96LTCgzd8UDoZ8Ak6bY7O6AbNnUs2mbyE6z7Fttg5ZHgqSS&s=1"

        let externalUrl = "https://www.futurelearn.com/courses/exercise-prescription/3"

        let safariUrl = URL(string: externalUrl)!

        let output = FacebookUrl(from: testUrl)

        XCTAssertEqual(output.safariUrl!, safariUrl)
        XCTAssertEqual(output.appUrl, nil)
    }

    func testAnotherRedirect() {

        // swiftlint:disable:next line_length
        let testUrl = "https://l.facebook.com/l.php?u=https%3A%2F%2Fwww.futurelearn.com%2Fcourses%2Fexercise-prescription%2F3&h=ATM2y9zZZQpFg8sfwtvF8IlEOUdJO4PXPV12Y-ojVow1Ffn9Ge0jXN9wCKLbM46j4fQs9d7_DWdF1GLTDbbryhX5rkAQLuqf1zWWKn2vbCz1mLR7Z7iJzOr_j7nMGBfxrFS8XZM&enc=AZPTFUbXYRnKe2XYF6K4FDokA1R7-m6pTx3YbztylWV96tJnk7vTswSb5w8GTLmOrJdbZ_DaRSh5dbAtEpK9Gwf-Oyv39NBPguOCBQlyBMcKsTEGqPHSaHqR7Il6SXLNptpFz5tX23Dqc3MPMUJYNhJWBfOFFnOrC31glBuml0WsiX4uWO4jhGQWPUeG0JwxlJulTlqyRfHxMtVKfWFCPefR&s=1"

        let externalUrl = "https://www.futurelearn.com/courses/exercise-prescription/3"

        let safariUrl = URL(string: externalUrl)!

        let output = FacebookUrl(from: testUrl)

        XCTAssertEqual(output.safariUrl!, safariUrl)
        XCTAssertEqual(output.appUrl, nil)

    }

    // TO BE CONSIDERED:

    func testShareButton() {

        // swiftlint:disable:next line_length
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
