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
    fileprivate var outputMock: OutputMock!

    var asyncExpectation: XCTestExpectation?

    let systemEnterForegroundNotification = NSNotification.Name.UIApplicationWillEnterForeground

    var fifteenMinutesAgo: Date!
    var fiveMinutesAgo: Date!

    var reloadNotificationReceived = false

    override func setUp() {
        super.setUp()

        while asyncExpectation != nil || (outputMock != nil && outputMock!.asyncExpectation != nil) {
            Thread.sleep(forTimeInterval: 1)
        }

        NotificationCenter.default.removeObserver(self)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reloadNotificationReceived(notification:)),
                                                   name: SortonsNotifications.Reload,
                                                 object: nil)

        // Give it a few seconds for the initial reachability notification then clear it
        asyncExpectation = expectation(description: "setUp")

        outputMock = OutputMock()
        rootInteractor = RootInteractor(output: outputMock)

        waitForExpectations(timeout:3, handler: nil)

        Thread.sleep(forTimeInterval: 1)

        asyncExpectation = nil
        reloadNotificationReceived = false

        let calendar = Calendar.current
        fifteenMinutesAgo = calendar.date(byAdding: .minute, value: -15, to: Date())!
        fiveMinutesAgo = calendar.date(byAdding: .minute, value: -5, to: Date())!
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

        rootInteractor.lastOnlineDate = fifteenMinutesAgo

        NotificationCenter.default.post(name: systemEnterForegroundNotification,
                                      object: self)

        waitForExpectations(timeout:3, handler: nil)

        Thread.sleep(forTimeInterval: 1)

        XCTAssertTrue(reloadNotificationReceived)

        asyncExpectation = nil
    }

    func testShouldNotSendReloadNotificationEnteringForeground() {
        // when the app has just recently been opened

        asyncExpectation = expectation(description: "dontReloadNotificationReceived")

        rootInteractor.lastOnlineDate = fiveMinutesAgo

        NotificationCenter.default.post(name: systemEnterForegroundNotification,
                                      object: self)

        // The notification should not post, so we post it manually
        Timer.scheduledTimer(timeInterval: 2,
                                   target: self,
                                 selector: #selector(self.fullfillExpectation),
                                 userInfo: nil,
                                  repeats: false)

        waitForExpectations(timeout:3, handler: nil)

        Thread.sleep(forTimeInterval: 1)

        XCTAssertFalse(reloadNotificationReceived)

        asyncExpectation = nil
    }

    func testComingOnlineShouldRefreshExpiredData() {

        rootInteractor.lastOnlineDate = fifteenMinutesAgo

        asyncExpectation = expectation(description: "reachabilityLongOnline")

        rootInteractor.reachability?.whenReachable?(rootInteractor.reachability!)

        waitForExpectations(timeout:3, handler: nil)

        Thread.sleep(forTimeInterval: 1)

        XCTAssertTrue(reloadNotificationReceived)

        asyncExpectation = nil
    }

    func testComingOnlineShouldNotRefreshFreshData() {

        rootInteractor.lastOnlineDate = fiveMinutesAgo

        rootInteractor.reachability?.whenReachable?(rootInteractor.reachability!)

        Thread.sleep(forTimeInterval: 1)

        XCTAssertFalse(reloadNotificationReceived)

        asyncExpectation = nil
    }

    func testGoingOfflineShouldShowOfflineNotice() {

        outputMock.asyncExpectation = expectation(description: "offlineReachability")

        rootInteractor.reachability?.whenUnreachable?(rootInteractor.reachability!)

        waitForExpectations(timeout:2, handler: nil)

        XCTAssertTrue(outputMock.showOfflineNoticeHit)

        asyncExpectation = nil
    }

    func testComingOnlineShouldHideOfflineNotice() {

        outputMock.asyncExpectation = expectation(description: "onlineReachability")

        rootInteractor.reachability?.whenReachable?(rootInteractor.reachability!)

        waitForExpectations(timeout:2, handler: nil)

        XCTAssertTrue(outputMock.showOnlineNoticeHit)

        asyncExpectation = nil
    }
}
