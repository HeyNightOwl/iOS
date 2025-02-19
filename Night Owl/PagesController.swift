//
//  ViewController.swift
//  Night Owl
//
//  Created by Brian Vallelunga on 3/21/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class PagesController: UIPageViewController, UIAlertViewDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {

    // MARK: Enums
    enum AlertMode {
        case RateApp, UpdateApp
    }

    // MARK: Instance Variables
    var controllers = Dictionary<Int, PageController>()
    var currentPage = 2
    private var user = User.current()
    private var settings: Settings!
    private let pages = 4
    private let startPage = 2
    private var alertMode: AlertMode!
    private var storyBoard = UIStoryboard(name: "Main", bundle: nil)
    private var startDate = NSDate()
    private var scrollView: UIScrollView!
    private var inviteController: UINavigationController!
    private var notification: CWStatusBarNotification!
    
    // MARK: UIViewController Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Global
        Global.pagesController = self
        
        // Create Notification
        self.notification = CWStatusBarNotification()
        self.notification.notificationAnimationInStyle = .Top
        self.notification.notificationAnimationOutStyle = .Top
        self.notification.notificationAnimationType = .Overlay
        self.notification.notificationStyle = .NavigationBarNotification
        self.notification.notificationLabelBackgroundColor = UIColor(red:0.64, green:0.2, blue:0.62, alpha:1)
        self.notification.notificationLabelTextColor = UIColor.whiteColor()
        self.notification.notificationLabelFont = UIFont(name: "HelveticaNeue-Bold", size: 20)
        self.notification.notificationTappedBlock = {
            self.notification.dismissNotification()
            self.setActiveChildController(0, animated: true, gotToRoot: true, direction: .Reverse)
        }
        
        // Create Page View Controller
        self.view.backgroundColor = UIColor.clearColor()
        self.dataSource = self
        self.delegate = self
        
        for controller in self.view.subviews {
            if let scrollView = controller as? UIScrollView {
                self.scrollView = scrollView
                self.scrollView.delegate = self
            }
        }
        
        // Create Controllers
        for index in 0...self.pages {
            var page: PageController!
            
            switch(index) {
            case 0: page = self.storyBoard.instantiateViewControllerWithIdentifier("SupportController") as? PageController
            case 1: page = self.storyBoard.instantiateViewControllerWithIdentifier("QuestionsController") as? PageController
            case 2: page = self.storyBoard.instantiateViewControllerWithIdentifier("CameraController") as? PageController
            default: page = self.storyBoard.instantiateViewControllerWithIdentifier("SettingsController") as? PageController
            }
            
            page?.view.frame = self.view.frame
            page?.pageIndex = index
            self.controllers[index] = page
        }
        
        self.didMoveToParentViewController(self)
        
        // Get Settings
        Settings.sharedInstance { (settings) -> Void in
            self.settings = settings
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Configure Status Bar
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        // Remove Text From Back Button
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-1000, -1000),
            forBarMetrics: UIBarMetrics.Default)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Set Start Page
        self.setActiveChildController(self.startPage, animated: false, gotToRoot: true, direction: .Forward)
    }
    
    // MARK: Instance Methods
    func showRateApp(message: String) {
        self.alertMode = .RateApp
        UIAlertView(title: "Rate Our App", message: message, delegate: self,
            cancelButtonTitle: "No Thanks", otherButtonTitles: "Sure!").show()
    }
    
    func showDownloadApp(message: String) {
        self.alertMode = .UpdateApp
        UIAlertView(title: "Update The App", message: message, delegate: self,
            cancelButtonTitle: "No Thanks", otherButtonTitles: "Sure!").show()
    }
    
    func showAlert(title: String, message: String) {
        UIAlertView(title: title, message: message, delegate: self,
            cancelButtonTitle: "Thanks!").show()
    }
    
    func showNotification(message: String) {
        self.notification.displayNotificationWithMessage(message, forDuration: 3)
    }
    
    func showInvite(source: String, dismissed: ((invites: Int) -> ())!) {
        var goToController = self.currentPage
        
        MaveSDK.sharedInstance().presentInvitePageModallyWithBlock({ (viewController: UIViewController!) -> Void in
            self.presentViewController(viewController, animated: true, completion: nil)
            
            self.user.mixpanel.track("Mobile.Referrals.Page", properties: [
                "Source": source
            ])
        }, dismissBlock: { (viewController: UIViewController!, numberOfInvitesSent: UInt) -> Void in
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.setActiveChildController(goToController, animated: false, gotToRoot: false, direction: .Forward)
                dismissed?(invites: Int(numberOfInvitesSent))
            })
            
            if numberOfInvitesSent > 0 {
                self.user.mixpanel.track("Mobile.Referrals.Sent", properties: [
                    "Invites": numberOfInvitesSent,
                    "Source": source
                ])
            }
        }, inviteContext: source)
    }
    
    func lockPageView() {
        self.scrollView.scrollEnabled = false
    }
    
    func unlockPageView() {
        self.scrollView.scrollEnabled = true
    }
    
    func setActiveChildController(index: Int, animated: Bool, gotToRoot: Bool, direction: UIPageViewControllerNavigationDirection) {
        self.unlockPageView()
        
        self.setViewControllers([self.viewControllerAtIndex(index)],
            direction: direction, animated: animated, completion: { (success: Bool) -> Void in
                if gotToRoot {
                    self.viewControllerAtIndex(self.currentPage).popToRootViewControllerAnimated(true)
                }
                
                self.currentPage = index
            })
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.setActiveChildController(index, animated: false, gotToRoot: gotToRoot, direction: .Forward)
        })
    }
    
    func viewControllerAtIndex(index: Int) -> PageController! {
        if self.pages == 0 || index >= self.pages {
            return nil
        }
        
        return self.controllers[index]
    }
    
    // MARK: UIAlertViewDelegate
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            var verb = "Rate"
            
            if self.alertMode == .UpdateApp {
                verb = "Update"
            }
            
            self.user.mixpanel.track("Mobile.\(verb).Popup")
            var url = NSURL(string: "itms-apps://itunes.apple.com/app/id\(self.settings.itunesId)")
            UIApplication.sharedApplication().openURL(url!)
        }
    }
    
    // MARK: Page View Controller Data Source
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        
        if completed {
            self.currentPage = (pageViewController.viewControllers.last as! PageController).pageIndex
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageController).pageIndex
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        
        return self.viewControllerAtIndex(index - 1)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {        
        var index = (viewController as! PageController).pageIndex
        
        if index == NSNotFound || index >= self.pages {
            return nil
        }
        
        return self.viewControllerAtIndex(index + 1)
    }
    
    // MARK: UIScrollView Delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.currentPage == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width {
            scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0)
        } else if self.currentPage == (self.pages - 1) && scrollView.contentOffset.x > scrollView.bounds.size.width {
            scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0)
        }
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if self.currentPage == 0 && scrollView.contentOffset.x <= scrollView.bounds.size.width {
            targetContentOffset.memory.x = scrollView.bounds.size.width
            targetContentOffset.memory.y = 0
        } else if self.currentPage == (self.pages - 1) && scrollView.contentOffset.x >= scrollView.bounds.size.width {
            targetContentOffset.memory.x = scrollView.bounds.size.width
            targetContentOffset.memory.y = 0
        }
    }
}
