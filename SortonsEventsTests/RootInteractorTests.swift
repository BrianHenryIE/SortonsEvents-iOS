//
//  RootInteractorTests.swift
//  SortonsEvents
//
//  Created by Brian Henry on 3/16/17.
//  Copyright © 2017 Sortons. All rights reserved.
//

@testable import SortonsEvents

import XCTest

private class OutputMock: RootInteractorOutput {

    var asyncExpectation: XCTestExpectation?

    var showOfflineNoticeHit = false
    var showOnlineNoticeHit = false

    func showOfflineNotice() {
        showOfflineNoticeHit = true
        asyncExpectation?.fulfill()
    }
    func showOnlineNotice() {
        showOnlineNoticeHit = true
        asyncExpectation?.fulfill()
    }
}

class RootInteractorTests: XCTestCase {

    var rootInteractor: RootInteractor!
    private var outputMock: OutputMock!

    var asyncExpectation: XCTestExpectation?

    let systemEnterForegroundNotification = NSNotification.Name.UIApplicationWillEnterForeground

    var reloadNotificationReceived = false

    override func setUp() {
        super.setUp()

        asyncExpectation = nil

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reloadNotificationReceived(notification:)),
                                                   name: SortonsNotifications.Reload,
                                                 object: nil)

        outputMock = OutputMock()
        rootInteractor = RootInteractor(output: outputMock)
    }

    func reloadNotificationReceived(notification: NSNotification!) {
        asyncExpectation?.fulfill()
        reloadNotificationReceived = true
    }

    func fullfillExpectation() {
        asyncExpectation?.fulfill()
    }

    func testShouldSendReloadNotificationEnteringForeground() {
        // when the app hasn't been opened in 15 fifteen minutes
        asyncExpectation = expectation(description: "reloadNotificationReceived")

        let calendar = Calendar.current
        let fifteenMinutesAgo = calendar.date(byAdding: .minute, value: -15, to: Date())!

        rootInteractor.lastOpenedDate = fifteenMinutesAgo

        NotificationCenter.default.post(name: systemEnterForegroundNotification,
                                      object: self)

        waitForExpectations(timeout:5, handler: nil)

        XCTAssertTrue(reloadNotificationReceived)
    }

    func testShouldNotSendReloadNotificationEnteringForeground() {
        // when the app has just recently been opened
        asyncExpectation = expectation(description: "reloadNotificationReceived")

        let calendar = Calendar.current
        let fifteenMinutesAgo = calendar.date(byAdding: .minute, value: -5, to: Date())!

        rootInteractor.lastOpenedDate = fifteenMinutesAgo

        NotificationCenter.default.post(name: systemEnterForegroundNotification,
                                      object: self)

        Timer.scheduledTimer(timeInterval: 2,
                                   target: self,
                                 selector: #selector(self.fullfillExpectation),
                                 userInfo: nil,
                                  repeats: false)

        waitForExpectations(timeout:5, handler: nil)

        XCTAssertFalse(reloadNotificationReceived)
    }

    func testComingOnlineShouldRefreshExpiredData() {
        asyncExpectation = expectation(description: "reachabilityReloadExpired")

        let calendar = Calendar.current
        let fifteenMinutesAgo = calendar.date(byAdding: .minute, value: -15, to: Date())!

        rootInteractor.lastOpenedDate = fifteenMinutesAgo

        reloadNotificationReceived = false

        rootInteractor.reachability?.whenReachable?(rootInteractor.reachability!)

        waitForExpectations(timeout:5, handler: nil)

        XCTAssertTrue(reloadNotificationReceived)
    }

    func testComingOnlineShouldNotRefreshFreshData() {

        let outputMock = OutputMock()
        let rootInteractor = RootInteractor(output: outputMock)

        asyncExpectation = expectation(description: "reachabilityReloadFreshFresh")
        outputMock.asyncExpectation = expectation(description: "reachabilityWillHitThisFresh")

        let calendar = Calendar.current
        let fifteenMinutesAgo = calendar.date(byAdding: .minute, value: -5, to: Date())!

        rootInteractor.lastOpenedDate = fifteenMinutesAgo

        reloadNotificationReceived = false

        rootInteractor.reachability?.whenReachable?(rootInteractor.reachability!)

        Timer.scheduledTimer(timeInterval: 2,
                             target: self,
                             selector: #selector(self.fullfillExpectation),
                             userInfo: nil,
                             repeats: false)

        waitForExpectations(timeout:5, handler: nil)

        XCTAssertFalse(reloadNotificationReceived)
    }

    func testGoingOfflineShouldShowOfflineNotice() {

        let outputMock = OutputMock()
        let rootInteractor = RootInteractor(output: outputMock)

        outputMock.asyncExpectation = expectation(description: "offlineReachability")
        outputMock.asyncExpectation?.expectedFulfillmentCount = 2

        outputMock.showOfflineNoticeHit = false

        rootInteractor.reachability?.whenUnreachable?(rootInteractor.reachability!)

        waitForExpectations(timeout:2, handler: nil)

        XCTAssertTrue(outputMock.showOfflineNoticeHit)
    }

    func testComingOnlineShouldHideOfflineNotice() {

        let outputMock = OutputMock()
        let rootInteractor = RootInteractor(output: outputMock)

        outputMock.asyncExpectation = expectation(description: "onlineReachability")
        outputMock.asyncExpectation?.expectedFulfillmentCount = 2

        outputMock.showOnlineNoticeHit = false

        rootInteractor.reachability?.whenReachable?(rootInteractor.reachability!)

        waitForExpectations(timeout:2, handler: nil)

        XCTAssertTrue(outputMock.showOnlineNoticeHit)
    }

    override func tearDown() {
        NotificationCenter.default.removeObserver(self)
        super.tearDown()
    }

}
