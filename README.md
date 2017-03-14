![Platform iOS](https://img.shields.io/badge/platform-iOS-yellow.svg)
![Swift 3](https://img.shields.io/badge/Swift-3-orange.svg?style=flat)
[![codecov](https://codecov.io/gh/BrianHenryIE/SortonsEvents-iOS/branch/master/graph/badge.svg)](https://codecov.io/gh/BrianHenryIE/SortonsEvents-iOS) ![App Installs](http://sortons.ie/events/github/appinstalls/appinstalls.svg)

# Sortons Events

An events and news aggregator released for Irish universities.

Sortons, from the French verb sortir (/soɾˈtiɾ/) to go out. Nous sortons – we are going out!

Originally written as a [Java web-app](https://github.com/BrianHenryIE/Sortons-Events) to be used as a Facebook Page tab, the backend runs on Google App Engine. Later an [Objective-C client](https://github.com/BrianHenryIE/SortonsEvents-iOS/tree/52227492fc7abce797a3b009a13ccbd471f40457/SortonsEvents) was written which has since been rewritten in Swift from scratch using a TDD approach as described by [Clean Swift](http://clean-swift.com/).
![](http://www.sortons.ie/events/github/sortonseventsiphonerender.png)
Check it out on the App Store for:

| [![](http://www.sortons.ie/events/github/dublincityuniversity.png)](https://itunes.apple.com/ie/app/fomo-dcu/id1037323967?mt=8) | [![](http://www.sortons.ie/events/github/trinitycollegedublin.png)](https://itunes.apple.com/ie/app/fomo-tcd/id1035135187?mt=8)  |  [![](http://www.sortons.ie/events/github/universitycollegedublin.png)](https://itunes.apple.com/ie/app/fomo-ucd/id977641745?mt=8) |
|---|---|---|---|
|[Dublin City University](https://itunes.apple.com/ie/app/fomo-dcu/id1037323967?mt=8)|[Trinity College Dublin](https://itunes.apple.com/ie/app/fomo-tcd/id1035135187?mt=8)|[University College Dublin](https://itunes.apple.com/ie/app/fomo-ucd/id977641745?mt=8)|

## Build

Clone, run `pod install`, open `SortonsEvents.xcworkspace` and remember to set the Signing Team under one of the targets. There are no API keys to set.

## Views

There are four views: Events, News, Directory, About. Events shows a list of upcoming events that were created or posted by Facebook pages related to the university. The News view is a merged newsfeed of all posts made by the related pages. Directory is that list of pages. About is meta, contact and sharing.

### Events

Events is pretty straightforward. It pulls JSON from GAE using [Alamofire](https://github.com/Alamofire/Alamofire), parses it with [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper) and displays it in a UITableViewController, caching as a text file for a neater UX the next time the app is opened. [AlamofireImage](https://github.com/Alamofire/AlamofireImage) is used to async fetch and cache the event images. When an event is clicked it checks is the Facebook app installed and opens the event details either there or in Safari.

### News

The news view wasn't part of the original plan, but in order to find all the events a Facebook Page has posted, I needed to read its wall. I save the post ids and use a WKWebView to display a merged newsfeed of all the relevant pages with the [Facebook Embedded Posts widget](https://developers.facebook.com/docs/plugins/embedded-posts), loading more as the users scrolls.

All link clicks are intercepted and opened in the Facebook app or Safari. The URLs are parsed to remove Facebook redirects which were showing a security warning and to convert http Facebook URLs into the Facebook app's URL scheme.

### Directory

The Directory is again a UITableView with a pretty straightforward search. I had an update to the app rejected by Apple for creating "a misleading association with DCU" – the screenshot had a list with the word "DCU" in it too many times. The president of DCU has installed and tried the app, so I think they're ok with it. I now take the screenshots using [Fastlane Snapshot](https://github.com/fastlane/fastlane/tree/master/snapshot) and the app detects when it is being run in a simulator and filters out terms such as "DCU".

### About

The About tab was added so people can communicate with me. The app stopped working for a few weeks when Facebook deprecated an API I was using. Nobody told me! The view is a static UITableView showing basic About, Changelog, and Privacy Policy information in a UIWebView, and now people can email me feedback (MFMailComposeViewController), share the app (UIActivityViewController) and rate the app (UIApplication.shared.openURL!).


## Story Time

In March 2016 I was living in Dublin on the route of the St. Patrick's Day Parade. Naturally, we were watching it and once it was over we invited some Americans into the apartment for drinks and fun. Some of them were studying in University College Dublin so I started talking about this app. One of the girls already had it installed on her phone! 

One of the main things I've learned through this and other events apps I've made is that people don't care about them. I think most people's lives are too busy for them to need to go looking for things to do.

## Resources 

Some tools I used as I built this.

* [clean-swift.com](http://clean-swift.com/)

I visited this page 100+ times as I disciplined myself to architect with proper separation of concerns and testing. It all makes logical sense and now seems easy but needed a mental shift when I knew whichever feature I wanted to implement was an easy few lines I could just write.

* [Makeappicon.com](https://makeappicon.com/)

This handy tool takes a single image and outputs all the required app icon sizes as an .xcassets folder you can drag and drop into Xcode.

* [Icons8](https://icons8.com/)

This is a handy site for the UITabBarController icons. They have a free licence that requires attribution. Apple rejected the app once for having a link in my App Store description to a site that offers purchases. I've since paid for the icons.

* [SwiftLint](https://github.com/realm/SwiftLint)

SwiftLint runs on every build to highlight poor code formatting. I'm far from adhering to all its suggestions but it's certainly improved my code a little.

* [mergepbx](https://github.com/simonwagner/mergepbx)

mergepbx addresses git merge problems on Xcode .pbxproj files.

* [Regex Pal](http://www.regexpal.com/)

Handy page for figuring out the correct regular expressions needed. I used it here when parsing the URLs from the News view but it's a tool I find myself using regularly.

* [iTunesConnect App Installs Badge](https://github.com/BrianHenryIE/iTunesConnect-App-Installs-Badge/)

This is a tool I wrote myself especially for this README. The badges at the top of the page are neat but there was no app installs count badge. I used [mikebarlow/itc-reporter](https://github.com/mikebarlow/itc-reporter) to put it together in a few hours.

* [Travis CI](https://travis-ci.org/)

I set up continuous integration as a prerequisite for the next tool!

* [Codecov](https://codecov.io/)

The other important metric I wanted for the top of this README was code coverage. Codecov gets called at the end of the Travis build and provides the badge image.

* [Shields IO](http://shields.io/)

The other badges at the top are made by Shields IO with a simple configurable URL.

* [MockuPhone](http://mockuphone.com/)

The angled phone picture above was created on MockuPhone. I'm going to replace this with a gif eventually.

* [Fabric](https://fabric.io)

Fabric is a five minute install (pod, build script and two lines) which provides usage data and crash reports.

* [FastLane](https://fastlane.tools/)

Part of Fabric, I've set up FastLane to automatically take app screenshots in order to ease submitting the different versions of the app for different colleges.

* [SLPagingViewSwift](https://github.com/StefanLage/SLPagingViewSwift)

I had implemented my own gesture recognisers to swipe between tabs but it wasn't as smooth an experience as is typical of other apps. This library made it easy to implement an improved UX. I've needed to make a few changes to this class as its properties were often marked as fileprivate which impeded subclassing.

## Roadmap

### UX Improvements

* Loading/error messages
* The Events view should show which clubs/societies the event is related to. Particularly, there's plenty of space for this on iPad. 
* The News view's performance needs attention.

### Push Notifications / Widget

I think a weekly push notification of what's coming up would be nice, and a "Today" app extension (lock screen widget) would be an appropriate UI.

### Facebook Ads

I'm a little disappointed with the number of users. When the above few points are complete, I'll take out some ads on Facebook to get the word out.

### Server Updates

I'm not yet dealing with dead events or pages, so I should write a cron for that.

Finding new pages to add to each directory is currently manual. A list of suggestions is built from the likes of the currently included pages. I'd like a weekly email telling me what new pages might be relevant, possibly with a confidence threshold that would automatically add them.

The server code is all at [BrianHenryIE/Sortons-Events](https://github.com/BrianHenryIE/Sortons-Events). 

## Contact

All my social profiles can be found at [BrianHenry.ie](http://www.brianhenry.ie) or you can email me: [brian.henry@sortons.ie](mailto:brian.henry@sortons.ie).

## Licence

I'm happy to share my code for others to see and learn from, but I think it's fair that others don't earn money off this without me also getting something. Get in touch!

