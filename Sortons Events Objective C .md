# Sortons Events
## *Let's go out!*

As a personal project to just generally learn programming, I previously built a Java app on Google App Engine, with a front-end written with GWT (Java-JavaScript compiler), which watches a list of Facebook Pages for new events they have created or posted.

Two examples of this in action are on the [UCD Societies Facebook Page](https://www.facebook.com/UCDsocieties/app_123069381111681) and a page for [Dublin Theatre](https://www.facebook.com/DublinTheatre/app_123069381111681) that I set up myself. The data is exposed as JSON so is ready to use in this project. For the purpose of this assignment, I'll use another dataset which covers more UCD events. Its JSON is at: https://sortonsevents.appspot.com/_ah/api/upcomingEvents/v1/discoveredeventsresponse/197528567092983

Unfortunately, I've managed to break my Java code/deployment setup while trying to use Maven and the small changes I'd like to make will distract me from the Objective-C, so I'm hoping to waste no more time I getting that working. I'd like to experiment with some of the following:

* TDD
* Localization
* Crash reports
* Analytics
* Siri
* Notification Screen
* Facebook SDK
* Cocoa Pods
* App Store
* Settings.app
* Background refresh


* JSON
* Core Data
* Web views


### JSON

The first steps in the app were to get the JSON downloaded and displayed in a Table View. I followed a tutorial on [appcoda.com](http://www.appcoda.com/fetch-parse-json-ios-programming-tutorial/) which got the basics working. The  main problems with the app once the tutorial was over were the long delay in the data displaying, the image loading interrupting scrolling and the data not fitting in the Prototype Cells.
The long delay was due to the reloadData method being called from a background thread. It was resolved with the following replacement:
> [self.tableView reloadData];
   
>  [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES]; 

I found a project on Github called [AsyncImageView](https://github.com/nicklockwood/AsyncImageView) which acted as a drop-in replacement for a regular Image View but took care of loading the image asynchronously and caching the image. It doesn't work perfectly, but it stops the jarring of the scrolling.

To allow all the content to fit, the Labels for the events' names and locations were set to *Line Breaks: Word Wrap* and adding the following to the viewDidLoad method:
> self.tableView.estimatedRowHeight = 300;

> self.tableView.rowHeight = UITableViewAutomaticDimension;

The solution, an iOS 8 feature, is not perfect as the first few rows' heights are not always corect, though any that are scrolled onto the screen, including scrolling the first few back on, appear correctly.

At this point I have a method in my View Controller which uses NSDate, NSTimeInterval and NSCalendar to format the event's date as a friendly NSString. While I don't think it's incorrect to have it in the View Controller for this Table View, if it were in the Prototype Cell's class, it might allow for more reuse of that.

The app is also set to display the event in the Facebook app if it is installed, by using the fb://profile/id/ naming scheme and [[UIApplication sharedApplication] canOpenURL:facebookURL] method to check if it's possible, otherwise it opens a regular http URL.

(add a screenshot here 8/4 ~16:50)
needs a menubar so more views can be added!


The Java app also has the list of Facebook Pages that are included and is also collecting the posts they make on Facebook. I've added a Collection View Controller to show the pages and a View Controller with a Web View to show the posts using some JavaScript Facebook provide.


Status bar is transparent! ugh.
I expected this to be a simple checkbox in Storyboard editor but unchecking Extend Edges: Under Top Bars on the tab view controlelr didn't work. Nor did adding 

http://stackoverflow.com/questions/20687082/how-do-i-make-my-ios7-uitableviewcontroller-not-appear-under-the-top-status-bar
So there was no solution but to put a tableview inside a regular View Controller. Then when I added it to the TabViewController, it wasn't the first item in the tab bar, as I would like, and dragging the list of Relationship "vew controllers" to events wasn't possible.

"The frame is usually set to the screen frame, minus the height of the status bar or, in a navigation-based app, to the screen frame minus the heights of the status bar and the navigation bar. " -- https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/TableView_iPhone/CreateConfigureTableView/CreateConfigureTableView.html


threw in some pragma marks: http://nshipster.com/pragma/

## TabBarController
Although the TabBarController is relatively easy to set up, it wasn't obvious how to reorder the tabs.  

### Web View
The News section of the app is implemented using a UIWebView. The approach first taken was to load a local news.html file into the view whose JavaScript uses AJAX to get the list of recent posts and uses the Facebook JS SDK to display them. Unfortunately, I came across a bug in the Facebook JS SDK that prevented the posts from being displayed properly if the .html was accessed ala file:// rather than http://. I filed a bug report with Facebook.

https://developers.facebook.com/bugs/1626808577549882/

* reading local files (resources)

This did not take heed of the folder I had created, but seems to use the filesystem layout.
* Cross-Origin Resource Sharing

I was worried that web-view would not be able to get the JSON list. 

* Intercepting clicks to use external apps

I don't think it would be the greatest user experience

http://stackoverflow.com/questions/8437305/ios-uiwebview-intercept-link-click
http://sortonsevents.appspot.com/recentposts/?client=197528567092983

http://stackoverflow.com/questions/9928388/is-there-cross-domain-policy-in-a-uiwebview


## Pages list
http://taybenlor.com/2013/05/21/designing-for-ios.html

https://sortonsevents.appspot.com/_ah/api/clientdata/v1/clientpagedata/197528567092983

## Cocoa Pods

Like Maven for Swift and Objective-C development

Failed to install because of "certificate verify failed". Problem due to Java and Maven being added to the system PATH variable, whereas Ruby needs to be at the start!

http://www.raywenderlich.com/64546/introduction-to-cocoapods-2
http://libraries.io/cocoapods/AsyncImageView/1.5

## settings.app
http://useyourloaf.com/blog/2010/05/18/adding-a-settings-bundle-to-an-iphone-app.html
https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/UserDefaults/Preferences/Preferences.html

## TDD

http://nshipster.com/xctestcase/
http://sketchytech.blogspot.ie/2012/04/json-and-xcode-ios-basics.html

## Facebook SDK

https://developers.facebook.com/docs/ios/getting-started

## Localisation
http://www.appcoda.com/localization-tutorial-ios8/

Problem: out of date documentation. Searching Google for only the past year and excluding Swift was the best way to search.

Ineligible device.

Great resource:
http://learnxinyminutes.com/docs/objective-c/
raywenderlich.com
http://nshipster.com/xctestcase/
