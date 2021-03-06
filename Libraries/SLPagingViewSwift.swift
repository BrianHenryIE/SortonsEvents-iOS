//
//  PagingView.swift
//  TestSwift
//
//  Created by Stefan Lage on 09/01/15.
//  Copyright (c) 2015 Stefan Lage. All rights reserved.
//

import UIKit

public enum SLNavigationSideItemsStyle: Int {
    case slNavigationSideItemsStyleOnBounds = 40
    case slNavigationSideItemsStyleClose = 30
    case slNavigationSideItemsStyleNormal = 20
    case slNavigationSideItemsStyleFar = 10
    case slNavigationSideItemsStyleDefault = 0
    case slNavigationSideItemsStyleCloseToEachOne = -40
}

public typealias SLPagingViewMoving = ((_ subviews: [UIView])-> ())
public typealias SLPagingViewMovingRedefine = ((_ scrollView: UIScrollView, _ subviews: NSArray)-> ())
public typealias SLPagingViewDidChanged = ((_ currentPage: Int)-> ())

open class SLPagingViewSwift: UIViewController, UIScrollViewDelegate {

    // MARK: - Public properties
    var views = [Int : UIView]()
    open var currentPageControlColor: UIColor?
    open var tintPageControlColor: UIColor?
    open var pagingViewMoving: SLPagingViewMoving?
    open var pagingViewMovingRedefine: SLPagingViewMovingRedefine?
    open var didChangedPage: SLPagingViewDidChanged?
    open var navigationSideItemsStyle: SLNavigationSideItemsStyle = .slNavigationSideItemsStyleDefault

    // MARK: - Private properties
    fileprivate var SCREENSIZE: CGSize {
        return UIScreen.main.bounds.size
    }
    var scrollView: UIScrollView!
    fileprivate var pageControl: UIPageControl!
    fileprivate var navigationBarView: UIView   = UIView()
    fileprivate var navItems: [UIView]          = []
    fileprivate var needToShowPageControl: Bool = false
    fileprivate var isUserInteraction: Bool     = false
    var indexSelected: Int          = 0

    // MARK: - Constructors
    public required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Here you can init your properties
    }

    // MARK: - Constructors with items & views
    public convenience init(items: [UIView], views: [UIView]) {
        self.init(items: items, views: views, showPageControl:false, navBarBackground:UIColor.white)
    }

    public convenience init(items: [UIView], views: [UIView], showPageControl: Bool) {
        self.init(items: items, views: views, showPageControl:showPageControl, navBarBackground:UIColor.white)
    }

    /*
     *  SLPagingViewController's constructor
     *
     *  @param items should contain all subviews of the navigation bar
     *  @param navBarBackground navigation bar's background color
     *  @param views all subviews corresponding to each page
     *  @param showPageControl inform if we need to display the page control in the navigation bar
     *
     *  @return Instance of SLPagingViewController
     */
    public init(items: [UIView], views: [UIView], showPageControl: Bool, navBarBackground: UIColor) {
        super.init(nibName: nil, bundle: nil)
        setupViews(items: items, views: views, showPageControl: showPageControl, navBarBackground: navBarBackground)
    }

    public func setupViews(items: [UIView], views: [UIView], showPageControl: Bool, navBarBackground: UIColor) {
        needToShowPageControl             = showPageControl
        navigationBarView.backgroundColor = navBarBackground
        isUserInteraction                 = true
        for (i, v) in items.enumerated() {
            let vSize: CGSize = (v as? UILabel)?._slpGetSize() ?? v.frame.size
            let originX       = (self.SCREENSIZE.width/2.0 - vSize.width/2.0) + CGFloat(i * 100)
            v.frame           = CGRect(x: originX, y: 8, width: vSize.width, height: vSize.height)
            v.tag             = i
            let tap           = UITapGestureRecognizer(target: self, action: #selector(SLPagingViewSwift.tapOnHeader(_:)))
            v.addGestureRecognizer(tap)
            v.isUserInteractionEnabled = true
            self.navigationBarView.addSubview(v)
            self.navItems.append(v)
        }

        for (i, view) in views.enumerated() {
            view.tag = i
            self.views[i] = view
        }
    }
    // MARK: - Constructors with controllers
    public convenience init(controllers: [UIViewController]) {
        self.init(controllers: controllers, showPageControl: true, navBarBackground: UIColor.white)
    }

    public convenience init(controllers: [UIViewController], showPageControl: Bool) {
        self.init(controllers: controllers, showPageControl: true, navBarBackground: UIColor.white)
    }

    /*
     *  SLPagingViewController's constructor
     *
     *  Use controller's title as a navigation item
     *
     *  @param controllers view controllers containing sall subviews corresponding to each page
     *  @param navBarBackground navigation bar's background color
     *  @param showPageControl inform if we need to display the page control in the navigation bar
     *
     *  @return Instance of SLPagingViewController
     */
    public convenience init(controllers: [UIViewController], showPageControl: Bool, navBarBackground: UIColor) {
        var views = [UIView]()
        var items = [UILabel]()
        for ctr in controllers {
            let item  = UILabel()
            item.text = ctr.title
            views.append(ctr.view)
            items.append(item)
        }
        self.init(items: items, views: views, showPageControl:showPageControl, navBarBackground:navBarBackground)
    }

    // MARK: - Constructors with items & controllers
    public convenience init(items: [UIView], controllers: [UIViewController]) {
        self.init(items: items, controllers: controllers, showPageControl: true, navBarBackground: UIColor.white)
    }
    public convenience init(items: [UIView], controllers: [UIViewController], showPageControl: Bool) {
        self.init(items: items, controllers: controllers, showPageControl: showPageControl, navBarBackground: UIColor.white)
    }

    /*
     *  SLPagingViewController's constructor
     *
     *  @param items should contain all subviews of the navigation bar
     *  @param navBarBackground navigation bar's background color
     *  @param controllers view controllers containing sall subviews corresponding to each page
     *  @param showPageControl inform if we need to display the page control in the navigation bar
     *
     *  @return Instance of SLPagingViewController
     */
    public convenience init(items: [UIView], controllers: [UIViewController], showPageControl: Bool, navBarBackground: UIColor) {
        var views = [UIView]()
        for ctr in controllers {
            views.append(ctr.view)
        }
        self.init(items: items, views: views, showPageControl:showPageControl, navBarBackground:navBarBackground)
    }

    // MARK: - Life cycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupPagingProcess()
        self.setCurrentIndex(self.indexSelected, animated: false)
    }

    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationBarView.frame = CGRect(x: 0, y: 0, width: self.SCREENSIZE.width, height: 44)

    }

    // MARK: - Public methods

    /*
     *  Update the state of the UserInteraction on the navigation bar
     *
     *  @param activate state you want to set to UserInteraction
     */
    open func updateUserInteractionOnNavigation(_ active: Bool) {
        self.isUserInteraction = active
    }

    /*
     *  Set the current index page and scroll to its position
     *
     *  @param index of the wanted page
     *  @param animated animate the moving
     */
    open func setCurrentIndex(_ index: Int, animated: Bool) {
        // Be sure we got an existing index
        if(index < 0 || index > self.navigationBarView.subviews.count-1) {
            let exc = NSException(name: NSExceptionName(rawValue: "Index out of range"), reason: "The index is out of range of subviews's countsd!", userInfo: nil)
            exc.raise()
        }
        self.indexSelected = index
        // Get the right position and update it
        let xOffset = CGFloat(index) * self.SCREENSIZE.width
        self.scrollView.setContentOffset(CGPoint(x: xOffset, y: self.scrollView.contentOffset.y), animated: animated)
    }

    // MARK: - Internal methods
    fileprivate func setupPagingProcess() {
        let frame: CGRect                              = CGRect(x: 0, y: 0, width: SCREENSIZE.width, height: self.view.frame.height)

        self.scrollView                                = UIScrollView(frame: frame)
        self.scrollView.backgroundColor                = UIColor.clear
        self.scrollView.isPagingEnabled                  = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator   = false
        self.scrollView.delegate                       = self
        self.scrollView.bounces                        = false
        self.scrollView.contentInset                   = UIEdgeInsets(top: 0, left: 0, bottom: -80, right: 0)

        self.view.insertSubview(self.scrollView, at: 0)
        // Adds all views
        self.addViews()

        if(self.needToShowPageControl) {
            // Make the page control
            self.pageControl               = UIPageControl(frame: CGRect(x: 0, y: 35, width: 0, height: 0))
            self.pageControl.numberOfPages = self.navigationBarView.subviews.count
            self.pageControl.currentPage   = 0
            if self.currentPageControlColor != nil {
                self.pageControl.currentPageIndicatorTintColor = self.currentPageControlColor
            }
            if self.tintPageControlColor != nil {
                self.pageControl.pageIndicatorTintColor = self.tintPageControlColor
            }
            self.navigationBarView.addSubview(self.pageControl)
        }

        self.navigationController?.navigationBar.addSubview(self.navigationBarView)

    }

    // Loads all views
    fileprivate func addViews() {
        if self.views.count > 0 {
            let width                   = SCREENSIZE.width * CGFloat(self.views.count)
            let height                  = self.view.frame.height
            self.scrollView.contentSize = CGSize(width: width, height: height)
            var i: Int                  = 0
            while let v = views[i] {
                v.frame          = CGRect(x: self.SCREENSIZE.width * CGFloat(i), y: 0, width: self.SCREENSIZE.width, height: self.view.frame.height)
                self.scrollView.addSubview(v)
                i += 1
            }
        }
    }

    fileprivate func sendNewIndex(_ scrollView: UIScrollView) {
        let xOffset      = Float(scrollView.contentOffset.x)
        let currentIndex = (Int(roundf(xOffset)) % (self.navigationBarView.subviews.count * Int(self.SCREENSIZE.width))) / Int(self.SCREENSIZE.width)
        if self.needToShowPageControl && self.pageControl.currentPage != currentIndex {
            self.pageControl.currentPage = currentIndex
            self.didChangedPage?(currentIndex)
        }
    }

    func getOriginX(_ vSize: CGSize, idx: CGFloat, distance: CGFloat, xOffset: CGFloat) -> CGFloat {
        var result = self.SCREENSIZE.width / 2.0 - vSize.width/2.0
        result += (idx * distance)
        result -= xOffset / (self.SCREENSIZE.width / distance)
        return result
    }

    // Scroll to the view tapped
    func tapOnHeader(_ recognizer: UITapGestureRecognizer) {
        if let key = recognizer.view?.tag, let view = self.views[key], self.isUserInteraction {
            self.scrollView.scrollRectToVisible(view.frame, animated: true)
        }
    }

    // MARK: - UIScrollViewDelegate

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let xOffset = scrollView.contentOffset.x
        let distance = CGFloat(100 + self.navigationSideItemsStyle.rawValue)
        for (i, v) in (self.navItems).enumerated() {
            let vSize    = v.frame.size
            let originX  = self.getOriginX(vSize, idx: CGFloat(i), distance: CGFloat(distance), xOffset: xOffset)
            v.frame      = CGRect(x: originX, y: 8, width: vSize.width, height: vSize.height)
        }
        self.pagingViewMovingRedefine?(scrollView, self.navItems as NSArray)
        self.pagingViewMoving?(self.navItems)

//        - viewWillAppear:
//        - viewDidAppear:
//        - viewWillDisappear:
//        - viewDidDisappear:
    }

    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.sendNewIndex(scrollView)
    }

    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.sendNewIndex(scrollView)
    }

}

extension UILabel {
    func _slpGetSize() -> CGSize? {
        return (text as NSString?)?.size(attributes: [NSFontAttributeName: font])
    }
}
