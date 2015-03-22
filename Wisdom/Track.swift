//
//  Track.swift
//  Wisdom
//
//  Created by Brian Vallelunga on 3/22/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//

private var queueSize = 20
private var saveQueue: [Track] = []

class Track: NSObject {
    
    var name: String!
    var data: [NSObject : AnyObject]!
    
    convenience init(_ name: String, data: [NSObject : AnyObject]!) {
        self.init()
        
        self.name = name
        self.data = data
    }
    
    // MARK: Class Methods
    class func event(name: String) {
        saveQueue.append(Track(name, data: nil))
        self.batchSave(force: false)
    }
    
    class func event(name: String, data: [NSObject : AnyObject]!) {
        saveQueue.append(Track(name, data: data))
        self.batchSave(force: false)
    }
    
    class func batchSave(force: Bool = false) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            if force || saveQueue.count > queueSize {
                for event in saveQueue {
                    PFAnalytics.trackEventInBackground(event.name, dimensions: event.data, block: nil)
                }
                
                saveQueue.removeAll(keepCapacity: false)
            }
        })
    }
    
    class func appOpened(launchOptions: [NSObject: AnyObject]?) {
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
    }
    
    class func appOpenedFromNotification(userInfo: [NSObject: AnyObject]) {
        PFAnalytics.trackAppOpenedWithRemoteNotificationPayloadInBackground(userInfo, block: nil)
    }
}