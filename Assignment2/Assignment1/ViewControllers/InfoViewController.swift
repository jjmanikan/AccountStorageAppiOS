//
//  InfoViewController.swift
//  Assignment1
//
//  Created by Justine Manikan on 9/19/18.
//  Copyright © 2018 Justine Manikan. All rights reserved.
//

import UIKit
import AVFoundation

class InfoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var ageLabel: UILabel!
    
    @IBOutlet var tfName: UITextField!
    @IBOutlet var tfAddress: UITextField!
    @IBOutlet var tfPhoneNo: UITextField!
    @IBOutlet var tfEmail: UITextField!
    
    @IBOutlet var ageSlider: UISlider!
    @IBOutlet var sgGender: UISegmentedControl!
    
    @IBOutlet var birthDatePicker: UIDatePicker!
    
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var clearButton: UIButton!
    
    @IBOutlet var sgSprite: UISegmentedControl!
    
    @IBOutlet var imgSprite: UIImageView!
    
    var sprites = [#imageLiteral(resourceName: "Zorua"),#imageLiteral(resourceName: "shinx.gif"),#imageLiteral(resourceName: "zorua.gif")]
    
    @IBAction func doTheUpdate(sender : Any){
        let pokemon : PokemonData = PokemonData.init()
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM dd, YYYY"
        let dateStr = dateFormat.string(from: birthDatePicker.date)
        
        pokemon.initWithStuff(theRow: 0, theName: tfName.text!, theAddress: tfAddress.text!, thePhoneNo: tfPhoneNo.text!, theEmail: tfEmail.text!, theAge: String(ageSlider.value), theGender: sgGender.titleForSegment(at: sgGender.selectedSegmentIndex)!, theBirth: dateStr,theSprite:  sgSprite.titleForSegment(at: sgSprite.selectedSegmentIndex)!)
        
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let returnCode : Bool = mainDelegate.insertIntoDatabase(pokemon: pokemon)
        
        var returnMSG : String = "Person added"
        
        if returnCode == false {
            returnMSG = "Person Add Failed"
        }
        
        let alertController = UIAlertController(title: "SQLite Add", message: returnMSG, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        
        
        
    }
    
    func updateSprite(){
        let sprite = sgSprite.selectedSegmentIndex
        
        if (sprite == 0) {
            imgSprite.loadGif(name: "shinx")
        }
        else if (sprite == 1){
            imgSprite.loadGif(name : "zorua")
        }
        else {
            imgSprite.loadGif(name: "carbink")
        }
        
        
    }
    
    func updateAgeLabel(){
        let age = ageSlider.value
        let strage = String(format: "%.f", age)
        ageLabel.text = "Age: " + strage
    }
    
    @IBAction func sliderValueChange(sender : Any){
        updateAgeLabel()
    }
    
    @IBAction func spriteSegment( sender : Any) {
        updateSprite()
        
    }
    
    

    
    
    /*@IBAction func sendInfo(sender : Any){
        
        let email = validateEmail(testStr: tfEmail.text!)
        let phoneno = validatePhoneNo(value: tfPhoneNo.text!)
        
        if tfName.text == "" || tfAddress.text == "" || tfPhoneNo.text == "" || tfEmail.text == "" {
            
            let emptycheck = UIAlertController(title: "Warning", message: "Cannot leave fields empty", preferredStyle: .alert)
            
            let back = UIAlertAction(title: "Return", style: .cancel, handler: nil)
            
            emptycheck.addAction(back)
            
            present(emptycheck, animated: true)
            
        }
        
        if phoneno == false && email == false {
            
            let emailcheck = UIAlertController(title: "Warning", message: "Invalid Phone Number and Email. Please Try Again", preferredStyle: .alert)
            
            let back = UIAlertAction(title: "Return", style: .cancel, handler: nil)
            
            emailcheck.addAction(back)
            
            present(emailcheck, animated: true)
            
            tfPhoneNo.text = ""
            tfEmail.text = ""
            
        }
        
        if phoneno == false{
            
            let emailcheck = UIAlertController(title: "Warning", message: "Invalid Phone Number. Please Try Again", preferredStyle: .alert)
            
            let back = UIAlertAction(title: "Return", style: .cancel, handler: nil)
            
            emailcheck.addAction(back)
            
            present(emailcheck, animated: true)
            
            tfPhoneNo.text = ""
            
        }
        
        if email == false{
            let emailcheck = UIAlertController(title: "Warning", message: "Invalid Email. Please Try Again", preferredStyle: .alert)
            
            let back = UIAlertAction(title: "Return", style: .cancel, handler: nil)
            
            emailcheck.addAction(back)
            
            present(emailcheck, animated: true)
            
            tfEmail.text = ""
        }
        
        else {
            let msg = "Thank you " + self.tfName.text! + ", " + self.tfEmail.text! +  ", for your time"
            
            let alert = UIAlertController(title: "Submitted Information", message: msg, preferredStyle: .alert)
            
            //let yesAction = UIAlertAction(title: "Yes", style: .default, handler: nil)
            //Embedding method calls
            let yesAction = UIAlertAction(title: "Main Menu", style: .default, handler:
            {
                (alert : UIAlertAction!) in
            
                self.doTheUpdate(sender: Any)
                
                //Dismisses alert box after clicking
                self.dismiss(animated: true, completion: nil)
            }
                
            )
            
            let noAction = UIAlertAction(title: "Return", style: .cancel, handler: nil)
            
            alert.addAction(yesAction)
            alert.addAction(noAction)
            
            present(alert, animated: true)
        }
    } */
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func validateEmail(testStr:String) -> Bool {
        let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailReg)
        return emailTest.evaluate(with: testStr)
    }
    
    func validatePhoneNo(value: String) -> Bool {
        let phoneReg = "^\\d{3}\\d{3}\\d{4}$"
        
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneReg)
        return phoneTest.evaluate(with: value)
    }

    
    @IBAction func clearField(sender: Any){
        
        tfName.text = ""
        tfAddress.text = ""
        tfPhoneNo.text = ""
        tfEmail.text = ""
        ageSlider.value = 21
        sgGender.selectedSegmentIndex = 0
        updateAgeLabel()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateAgeLabel()
        updateSprite()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
