//
//  AppDelegate.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-10.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var mainViewController: UIViewController {
        let webService = WebService()
        let user = appSetup()
        
        let home = HomeViewController(webservice: webService)
        home.setUpForTabBarController()
        
        let routineView = RoutineViewController(webservice: webService)
        routineView.setUpForTabBarController()
        
        let authentication = LoginViewController()
        authentication.setUpForTabBarController()
        
        var controllers = [routineView, home]
        
        if user.userType() == "ACC" {
            let profile = ProfileViewController(user: user, webService: WebService())
            profile.setUpForTabBarController()
            controllers.append(profile)
        } else {
            controllers.append(authentication)
        }
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = controllers.map { UINavigationController(rootViewController: $0) }
        
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.shadowImage = UIImage()
        tabBarController.tabBar.backgroundImage = UIImage()
        tabBarController.tabBar.barTintColor = .white
        
        return tabBarController
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window?.rootViewController = mainViewController
        self.window?.backgroundColor = .white
        
       
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "FYPv4")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func appSetup() -> User {
        let webservice = WebService()
        var returnUser: User
        
        // Check for user in user defaults
        if let user = UserDefaultsStore.retrieve(User.self) {
            print("There was a user")
            returnUser = user
            // If there is a user in user defaults they have used the app before
            if let token = user.token {
                print("That user was one with an account")
                // If they have a token, they are an authenticated user and not a TEMP
                User.updateUserOnAppLoad(webservice: webservice, token: token, callback: { res in
                    switch res {
                    case .error(let error):
                        print(error.localizedDescription)
                    case .success(let newUser):
                        UserDefaultsStore.store(persistables: newUser)
                    }
                })
                
                // If they have an account try and fetch routine if found
                if let _ = UserDefaultsStore.retrieve(Routine.self) {
                    print("That user had a routine")
                    // Try to update the routine
                    User.userRoutine(webservice: webservice, token: token) { (result) in
                        guard let updateRoutine = result else { return }
                        switch updateRoutine {
                        case .error(let error):
                            print(error.localizedDescription)
                        case .success(let updatedroutine):
                            UserDefaultsStore.store(persistables: updatedroutine)
                        }
                    }
                } else {
                    print("That user did not have a routine")
                }
                guard let u = UserDefaultsStore.retrieve(User.self) else {
                    fatalError("User was saved but not found")
                    
                }
                return u
            } else {
                // These users have used the app but do not have an account
                print("That user did not have an account on the server")
                if UserDefaultsStore.retrieve(Routine.self) == nil {
                    print("That user did not have a routine")
                } else {
                    print("That user did have a routine saved on device")
                }
                guard let u = UserDefaultsStore.retrieve(User.self) else {
                    fatalError("User was saved but not found")
                }
                return u
            }
        } else {
            print("There was no account this is brand a new user")
            // these users have not used the app before so they get a TEMP user
            returnUser = User(firstname: "Temp", lastname: "User", email: "None", password: "None", description: "None", dateofbirth: "None", type: "TEMP", id: nil, token: nil, image: nil)
            UserDefaultsStore.store(persistables: returnUser)
            
            return returnUser
        }
    }

}

