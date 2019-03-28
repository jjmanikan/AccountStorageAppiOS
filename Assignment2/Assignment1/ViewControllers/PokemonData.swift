//
//  Data.swift
//  Assignment1
//
//  Created by Justine Manikan on 9/21/18.
//  Copyright © 2018 Justine Manikan. All rights reserved.
//

import UIKit

class PokemonData: NSObject {
    
    var id : Int?
    var name : String?
    var address : String?
    var phone : String?
    var email : String?
    var age : String?
    var gender : String?
    var birth : String?
    var sprite : String?
    
    
    func initWithStuff(theRow i: Int,theName n: String, theAddress a: String, thePhoneNo p: String ,  theEmail e: String, theAge ag: String, theGender g: String, theBirth b: String, theSprite s: String){
        id = i
        name = n
        address = a
        phone = p
        email = e
        age = ag
        gender = g
        birth = b
        sprite = s
        
        
    }

}
