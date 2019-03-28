//
//  AppDelegate.swift
//  Assignment1
//
//  Created by Justine Manikan on 9/19/18.
//  Copyright © 2018 Justine Manikan. All rights reserved.
//

import UIKit
import SQLite3

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var databaseName : String? = "PokemonDatabase.db"
    var databasePath : String?
    var pokemons : [PokemonData] = []


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let documentsPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let documentsDir = documentsPaths[0]
        
        databasePath = documentsDir.appending("/" + databaseName!)
        
        checkAndCreateDatabase()
        
        readDataFromDatabase()
        
        return true
    }
    
    func checkAndCreateDatabase(){
        
        var success = false
        let fileManager = FileManager.default
        
        success = fileManager.fileExists(atPath: databasePath!)
        if success {
            return
        }
        
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + databaseName!)
        
        try? fileManager.copyItem(atPath: databasePathFromApp!, toPath: databasePath!)
        
        return;
        
        
    }
    
    func readDataFromDatabase(){
        
        pokemons.removeAll()
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK{
            print("Successfully opened connection to database at \(self.databasePath)")
            
            var queryStatement: OpaquePointer? = nil
            var queryStatementString : String = "Select * from pokemon"
            
            if sqlite3_prepare(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK{
                
                while(sqlite3_step(queryStatement) == SQLITE_ROW){
                    
                    let id: Int = Int(sqlite3_column_int(queryStatement, 0))
                    let pname = sqlite3_column_text(queryStatement, 1)
                    
                    let paddress = sqlite3_column_text(queryStatement, 2)
                    
                    let pphone = sqlite3_column_text(queryStatement, 3)
                    
                    let pemail = sqlite3_column_text(queryStatement, 4)
                    
                    let page = sqlite3_column_text(queryStatement, 5)
                    
                    let pgender = sqlite3_column_text(queryStatement, 6)
                    
                    let pbirth = sqlite3_column_text(queryStatement, 7)
                    
                    let psprite = sqlite3_column_text(queryStatement, 8)
                    
                    let name = String(cString: pname!)
                    let address = String(cString: paddress!)
                    let phone = String(cString: pphone!)
                    let email = String(cString: pemail!)
                    let age = String(cString: page!)
                    let gender = String(cString: pgender!)
                    let birth = String(cString: pbirth!)
                    let sprite = String(cString: psprite!)
                    
                    let data : PokemonData = PokemonData.init()
                    data.initWithStuff(theRow: id,theName: name, theAddress: address, thePhoneNo: phone, theEmail: email, theAge: age, theGender: gender, theBirth: birth, theSprite: sprite)
                    pokemons.append(data)
                    
                    print("Query Result:")
                    print("\(id) | \(name) | \(address) | \(phone) | \(email) | \(age) | \(gender) | \(birth) | \(sprite) ")
                    
                    
                    
                }
                
                sqlite3_finalize(queryStatement)
                
            }
            else {
                print("SELECT statement could not be prepared")
            }
            
            sqlite3_close(db)
        } else {
            print("Unable to open database")
        }
        
    }
    
    func insertIntoDatabase(pokemon: PokemonData) -> Bool{
        var db: OpaquePointer? = nil
        var returnCode: Bool = true
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(self.databasePath)")
            
            // step 16d - setup query - entries is the table name you created in step 0
            var insertStatement: OpaquePointer? = nil
            var insertStatementString : String = "insert into pokemon values(NULL, ?, ?, ?,?,?,?,?,?)"
            
            // step 16e - setup object that will handle data transfer
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                
                let nameStr = pokemon.name! as NSString
                let addressStr = pokemon.address! as NSString
                let phoneStr = pokemon.phone! as NSString
                let emailStr = pokemon.email! as NSString
                let ageStr = pokemon.age! as NSString
                let genderStr = pokemon.gender! as NSString
                let birthStr = pokemon.birth! as NSString
                let spriteStr = pokemon.sprite! as NSString


                
                sqlite3_bind_text(insertStatement, 1, nameStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, addressStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, phoneStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 4, emailStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 5, ageStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 6, genderStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 7, birthStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 8, spriteStr.utf8String, -1, nil)
                
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    let rowID = sqlite3_last_insert_rowid(db)
                    print("Successfully inserted row. \(rowID)")
                } else {
                    print("Could not insert row.")
                    returnCode = false
                }
                sqlite3_finalize(insertStatement)
            } else{
            
                print("Insert Statement could not be prepared")
                
                return returnCode
            }
            sqlite3_close(db);
        
        } else {
            print("Unable to open database")
            returnCode = false
        }
        return returnCode
        
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
    }


}

