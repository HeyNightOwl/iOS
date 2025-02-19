//
//  HomeNotificationsController.swift
//  Night Owl
//
//  Created by Brian Vallelunga on 6/5/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//

class HomeNotificationsController: HomePageController {
    
    // MARK: Instance Variables
    private var spinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    private var user = User.current()
    
    // MARK: IBOutlets
    @IBOutlet weak var onboardImage: UIImageView!
    @IBOutlet weak var onboardLabel: UILabel!
    @IBOutlet weak var onboardButton: UIButton!

    // MARK: UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove Image If Height Is To Small
        if self.view.frame.height <= 480 {
            self.onboardImage.removeFromSuperview()
        }
        
        // Style Onboarding Label
        self.onboardLabel.textAlignment = NSTextAlignment.Center
        self.onboardLabel.textColor = UIColor.blackColor()
        self.onboardLabel.shadowColor = UIColor(white: 0, alpha: 0.1)
        self.onboardLabel.shadowOffset = CGSize(width: 0, height: 2)
        self.onboardLabel.numberOfLines = 0
        self.onboardLabel.adjustsFontSizeToFitWidth = true
        
        // Sytle Login Button
        self.onboardButton.backgroundColor = UIColor(red:0.29, green:0.4, blue:0.62, alpha:1)
        self.onboardButton.layer.cornerRadius = 7
        self.onboardButton.layer.shadowColor = UIColor(red:0.14, green:0.22, blue:0.43, alpha:1).CGColor
        self.onboardButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.onboardButton.layer.shadowRadius = 0
        self.onboardButton.layer.shadowOpacity = 1
        self.onboardButton.layer.masksToBounds = false
        
        // Add Spinner to Login Button
        self.spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        self.spinner.frame = CGRectMake(0, 0, 40, 40)
        self.onboardButton.addSubview(self.spinner)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Center Spinner
        self.spinner.center = CGPointMake(self.onboardButton.frame.width/2, self.onboardButton.frame.height/2)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Setup Login Button
        self.onboardButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.spinner.stopAnimating()
    }

    // MARK: IBActions
    @IBAction func buttonPressed(sender: UIButton) {
        self.onboardButton.setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal)
        self.spinner.center = CGPointMake(self.onboardButton.frame.width/2, self.onboardButton.frame.height/2)
        self.spinner.startAnimating()
        
        self.homeController.notifications.register()
        self.homeController.nextController()
        
        if Notifications().enabled {
            self.user.mixpanel.track("Mobile.Notifications.Authorized")
        } else {
            self.user.mixpanel.track("Mobile.Notifications.Denied")
        }
    }
}
