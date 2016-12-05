//
//  NewsInteractorTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 16/11/2016.
//  Copyright © 2016 Sortons. All rights reserved.
//

import XCTest
@testable import SortonsEvents

class NewsWireframeSpy: NewsWireframe {
    var url: FacebookUrl!
    override func openUrl(url: FacebookUrl) {
        self.url = url
    }
}

class NewsInteractorOutputSpy: NewsInteractorOutput {
    func setFomoId(_ id: String) {
    }
}

class NewsInteractorTests: XCTestCase {

    var sut: NewsInteractor!
    var wireFrameSpy: NewsWireframeSpy!

    override func setUp() {
        super.setUp()

        wireFrameSpy = NewsWireframeSpy(fomoId: FomoId())
        let nilOutput = NewsInteractorOutputSpy()

        sut = NewsInteractor(wireframe: wireFrameSpy, fomoId: "", output: nilOutput)
    }

    func testOpenUrlNormal() {
        let regularUrlString = "http://www.example.com"
        let regularUrl = URL(string: regularUrlString)!

        sut.open(url: regularUrl)

        XCTAssertEqual(wireFrameSpy.url.safariUrl!, regularUrl)

    }

    func testStripFacebookRedirect() {
        // Should strip Facebook redirect URL becuase it warns users "are you sure"

        // swiftlint:disable:next line_length
        let redirectUrlString = "https://www.facebook.com/l.php?u=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DiU4GbVJ6reE&h=ATNdxq2zpLt_DNz5c6y1PDBrgeI9TbBBZ0Mdj-q-7RDwC8Y57jeeDNBsXFvilXVba9_G3qgNh0N0Ko0E3jDOkPrX-InVRlVJLAmFLvmEETMpYEO7kPZ33cV3vJVsHukWG-iLHJTyzmTVsYM&enc=AZNYwhXJryGcIB1Gs3IB6VHNLJxvmA7uTidZ7c3UcdaqnAYMwydub-lmi-PqZj0STg32l520Bi8dfl0JrcpXuXhqgkyMxkMaK2fQy54zW4b9hgDvL-Te72Sv3ZXGbtA6gsiLIu5HC9IsxGuBuQw2yZtZfDTxIc7Rn3ct5XpFfkiu3MnE6HXleQBZzDCf20L52sIDgvsRW7GkX-u8peBDvBM2&s=1"

        let cleanUrlString = "https://www.youtube.com/watch?v=iU4GbVJ6reE"
        let cleanUrl = URL(string: cleanUrlString)

        let regularUrl = URL(string: redirectUrlString)!

        sut.open(url: regularUrl)

        XCTAssertEqual(wireFrameSpy.url.safariUrl!, cleanUrl)

    }

}
