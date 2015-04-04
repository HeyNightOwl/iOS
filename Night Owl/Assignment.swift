//
//  Assignment.swift
//  Night Owl
//
//  Created by Brian Vallelunga on 3/22/15.
//  Copyright (c) 2015 Brian Vallelunga. All rights reserved.
//

var cachedImages: Dictionary<String, Assignment.CachedImage> = [:]

class Assignment: NSObject {
    
    // MARK: Instance Variables
    var name: String!
    var question: PFFile!
    var answer: PFFile!
    var state: Int!
    var creator: User!
    var subject: Subject!
    var created: NSDate!
    var parse: PFObject!
    
    // MARK: Internal Class
    class CachedImage {
        var question: UIImage!
        var answer: UIImage!
    }
    
    // MARK: Enum
    enum ImageType {
        case Question, Answer
    }
    
    // MARK: Convenience Methods
    convenience init(_ object: PFObject) {
        self.init()
        
        self.name = object["name"] as? String
        self.question = object["question"] as? PFFile
        self.answer = object["answer"] as? PFFile
        self.state = object["state"] as Int
        self.created = object.createdAt
        self.parse = object
    }
    
    // MARK: Class Methods
    class func create(name: String!, question: UIImage, creator: User, subject: Subject) {
        var assignment = PFObject(className: "Assignment")
        
        if name != nil {
            assignment["name"] = name
        }
        
        assignment["state"] = 0
        assignment["creator"] = creator.parse
        assignment["subject"] = subject.parse
        
        assignment.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
            if success && error == nil {
                var instance = Assignment(assignment)
                var cachedImages = instance.getCachedImages()
                var imageData = UIImagePNGRepresentation(question)
                var imageFile = PFFile(name: "image.png", data: imageData)
               
                assignment["question"] = imageFile
                Global.reloadQuestionsController()
                cachedImages.question = question
                instance.setCachedImages(cachedImages)
                
                assignment.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
                    assignment["state"] = 1
                    assignment.saveInBackgroundWithBlock(nil)
                    Global.reloadQuestionsController()
                }
            } else {
                println(error)
            }
        }
        
    }
    
    // MARK: Instance Methods
    func getCreator(callback: ((creator: User) -> Void)!) {
        var user = self.parse["creator"] as PFUser
        
        if !user.isDataAvailable() {
            user.fetchIfNeededInBackgroundWithBlock { (object: PFObject!, error: NSError!) -> Void in
                self.creator = User(object as PFUser)
                callback?(creator: self.creator)
            }
        } else {
            self.creator = User(user)
            callback?(creator: self.creator)
        }
    }
    
    func getSubject(callback: ((subject: Subject) -> Void)!) {
        var subject = self.parse["subject"] as PFObject
        self.subject = Subject.subject(subject.objectId)
        callback?(subject: self.subject)
    }
    
    func nameFormatted(limit: Int = 20) -> String {
        if self.name != nil && !self.name.isEmpty {
            let title = NSString(string: self.name)
            let length = min(limit, title.length)
            var text: NSString = title.substringToIndex(length)
            
            if title.length > limit {
                text = text + "..."
            }
            
            return text
        } else {
            let timeInterval = TTTTimeIntervalFormatter()
            let interval = NSDate().timeIntervalSinceDate(self.created)
            return timeInterval.stringForTimeInterval(-interval)
        }
    }
    
    func changeState(state: Int) {
        self.state = state
        self.parse["state"] = state
        
        if state >= 4 {
            if var tutor = self.parse["tutor"] as? PFObject {
                var flaggedAssignments = tutor.relationForKey("flaggedAssignments")
                flaggedAssignments.addObject(self.parse)
                tutor.saveInBackgroundWithBlock(nil)
            }
        }
        
        self.parse.saveInBackgroundWithBlock(nil)
    }
    
    func getCachedImages() -> CachedImage {
        var cache = cachedImages[self.parse.objectId]
        
        if cache == nil {
            cache = CachedImage()
            cachedImages[self.parse.objectId] = cache
        }
        
        return cache!
    }
    
    func setCachedImages(cache: CachedImage) {
        cachedImages[self.parse.objectId] = cache
    }
    
    func getImage(type: ImageType, callback: (image: UIImage) -> Void) {
        var tmpImage: PFFile!
        var tmpCache: UIImage!
        var tmpCacheImages = self.getCachedImages()
        
        if type == .Question {
            tmpImage = self.question
            tmpCache = tmpCacheImages.question
        } else {
            tmpImage = self.answer
            tmpCache = tmpCacheImages.answer
        }
        
        if tmpCache != nil {
            callback(image: tmpCache)
            return
        }
        
        if tmpImage != nil {
            let request = NSURLRequest(URL: NSURL(string: tmpImage.url)!)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
                (response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    tmpCache = UIImage(data: data)
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                        // Makes a 1x1 graphics context and draws the image into it
                        UIGraphicsBeginImageContext(CGSizeMake(1,1))
                        let context = UIGraphicsGetCurrentContext()
                        CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), tmpCache.CGImage)
                        UIGraphicsEndImageContext()
                        
                        // Now the image will have been loaded and decoded
                        // and is ready to rock for the main thread
                        dispatch_async(dispatch_get_main_queue(), {
                            callback(image: tmpCache)
                        })
                        
                        if type == .Question {
                            tmpCacheImages.question = tmpCache
                        } else {
                            tmpCacheImages.answer = tmpCache
                        }
                        
                        self.setCachedImages(tmpCacheImages)
                    })
                } else {
                    println(error)
                }
            })
        }
    }

}
