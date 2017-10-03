//
//  AppDelegate.swift
//  SyncFiddle
//
//  Created by Pavel Peroutka on 02/10/2017.
//  Copyright © 2017 Pavel Peroutka. All rights reserved.
//

import UIKit
import CoreData
import Sync

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var dataStack: DataStack = DataStack(modelName: "Demo")
    
    static var sharedDataStack: DataStack = (UIApplication.shared.delegate as! AppDelegate).dataStack
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        // add listener for entity inserts and deletions
//        NotificationCenter.default.addObserver(self, selector: #selector(self.changeNotification), name: .NSManagedObjectContextObjectsDidChange, object: self.dataStack.mainContext)
        
        // get app directory so I can peek into sqlite
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            print(url.absoluteString)
        }
        
        return true
    }
    
    
    
    
//    func changeNotification(notification: NSNotification) {
//        var fetchedCount = 0
//        if let insertedObjects = notification.userInfo?[NSInsertedObjectsKey] {
//            fetchedCount = (insertedObjects as! [Any]).count
//        }
//        print("\(fetchedCount) items was fetched")
//    }
}

